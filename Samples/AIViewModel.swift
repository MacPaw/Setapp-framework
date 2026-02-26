import Setapp
import SetappAI
import SwiftUI
import Combine

// MARK: - Message Model

struct ChatMessage: Identifiable, Equatable, Codable {
    let id: String
    let role: SetappAIAPI.Responses.Role
    let content: String
    let timestamp: Date

    init(id: String = UUID().uuidString, role: SetappAIAPI.Responses.Role, content: String, timestamp: Date = Date()) {
        self.id = id
        self.role = role
        self.content = content
        self.timestamp = timestamp
    }
}

// MARK: - Conversation State

struct ConversationState: Codable {
    var lastResponseId: String?
    var selectedModelId: String?

    init(lastResponseId: String? = nil, selectedModelId: String? = nil) {
        self.lastResponseId = lastResponseId
        self.selectedModelId = selectedModelId
    }
}

// MARK: - View Model

@Observable
@MainActor
class AIViewModel {
#if os(iOS)
    var isActivated: Bool = false
#endif

    // Models
    var availableModels: [SetappAIAPI.Model] = []
    var isLoadingModels = false
    var modelsError: Error?

    // Conversation state
    var state = ConversationState()
    var messages: [ChatMessage] = []
    var prompt: String = ""
    var isStreaming = false
    var streamingError: Error?

    private var streamingTask: Task<Void, Never>?
    private var subscriptionCancellable: AnyCancellable?
    private var currentStreamingContent: String = ""

    private static let conversationStateKey = "AIViewModel.conversationState"

    init() {
#if os(iOS)
        subscriptionCancellable = SetappManager.shared.publisher(for: \.subscription)
            .sink { [weak self] subscription in
                self?.isActivated = subscription?.isActive ?? false
            }
#endif

        self.loadConversationState()
    }

    var selectedModel: SetappAIAPI.Model? {
        availableModels.first { $0.id == state.selectedModelId }
    }

    var canSendMessage: Bool {
        !isStreaming && !prompt.isEmpty && selectedModel != nil
    }

    // MARK: - Models API

    func loadModels() {
        isLoadingModels = true
        modelsError = nil

        Task {
            do {
                let models = try await SetappManager.shared.ai.models.list()
                self.availableModels = models

                // Auto-select first model if none selected
                if self.state.selectedModelId == nil, let firstModel = models.first {
                    self.state.selectedModelId = firstModel.id
                    self.saveConversationState()
                }

                self.isLoadingModels = false
            } catch {
                self.modelsError = error
                self.isLoadingModels = false
            }
        }
    }

    // MARK: - Conversation Management

    func clearConversation() {
        state = ConversationState(selectedModelId: state.selectedModelId)
        prompt = ""
        streamingError = nil
        messages = []
        saveConversationState()
    }

    // MARK: - Persistence

    private func saveConversationState() {
        if let encoded = try? JSONEncoder().encode(state) {
            UserDefaults.standard.set(encoded, forKey: Self.conversationStateKey)
        }
    }

    private func loadConversationState() {
        guard let data = UserDefaults.standard.data(forKey: Self.conversationStateKey),
              let decoded = try? JSONDecoder().decode(ConversationState.self, from: data) else {
            return
        }
        state = decoded
    }

    // MARK: - Streaming API

    func sendMessage() {
        guard let model = selectedModel, !prompt.isEmpty else { return }

        // Cancel any existing stream
        cancelStreaming()

        // Add user message
        let userMessage = ChatMessage(role: .user, content: prompt)
        messages.append(userMessage)

        // Clear prompt
        let messageContent = prompt
        prompt = ""

        isStreaming = true
        streamingError = nil
        currentStreamingContent = ""

        streamingTask = Task {
            do {
                let stream = try await SetappManager.shared.ai.responses.createStream(
                    model: model,
                    input: [.message(messageContent)],
                    previousResponseID: self.state.lastResponseId, // Use for keeping conversation context
                    include: [.messageOutputTextLogprobs],
                    store: true,
                    temperature: 0.5,
                    streamOptions: .init(includeObfuscation: false)
                )

                let assistantMessageId = UUID().uuidString
                let assistantMessage = ChatMessage(id: assistantMessageId, role: .assistant, content: "")
                self.messages.append(assistantMessage)

                // Process streaming events
                for try await event in stream {
                    guard !Task.isCancelled else {
                        self.updateLastMessage(content: self.currentStreamingContent + "\n\n⚠️ Stream cancelled")
                        break
                    }

                    // Handle text deltas
                    if case let .response(.outputText(.delta(delta))) = event {
                        self.currentStreamingContent += delta.delta
                        self.updateLastMessage(content: self.currentStreamingContent)
                    }

                    if case let .response(.responseLifecycle(.completed(lifecycleEvent))) = event {
                        state.lastResponseId = lifecycleEvent.response.id
                    }
                }

                if !Task.isCancelled {
                    // Finalize message
                    self.updateLastMessage(content: self.currentStreamingContent)
                }

                self.currentStreamingContent = ""
                self.isStreaming = false
                self.saveConversationState()

            } catch is CancellationError {
                self.updateLastMessage(content: self.currentStreamingContent + "\n\n⚠️ Stream cancelled")
                self.currentStreamingContent = ""
                self.isStreaming = false
                self.saveConversationState()
            } catch {
                self.streamingError = error
                self.updateLastMessage(content: self.currentStreamingContent + "\n\n❌ Error: \(error.localizedDescription)")
                self.currentStreamingContent = ""
                self.isStreaming = false
                self.saveConversationState()
            }
        }
    }

    func cancelStreaming() {
        streamingTask?.cancel()
        streamingTask = nil
    }

    private func updateLastMessage(content: String) {
        guard let lastIndex = messages.indices.last else { return }
        let lastMessage = messages[lastIndex]
        messages[lastIndex] = ChatMessage(
            id: lastMessage.id,
            role: lastMessage.role,
            content: content,
            timestamp: lastMessage.timestamp
        )
    }
}

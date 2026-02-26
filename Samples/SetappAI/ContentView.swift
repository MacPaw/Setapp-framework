import SwiftUI

struct ContentView: View {
    @State private var viewModel = AIViewModel()

    var body: some View {
        ZStack {
            Color.clear
            ScrollViewReader { proxy in
                ScrollView {
                    VStack(spacing: 20) {
                        #if os(iOS)
                        if !viewModel.isActivated {
                            activationWarningView
                            Divider()
                        }
                        #endif

                        // Combined error display
                        if let error = viewModel.modelsError {
                            errorView(type: "Models Error", error: error)
                            Divider()
                        } else if let error = viewModel.streamingError {
                            errorView(type: "Streaming Error", error: error)
                            Divider()
                        }

                        modelsSection
                        Divider()
                        conversationSection
                        Divider()
                        chatSection
                    }
                    .padding()
                }
                .onChange(of: viewModel.messages.count) { oldValue, newValue in
                    if let lastMessage = viewModel.messages.last {
                        withAnimation {
                            proxy.scrollTo(lastMessage.id, anchor: .bottom)
                        }
                    }
                }
            }
        }
        .navigationTitle("SetappAI Sample")
#if os(iOS)
        .navigationBarTitleDisplayMode(.inline)
#endif
    }


    #if os(iOS)
    private var activationWarningView: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.title3)
                .foregroundColor(.orange)
            VStack(alignment: .leading, spacing: 4) {
                Text("App Not Activated")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.orange)
                Text("This iOS app is not activated with Setapp. To use SetappAI features, please activate the app using a QR code or deep link from the Setapp macOS client.")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
            Spacer()
        }
        .padding()
        .background(Color.orange.opacity(0.1))
        .cornerRadius(8)
    }
    #endif

    // MARK: - Models Section

    private var modelsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Available Models")
                .font(.headline)
                .bold()

            Button {
                viewModel.loadModels()
            } label: {
                HStack {
                    Image(systemName: "arrow.clockwise")
                    Text("Load Models")
                }
                .frame(maxWidth: .infinity)
            }
            .buttonStyle(.bordered)
            .disabled(viewModel.isLoadingModels)

            if viewModel.isLoadingModels {
                ProgressView("Loading models...")
                    .frame(maxWidth: .infinity)
                    .padding()
            } else if viewModel.availableModels.isEmpty {
                emptyStateView(
                    icon: "square.stack.3d.up.slash",
                    message: "No models loaded yet",
                    hint: "Tap 'Load Models' to fetch available AI models"
                )
            } else {
                modelsListView
            }
        }
    }

    private var modelsListView: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("\(viewModel.availableModels.count) model(s) available")
                .font(.caption)
                .foregroundColor(.secondary)

            Picker("Select Model", selection: $viewModel.state.selectedModelId) {
                ForEach(viewModel.availableModels, id: \.id) { model in
                    Text(model.id).tag(model.id as String?)
                }
            }
            .pickerStyle(.menu)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding()
        .background(Color.secondary.opacity(0.1))
        .cornerRadius(8)
    }

    // MARK: - Conversation Section

    private var conversationSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Conversation Settings")
                .font(.headline)
                .bold()
            
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Image(systemName: "bubble.left.and.bubble.right.fill")
                        .foregroundColor(viewModel.state.lastResponseId != nil ? .green : .gray)
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Active Conversation")
                            .font(.caption)
                            .fontWeight(.semibold)
                        if let lastResponseId = viewModel.state.lastResponseId {
                            Text("ID: \(lastResponseId.prefix(28))...")
                                .font(.caption2)
                                .foregroundColor(.secondary)
                        }
                    }
                    Spacer()
                }
                .padding()
                .background(Color.green.opacity(0.1))
                .cornerRadius(8)

                
                HStack(spacing: 12) {
                    Button(role: .destructive) {
                        viewModel.clearConversation()
                    } label: {
                        HStack {
                            Image(systemName: "trash")
                            Text("Clear")
                        }
                        .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.bordered)
                    .disabled(viewModel.state.lastResponseId == nil)
                }
            }
        }
    }

    // MARK: - Chat Section

    private var chatSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("AI Chat")
                .font(.headline)
                .bold()

            VStack(spacing: 12) {
                modelSelectionInfoView
                promptInputView
                streamActionButtonsView
                chatOutputView
            }
        }
    }

    private var modelSelectionInfoView: some View {
        Group {
            if let selectedModel = viewModel.selectedModel {
                HStack {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.green)
                    Text("Using model: \(selectedModel.id)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Spacer()
                }
                .padding(8)
                .background(Color.green.opacity(0.1))
                .cornerRadius(6)
            } else {
                HStack {
                    Image(systemName: "exclamationmark.circle.fill")
                        .foregroundColor(.orange)
                    Text("Please select a model first")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Spacer()
                }
                .padding(8)
                .background(Color.orange.opacity(0.1))
                .cornerRadius(6)
            }
        }
    }

    private var promptInputView: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Message")
                .font(.caption)
                .foregroundColor(.secondary)
            if #available(iOS 16.0, macOS 13.0, *) {
                TextField("Enter your message here...", text: $viewModel.prompt, axis: .vertical)
                    .textFieldStyle(.roundedBorder)
                    .lineLimit(3...6)
            } else {
                TextEditor(text: $viewModel.prompt)
                    .frame(minHeight: 60, maxHeight: 120)
                    .overlay(
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(Color.secondary.opacity(0.3), lineWidth: 1)
                    )
                    .overlay(
                        Group {
                            if viewModel.prompt.isEmpty {
                                Text("Enter your message here...")
                                    .foregroundColor(.secondary.opacity(0.5))
                                    .padding(.horizontal, 4)
                                    .padding(.vertical, 8)
                            }
                        },
                        alignment: .topLeading
                    )
            }
        }
    }

    private var streamActionButtonsView: some View {
        HStack(spacing: 12) {
            Button {
                viewModel.sendMessage()
            } label: {
                HStack {
                    Image(systemName: "paperplane.fill")
                    Text("Send")
                }
                .frame(maxWidth: .infinity)
            }
            .buttonStyle(.bordered)
            .disabled(!viewModel.canSendMessage)

            Button {
                viewModel.cancelStreaming()
            } label: {
                HStack {
                    Image(systemName: "stop.fill")
                    Text("Cancel")
                }
                .frame(maxWidth: .infinity)
            }
            .buttonStyle(.bordered)
            .disabled(!viewModel.isStreaming)
        }
    }

    private var chatOutputView: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text("Chat History")
                    .font(.caption)
                    .foregroundColor(.secondary)
                Spacer()
                if viewModel.isStreaming {
                    ProgressView()
                        .scaleEffect(0.7)
                }
            }

            if viewModel.messages.isEmpty {
                VStack(spacing: 12) {
                    Image(systemName: "bubble.left.and.bubble.right")
                        .font(.system(size: 40))
                        .foregroundColor(.secondary)
                    Text("No messages yet")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    Text("Send a message to start chatting")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity)
                .frame(minHeight: 200)
                .background(Color.secondary.opacity(0.1))
                .cornerRadius(8)
            } else {
                ScrollView {
                    LazyVStack(spacing: 12) {
                        ForEach(viewModel.messages) { message in
                            MessageBubbleView(message: message)
                                .id(message.id)
                        }
                    }
                    .padding(8)
                }
                .frame(minHeight: 200, maxHeight: 400)
                .background(Color.secondary.opacity(0.1))
                .cornerRadius(8)
            }
        }
    }

    // MARK: - Helper Views

    private func errorView(type: String, error: Error) -> some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.title3)
                .foregroundColor(.red)
            VStack(alignment: .leading, spacing: 4) {
                Text(type)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.red)
                Text(error.localizedDescription)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
            Spacer()
        }
        .padding()
        .background(Color.red.opacity(0.1))
        .cornerRadius(8)
    }

    private func emptyStateView(icon: String, message: String, hint: String) -> some View {
        VStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 40))
                .foregroundColor(.secondary)
            Text(message)
                .font(.subheadline)
                .foregroundColor(.secondary)
            Text(hint)
                .font(.caption)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding()
    }

}

// MARK: - Message Bubble View

struct MessageBubbleView: View {
    let message: ChatMessage

    private var bubbleBackgroundColor: Color {
        if message.role == .user {
            return Color.accentColor
        } else {
            #if os(iOS)
            return Color(uiColor: .secondarySystemBackground)
            #else
            return Color(nsColor: .controlBackgroundColor)
            #endif
        }
    }

    var body: some View {
        HStack {
            if message.role == .user {
                Spacer()
            }

            VStack(alignment: message.role == .user ? .trailing : .leading, spacing: 4) {
                Text(message.content)
                    .padding(12)
                    .background(bubbleBackgroundColor)
                    .foregroundColor(message.role == .user ? .white : .primary)
                    .cornerRadius(16)

                Text(message.timestamp, style: .time)
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }

            if message.role == .assistant {
                Spacer()
            }
        }
    }
}

// MARK: - Preview

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ContentView()
        }
    }
}

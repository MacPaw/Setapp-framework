const requestAuthCodeButton = document.getElementById('request-auth-code-button');
const askForEmailButton = document.getElementById('ask-for-email-button');
const showReleaseNotesButton = document.getElementById('show-release-notes-button');

requestAuthCodeButton.addEventListener('click', () => {
    window.setappBridge.showRequestAuthCodeForm();
});

askForEmailButton.addEventListener('click', () => {
    window.setappBridge.askForEmail();
});

showReleaseNotesButton.addEventListener('click', () => {
    window.setappBridge.showReleaseNotes();
});

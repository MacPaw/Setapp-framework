const requestButton = document.getElementById('request-button');
const shareEmailButton = document.getElementById('share-email-button');
const releaseNotesButton = document.getElementById('release-notes-button');
const clientIDField = document.getElementById('client-id');
const scopeField = document.getElementById('scope');
const requestResponseFiled = document.getElementById('response-log');


requestButton.addEventListener('click', async () => {
    const clientID = clientIDField.value;
    const scope = scopeField.value;
    const response = await window.electronAPI.requstButtonAction([clientID, scope]);
    requestResponseFiled.innerHTML = response;
});

shareEmailButton.addEventListener('click', () => {
    window.electronAPI.shareEmailButtonAction();
});

releaseNotesButton.addEventListener('click', () => {
    window.electronAPI.releaseNotesButtonAction();
});

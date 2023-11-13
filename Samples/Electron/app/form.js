const clientIDField = document.getElementById('clientID');
const scopesField = document.getElementById('scopes');
const submitButton = document.getElementById('submitButton');

submitButton.addEventListener('click', () => {
   window.setappBridge.requestAuthCode(clientIDField.value, scopesField.value);
});

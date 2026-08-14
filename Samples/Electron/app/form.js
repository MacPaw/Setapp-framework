const clientIDField = document.getElementById('clientID');
const submitButton = document.getElementById('submitButton');

submitButton.addEventListener('click', () => {
   window.setappBridge.requestAuthCode(clientIDField.value);
});

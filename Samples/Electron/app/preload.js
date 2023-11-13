const { contextBridge, ipcRenderer } = require('electron')

contextBridge.exposeInMainWorld('setappBridge', {
    askForEmail: () => ipcRenderer.send('askForEmail', []),
    showReleaseNotes: () => ipcRenderer.send('showReleaseNotes', []),
    showRequestAuthCodeForm: () => ipcRenderer.send('showRequestAuthCodeForm', []),
    requestAuthCode: (clientID, scopes) => ipcRenderer.send('requestAuthCode', [clientID, scopes])
})

const { contextBridge, ipcRenderer } = require('electron')

contextBridge.exposeInMainWorld('electronAPI', {
    requstButtonAction: (args) => ipcRenderer.invoke('requestAuthorizationCodeBtnClick', args),
    shareEmailButtonAction: () => ipcRenderer.send('emailBtnClick', []),
    releaseNotesButtonAction: () => ipcRenderer.send('releaseNotesBtnClick', [])
})

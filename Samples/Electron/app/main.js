const {
  app,
  BrowserWindow,
  ipcMain,
  dialog
} = require('electron')

const {
  SetappManager,
  SETAPP_USAGE_EVENT,
  SETAPP_LOG_LEVEL
} = require('@setapp/framework-wrapper');

const path = require('path');

let window;
let formWindow;

// Setup

app.on('ready', () => {
  window = new BrowserWindow({
    width: 714,
    minWidth: 714,
    maxWidth: 714,
    height: 518,
    minHeight: 518,
    maxHeight: 518,
    minimizable: false,
    maximizable: false,
    webPreferences: {
      preload: path.join(__dirname, 'preload.js'),
      nodeIntegration: true
    }
  });

  window.loadFile(path.join(__dirname, 'index.html'));

  // Set log level
  const verboseLogLevel = SETAPP_LOG_LEVEL.VERBOSE;
  SetappManager.logLevel = verboseLogLevel;

  // Show release notes if needed
  SetappManager.shared.showReleaseNotesWindowIfNeeded();
});

// Actions Handling

ipcMain.on('showRequestAuthCodeForm', ()  => {
    formWindow = new BrowserWindow({
        width: 250,
        minWidth: 250,
        maxWidth: 250,
        height: 350,
        minHeight: 350,
        maxHeight: 350,
        minimizable: false,
        maximizable: false,
        webPreferences: {
            preload: path.join(__dirname, 'preload.js'),
            nodeIntegration: true
        }
    });
    formWindow.loadFile(path.join(__dirname,'form.html'));
});

ipcMain.on('requestAuthCode', (clientID, scopes) => {
    formWindow.close()

    let clientIDString = String(clientID);
    let scopesString = String(scopes);
    let scopesArray = scopesString.split(/\s+/);

    SetappManager.shared.requestAuthorizationCode(clientID, scopesArray, (authCode, error) => {
      if (authCode) {
        dialog.showMessageBox({ type: 'info', title: 'Success', message: 'Received Code: ' + authCode });
      }
      if (error) {
          dialog.showMessageBox({ type: 'error', title: 'Error', message: String(error) });
      }
    });
});

ipcMain.on('showReleaseNotes', () => {
  SetappManager.shared.showReleaseNotesWindow();
});

ipcMain.on('askForEmail', () => {
  SetappManager.shared.askUserToShareEmail();
});

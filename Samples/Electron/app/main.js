const {app, BrowserWindow, ipcMain} = require('electron');
const path = require('path');
const log = require('electron-log');
console.log = log.log;

const { SetappManager, SETAPP_USAGE_EVENT, SETAPP_LOG_LEVEL } = require('setapp-framework');

let mainWindow;

ipcMain.handle('requestAuthorizationCodeBtnClick', async (event, args) => {
  const clientID = args[0].toString();
  const scope = args[1];

  if (!clientID.toString().trim() || !scope.toString().trim()) {
    return "⚠️ Warning. Client ID or Scope is not defined. Enter valid data to request authorization code.";
  }

  const scopeArray = scope.toString().split(' ');
  log.info('Request authorization code');
  const response = await new Promise((resolve, reject) => {
    SetappManager.shared.requestAuthorizationCode(clientID, scopeArray, (authCode, error) => {
      if (authCode) {
        resolve('✅ Success. Request authorization code: ' + authCode);
      }
      if (error) {
        resolve('❌ Failure. Request authorization code error: ' + error);
      }
    });
  });
  return response;
})

ipcMain.on('emailBtnClick', (event, args) => {
  // User Permissions API
  log.info('Ask to share email');
  SetappManager.shared.askUserToShareEmail();
});

ipcMain.on('releaseNotesBtnClick', (event, args) => {
  // Release Notes API
  log.info('Show release notes window.');
  SetappManager.shared.showReleaseNotesWindow();
});

// Log handle
function logHandle(message, logLevel) {
  switch (logLevel) {
  case SETAPP_LOG_LEVEL.VERBOSE:
    log.verbose(message);
    break;
  case SETAPP_LOG_LEVEL.DEBUG:
    log.debug(message);
    break;
  case SETAPP_LOG_LEVEL.INFO:
    log.info(message);
    break;
  case SETAPP_LOG_LEVEL.WARNING:
    log.warn(message);
    break;
  case SETAPP_LOG_LEVEL.ERROR:
    log.error(message);
    break;
  case SETAPP_LOG_LEVEL.OFF:
    break;
  default:
    log.warn("Unknown log level: "+ logLevel)
    break;
  }
}

app.on('ready', () => {
  mainWindow = new BrowserWindow({
    height: 600,
    width: 800,
    minHeight: 478,
    minWidth: 622,
    webPreferences: {
      preload: path.join(__dirname, 'preload.js'),
      nodeIntegration: true
    }
  });

  mainWindow.loadURL('file://' + __dirname + '/index.html');

  // Set log handle
  log.info('Set log handle');
  SetappManager.setLogHandle(logHandle);

  log.info('Current log level: ' + SetappManager.logLevel);

  // Set log level
  const newLogLevel = SETAPP_LOG_LEVEL.VERBOSE;
  log.info('Set log level to ' + newLogLevel);
  SetappManager.logLevel = newLogLevel;

  // Release Notes API
  log.info('Show release notes if needed.');
  SetappManager.shared.showReleaseNotesWindowIfNeeded();

  // Usage Events API
  log.info('Report usage event');
  SetappManager.shared.reportUsageEvent(SETAPP_USAGE_EVENT.USER_INTERACTION);
});

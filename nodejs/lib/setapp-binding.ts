import SetappError from '../scripts/setapp_error';
import { SETAPP_USAGE_EVENT, SETAPP_LOG_LEVEL } from './setapp-constants';

type SetappUsageEvent = typeof SETAPP_USAGE_EVENT[keyof typeof SETAPP_USAGE_EVENT];
type SetappLogLevel = typeof SETAPP_LOG_LEVEL[keyof typeof SETAPP_LOG_LEVEL];

type SetappManager = {
  shared: {
    showReleaseNotesWindowIfNeeded: () => void;
    showReleaseNotesWindow: () => void;
    requestAuthorizationCode: (
      clientID: string, 
      scope: string[], 
      callback: (authorizationCode?: string, error?: string) => void
    ) => void;
    reportUsageEvent: (event: SetappUsageEvent) => void;
    askUserToShareEmail: () => void;
  }
  setLogHandle: (callback: (message: string, logLevel: SetappLogLevel) => void) => void;
  logLevel: SetappLogLevel;
}

let binding: { SetappManager: SetappManager };

try {
  binding = require('./binding/node_setapp_binding.node');
} catch (error: any) {
  if (error.code === 'MODULE_NOT_FOUND') {
    throw new SetappError('noBinary');
  }
  throw error;
}

export { binding };

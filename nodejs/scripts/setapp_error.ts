const MESSAGES = {
  noBinary: () => 'There is no Setapp binary. Please, check configuration and reinstall node modules or run `npx electron-rebuild --force`',
}

type MessagesKeys = keyof typeof MESSAGES;

class SetappError extends Error {
  // Args are not used in messages for now and passing them to super raises an error
  // but might be handy in the future
  constructor (type: MessagesKeys, ...args: string[]) {
    super(MESSAGES[type]())

    this.name = 'SetappError';
  }
}

export default SetappError;

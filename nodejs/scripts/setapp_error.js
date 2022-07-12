const MESSAGES = {
  noBinary: () => 'There is no Setapp binary. Please, check configuration and reinstall node modules or run `npx electron-rebuild --force`',
}

class SetappError extends Error {
  constructor (type, ...args) {
    super(MESSAGES[type](...args))

    this.name = 'SetappError';
  }
}

module.exports = SetappError;

require('dotenv').config({ path: '.env.local' });
const { notarize } = require('@electron/notarize');
const fs = require('fs');
const chalk = require('chalk');

function cleanup(api_key_filename, private_keys_folder, is_private_keys_folder_exists) {
  try {
    if (fs.existsSync(api_key_filename)) {
      fs.unlinkSync(api_key_filename);
    }
    if (!is_private_keys_folder_exists && fs.existsSync(private_keys_folder)) {
      fs.rmdirSync(private_keys_folder, { recursive: false });
    }
  } catch (error) {
    console.error(error)
  }
}

exports.default = async function notarizing(context) {
  const { electronPlatformName, appOutDir } = context;
  if (electronPlatformName !== 'darwin') {
    return;
  }
  if (process.env.NOTARIZE !== 'true') {
    console.info('  • Skipping notarization.\n    If you want to enable notarization, please add \'.env.local\' as described in the README.md. file');
    return;
  }

  const app_name = context.packager.appInfo.productFilename;
  const app_path = `${appOutDir}/${app_name}.app`
  const project_root_dir = context.packager.info.projectDir + '/';
  const short_app_path = app_path.replace(new RegExp(project_root_dir, "g"), '');

  const private_keys_folder = './private_keys'
  const api_key = Buffer.from(process.env.APP_STORE_CONNECT_API_KEY_KEY, 'base64').toString();
  const api_key_filename_suffix = process.env.APP_STORE_CONNECT_API_KEY_KEY_ID;

  const regex = new RegExp('[A-Z0-9]{10,}$');
  if (!regex.test(api_key_filename_suffix)) {
      throw new Error('APP_STORE_CONNECT_API_KEY_KEY_ID does not match regex pattern.');
  }

  const api_key_filename = private_keys_folder + '/AuthKey_' + api_key_filename_suffix + '.p8';

  var is_private_keys_folder_exists = true;
  if (!fs.existsSync(private_keys_folder)){
    fs.mkdirSync(private_keys_folder);
    is_private_keys_folder_exists = false;
  }

  fs.writeFileSync(api_key_filename, api_key);

  console.log('  ' + chalk.blue('•') + ' notarizing      ' + chalk.blue('app') + `=${short_app_path}`);

  var notarization_result = null;
  try {
    notarization_result = await notarize({
      appBundleId: 'com.setapp.library.test-app-setapp',
      appPath: `${appOutDir}/${app_name}.app`,
      appleApiKey: api_key_filename_suffix,
      appleApiIssuer: process.env.APP_STORE_CONNECT_API_KEY_ISSUER_ID,
    });
  } catch (error) {
    throw error;
  } finally {
    cleanup(api_key_filename, private_keys_folder, is_private_keys_folder_exists)
  }

  return notarization_result;
};

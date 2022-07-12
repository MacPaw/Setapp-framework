#import "SetappManager.h"

Napi::FunctionReference SetappManager::constructor;
Napi::ObjectReference sharedContextRef;
Napi::ThreadSafeFunction logHandleThreadSafeCallback;

Napi::Value GetSharedSetappManager(const Napi::CallbackInfo& info);
Napi::Value GetLogLevel(const Napi::CallbackInfo& info);
void SetLogLevel(const Napi::CallbackInfo& info, const Napi::Value& value);
const char * randomString();
NSString * localizedErrorDescription(NSError * nsError);

Napi::Object SetappManager::InitClassModule(Napi::Env env, Napi::Object exports, STPManager * setappManager)
{
  Napi::Function func = DefineClass(
    env,
    "SetappManager", 
    {
      StaticAccessor("shared", &GetSharedSetappManager, nullptr, napi_static),

      InstanceMethod("showReleaseNotesWindowIfNeeded", &SetappManager::showReleaseNotesWindowIfNeeded),
      InstanceMethod("showReleaseNotesWindow", &SetappManager::showReleaseNotesWindow),
      InstanceMethod("requestAuthorizationCode", &SetappManager::requestAuthorizationCode),
      InstanceMethod("reportUsageEvent", &SetappManager::reportUsageEvent),
      InstanceMethod("askUserToShareEmail", &SetappManager::askUserToShareEmail),

      StaticMethod("setLogHandle", &SetappManager::setLogHandle),
      StaticAccessor("logLevel", &GetLogLevel, &SetLogLevel, napi_static)
    }
    );

  constructor = Napi::Persistent(func);
  constructor.SuppressDestruct();

  exports.Set("SetappManager", func);

  Napi::Object sharedSetappManager = SetappManager::NewInstance(env, setappManager);
  
  sharedContextRef = Napi::Persistent(Napi::Object::New(env));
  sharedContextRef.SuppressDestruct();
  sharedContextRef.Value().Set("setappManager", sharedSetappManager);

  return exports;
}

SetappManager::SetappManager(const Napi::CallbackInfo& info) : Napi::ObjectWrap<SetappManager>(info) 
{
  this->_setappManager = info[0].As<const Napi::External<STPManager>>().Data();
}

Napi::Object SetappManager::NewInstance(Napi::Env env, STPManager * setappManager) 
{
  Napi::EscapableHandleScope scope(env);
  Napi::Object obj = constructor.New({ Napi::External<STPManager>::New(env, setappManager) });
  return scope.Escape(napi_value(obj)).ToObject();
}

void SetappManager::showReleaseNotesWindowIfNeeded(const Napi::CallbackInfo& info) 
{
  [this->_setappManager showReleaseNotesWindowIfNeeded];
}

void SetappManager::showReleaseNotesWindow(const Napi::CallbackInfo& info) 
{
  [this->_setappManager showReleaseNotesWindow];
}

void SetappManager::requestAuthorizationCode(const Napi::CallbackInfo& info) 
{
  Napi::Env env = info.Env();
  
  std::string utf8ClientID = info[0].ToString().Utf8Value();
  NSString * objcClientID = [NSString stringWithUTF8String:utf8ClientID.c_str()] ?: @"";  

  NSMutableArray * objcScopes = [[NSMutableArray alloc] init];
  Napi::Array napiScopes = info[1].As<Napi::Array>();
  for (uint32_t i = 0, napiScopesLength = napiScopes.Length(); i < napiScopesLength; i++) 
  {
    std::string utf8ScopeString = static_cast<Napi::Value>(napiScopes[i]).ToString().Utf8Value();
    NSString * scopeString = [NSString stringWithUTF8String:utf8ScopeString.c_str()] ?: @"";
    [objcScopes addObject:scopeString];
  }

  Napi::Function napiCallback = info[2].As<Napi::Function>();
  Napi::ThreadSafeFunction napiThreadSafeCallback = Napi::ThreadSafeFunction::New(env, napiCallback, randomString(), 0, 1);

  [this->_setappManager requestAuthorizationCodeWithClientID:objcClientID scope: objcScopes completionHandler:^(NSString * _Nullable nsAuthCode, NSError * _Nullable nsAuthCodeError) {
    // MRC retain.
    [nsAuthCode retain];
    [nsAuthCodeError retain];

    auto callback = [nsAuthCode, nsAuthCodeError](Napi::Env env, Napi::Function jsCallback) {
      Napi::Value napiCode;
      if (nsAuthCode)
      {
        napiCode = Napi::String::New(env, [nsAuthCode UTF8String]);
      }
      else
      {
          napiCode = env.Null();
      }

      Napi::Value napiError;
      if (nsAuthCodeError)
      {
          if (nsAuthCodeError.localizedDescription)
          {
              napiError = Napi::String::New(env, [localizedErrorDescription(nsAuthCodeError) UTF8String]);
          }
          else
          {
              napiError = Napi::String::New(env, "Unknown error happened");
          }
      }
      else
      {
          napiError = env.Null();
      }

      jsCallback.Call({ napiCode, napiError });

      // MRC release.
      [nsAuthCodeError release];
      [nsAuthCode release];
    }; 

    napiThreadSafeCallback.NonBlockingCall(callback);
    napiThreadSafeCallback.Release();
  }];
}

void SetappManager::reportUsageEvent(const Napi::CallbackInfo& info) 
{
  STPUsageEvent usageEvent = STPUsageEvent(info[0].ToNumber().Int64Value());
  [this->_setappManager reportUsageEvent:usageEvent];
}

void SetappManager::askUserToShareEmail(const Napi::CallbackInfo& info) 
{
  [this->_setappManager askUserToShareEmail];
}

// Shared singleton instance

Napi::Value GetSharedSetappManager(const Napi::CallbackInfo& info)
{
  return sharedContextRef.Value().Get("setappManager");
}

// Logs    

Napi::Value GetLogLevel(const Napi::CallbackInfo& info)
{
  Napi::Env env = info.Env();

  return Napi::Number::New(env, STPManager.logLevel);
}

void SetLogLevel(const Napi::CallbackInfo& info, const Napi::Value& value)
{
  STPLogLevel logLevel = STPLogLevel(value.ToNumber().Int64Value()); 
  STPManager.logLevel = logLevel;
}

void SetappManager::setLogHandle(const Napi::CallbackInfo& info) 
{
  Napi::Env env = info.Env();
  
  if (logHandleThreadSafeCallback)
  {
    logHandleThreadSafeCallback.Release();
    logHandleThreadSafeCallback = nil;
  }

  Napi::Function napiCallback = info[0].As<Napi::Function>();
  logHandleThreadSafeCallback = Napi::ThreadSafeFunction::New(env, napiCallback, randomString(), 0, 1);

  [STPManager setLogHandle:^(NSString * _Nonnull nsMessage, enum STPLogLevel nsLogLevel) {
    [nsMessage retain];

    auto callback = [nsMessage, nsLogLevel](Napi::Env env, Napi::Function jsCallback) {
      Napi::Value napiMessage = Napi::String::New(env, [nsMessage UTF8String]);
      Napi::Value napiLogLevel = Napi::Number::New(env, nsLogLevel);

      jsCallback.Call({ napiMessage, napiLogLevel });

      [nsMessage release];
    };

    logHandleThreadSafeCallback.NonBlockingCall(callback);
  }];
}

// Helpers

const char * randomString()
{
  return [[[NSProcessInfo processInfo] globallyUniqueString] UTF8String];
} 

NSString * localizedErrorDescription(NSError * nsError) 
{
  NSMutableArray * localizedErrorDescriptions = [[NSMutableArray alloc] init];
  NSError * error = nsError;
  while (error != nil)
  {

    NSMutableArray * localizedStrings = [
      @[
        error.localizedDescription ?: @"",
        error.localizedFailureReason ?: @"",
        error.localizedRecoverySuggestion ?: @""
      ] mutableCopy];
    [localizedStrings removeObjectIdenticalTo:@""];

    [localizedErrorDescriptions addObject:localizedStrings];

    error = error.userInfo[NSUnderlyingErrorKey];
  }
  return [localizedErrorDescriptions componentsJoinedByString:@" "];
}

// Module init

Napi::Object InitModule(Napi::Env env, Napi::Object exports)
{
  SetappManager::InitClassModule(env, exports, STPManager.sharedInstance);
  return exports;
}

NODE_API_MODULE(NODE_GYP_MODULE_NAME, InitModule);

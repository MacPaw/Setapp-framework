#ifndef SETAPPMANAGERJS_H
#define SETAPPMANAGERJS_H

#import <Foundation/Foundation.h>
#import <napi.h>
#import <Setapp.h>

class SetappManager : public Napi::ObjectWrap<SetappManager> {
  public:
    // Shared singleton instance
    static Napi::Object shared;

    // Methods
    void showReleaseNotesWindowIfNeeded(const Napi::CallbackInfo& info);
    void showReleaseNotesWindow(const Napi::CallbackInfo& info);
    void requestAuthorizationCode(const Napi::CallbackInfo& info);
    void reportUsageEvent(const Napi::CallbackInfo& info);
    void askUserToShareEmail(const Napi::CallbackInfo& info);

    // Log level    
    static Napi::Value logLevel;
    static void setLogHandle(const Napi::CallbackInfo& info);

    // Instance initializers
    SetappManager(const Napi::CallbackInfo& info);
    static Napi::Object NewInstance(Napi::Env env, STPManager* setappManager);

    // Module initializer
    static Napi::Object InitClassModule(Napi::Env env, Napi::Object exports, STPManager* setappManager);

  private:
    STPManager *_setappManager;
    static Napi::FunctionReference constructor;
};

#endif

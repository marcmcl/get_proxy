#import "GetProxyPlugin.h"

@implementation GetProxyPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"get_proxy"
            binaryMessenger:[registrar messenger]];
  GetProxyPlugin* instance = [[GetProxyPlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
  if ([@"getPlatformVersion" isEqualToString:call.method]) {
    result([@"iOS " stringByAppendingString:[[UIDevice currentDevice] systemVersion]]);
  } else {
    result(FlutterMethodNotImplemented);
  }
}

std::string getProxy()
{

    CFDictionaryRef dicRef = CFNetworkCopySystemProxySettings();
    const CFStringRef proxyCFstr = (const CFStringRef)CFDictionaryGetValue(dicRef, (const void*)kCFNetworkProxiesHTTPProxy);
    const CFNumberRef portCFnum = (const CFNumberRef)CFDictionaryGetValue(dicRef, (const void*)kCFNetworkProxiesHTTPPort);
    char buffer[4096];
    memset(buffer, 0, 4096);
    SInt32 port;
    if (CFStringGetCString(proxyCFstr, buffer, 4096, kCFStringEncodingUTF8))
    {
      if (CFNumberGetValue(portCFnum, kCFNumberSInt32Type, &port))
      {
        return [stringWithFormat: @"PROXY %s:%d", std::string(buffer), port];
      } else {
        return [stringWithFormat: @"PROXY %s", std::string(buffer)];
      }
    }
    return "";
}


@end

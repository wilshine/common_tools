#import "XpToolPlugin.h"
#if __has_include(<xp_tool/xp_tool-Swift.h>)
#import <xp_tool/xp_tool-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "xp_tool-Swift.h"
#endif

@implementation XpToolPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftXpToolPlugin registerWithRegistrar:registrar];
}
@end

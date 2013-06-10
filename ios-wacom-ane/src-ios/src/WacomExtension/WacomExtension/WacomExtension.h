#import "FlashRuntimeExtensions.h"
#import "WacomDeviceFramework.h"

// TODO: remove alert delegate
@interface WacomExtension : NSObject <WacomDiscoveryCallback, WacomStylusEventCallback>
+(WacomExtension *)instance;
@end
#import "WacomExtension.h"

FREContext WacomExtensionCtx = nil;

@implementation WacomExtension

#pragma mark - Singleton

static WacomExtension *instance = nil;

+(WacomExtension *)instance {
    if( !instance ) {
        instance = [ [ super allocWithZone:NULL ] init ];
    }
    return instance;
}

+(id)allocWithZone:(NSZone *)zone {
    return [ self instance ];
}

-(id)copy {
    return self;
}

#pragma mark - WacomDiscoveryCallback, WacomStylusEventCallback

-(void) deviceDiscovered:(WacomDevice *)device {
    NSLog( @"WacomExtension - Discovered a device." );
    
    // TODO: give options for detecting more than 1 device?
    // TODO: once connected, start listening for device disconnection?
    
    // Pick up the device.
    [ [ WacomManager getManager ] selectDevice:(WacomDevice *) device];
    
    // Stop discovering devices.
    [ [ WacomManager getManager ] stopDeviceDiscovery];
    
    // Notify AS3.
    FREDispatchStatusEventAsync( WacomExtensionCtx, (uint8_t*)"wacom/device_discovered", (uint8_t*)[ @"" UTF8String ] );
}

-(void)stylusEvent:(WacomStylusEvent *)stylusEvent {
    switch ( [ stylusEvent getType ] ) {
        case eStylusEventType_BatteryLevelChanged: {
            NSString *batteryStr = [ NSString stringWithFormat:@"%u", [ stylusEvent getBatteryLevel ] ];
            FREDispatchStatusEventAsync( WacomExtensionCtx, (uint8_t*)"wacom/battery_level_changed", (uint8_t*)[ batteryStr UTF8String ] );
            break;
        }
        case eStylusEventType_PressureChange: {
            NSString *pressureStr = [ NSString stringWithFormat:@"%f", [ stylusEvent getPressure ] ];
            FREDispatchStatusEventAsync( WacomExtensionCtx, (uint8_t*)"wacom/pressure_changed", (uint8_t*)[ pressureStr UTF8String ] );
            break;
        }
        case eStylusEventType_ButtonPressed: {
            switch( [ stylusEvent getButton ] ) {
                case 1: {
                    FREDispatchStatusEventAsync( WacomExtensionCtx, (uint8_t*)"wacom/button_1_pressed", (uint8_t*)[ @"" UTF8String ] );
                    break;
                }
                case 2: {
                     FREDispatchStatusEventAsync( WacomExtensionCtx, (uint8_t*)"wacom/button_2_pressed", (uint8_t*)[ @"" UTF8String ] );
                    break;
                }
            }
            break;
        }
        case eStylusEventType_ButtonReleased: {
            switch( [ stylusEvent getButton ] ) {
                case 1: {
                    FREDispatchStatusEventAsync( WacomExtensionCtx, (uint8_t*)"wacom/button_1_released", (uint8_t*)[ @"" UTF8String ] );
                    break;
                }
                case 2: {
                    FREDispatchStatusEventAsync( WacomExtensionCtx, (uint8_t*)"wacom/button_2_released", (uint8_t*)[ @"" UTF8String ] );
                    break;
                }
            }
        }
    }
}

@end

#pragma mark - Initialization

FREObject wacomext_initialize( FREContext ctx, void* funcData, uint32_t argc, FREObject argv[] ) {
    NSLog( @"WacomExtension - Initializing..." );
    
    // Init wacom manager.
    [ [ WacomManager getManager ] registerForNotifications:[ WacomExtension instance ] ];
    
    // Start device discovery.
    // TODO: check if device discovery is turned off in settings and alert
    [ [ WacomManager getManager ] startDeviceDiscovery ];
    
    return NULL;
}

#pragma mark - AS3 bootstrap

void WacomExtensionContextInitializer(void* extData, const uint8_t* ctxType, FREContext ctx, uint32_t* numFunctionsToTest, const FRENamedFunction** functionsToSet) {
    
    *numFunctionsToTest = 1;
    
    FRENamedFunction* func = (FRENamedFunction*) malloc(sizeof(FRENamedFunction) * *numFunctionsToTest);
    
    func[ 0 ].name = (const uint8_t*) "initialize";
    func[ 0 ].functionData = NULL;
    func[ 0 ].function = &wacomext_initialize;
    
    /* DO NOT FORGET TO INCREASE numFunctionsToTest! - AND make sure indices are right */
    
    *functionsToSet = func;
    
    WacomExtensionCtx = ctx;
}

void WacomExtensionInitializer(void** extDataToSet, FREContextInitializer* ctxInitializerToSet, FREContextFinalizer* ctxFinalizerToSet) {
    *extDataToSet = NULL;
    *ctxInitializerToSet = &WacomExtensionContextInitializer;
}
#import "FlashRuntimeExtensions.h"
#import <CoreMotion/CoreMotion.h>

FREContext gyroext_eventContext;
CMMotionManager* motionManager = nil;
NSOperationQueue* opQ = nil;

#pragma mark - Interface

FREObject gyroext_startReadings( FREContext ctx, void* funcData, uint32_t argc, FREObject argv[] ) {
    NSLog( @"GyroscopeExtension - Starting readings..." );
    
    BOOL ret = NO;
	FREObject retVal;
    
	if( motionManager != nil ) {
		if( motionManager.gyroAvailable ) {
            CMGyroHandler gyroHandler = ^ ( CMGyroData *gyroData, NSError *error ) {
                if( ctx != nil ) {
                    CMRotationRate rotate = gyroData.rotationRate;
                    NSString *myStr = [ NSString stringWithFormat:@"%f&%f&%f&%f&%f&%f",
                                       rotate.x,
                                       rotate.y,
                                       rotate.z,
                                       motionManager.deviceMotion.attitude.roll,
                                       motionManager.deviceMotion.attitude.pitch,
                                       motionManager.deviceMotion.attitude.yaw ];
                    if( ctx != nil ) {
//                        NSLog( @"Redings: %@", myStr );
                        FREDispatchStatusEventAsync( ctx, (uint8_t*)"gyroscope/reading", (uint8_t*)[ myStr UTF8String ] );
                    }
                    myStr = nil;
                }
            };
            [ motionManager startGyroUpdatesToQueue:opQ withHandler:gyroHandler ];
            [ motionManager startDeviceMotionUpdates ];
            NSLog( @"Gyroscope started" );
            ret = YES;
		}
        else {
			[ motionManager release ];
			ret = NO;
            NSLog( @"GyroscopeExtension - gyro not available." );
		}
	}
    else {
		ret = NO;
		NSLog( @"GyroscopeExtension - motionManager was NULL. Something is very wrong!" );
	}
    
	FRENewObjectFromBool( ret, &retVal );
    
    return retVal;
}

FREObject gyroext_stopReadings( FREContext ctx, void* funcData, uint32_t argc, FREObject argv[] ) {
    NSLog( @"GyroscopeExtension - Stopping readings..." );
    
    BOOL ret = NO;
	FREObject retVal;
	[ motionManager stopGyroUpdates ];
	FRENewObjectFromBool( ret, &retVal );
	return retVal;
}

#pragma mark - Initialization

FREObject gyroext_initialize( FREContext ctx, void* funcData, uint32_t argc, FREObject argv[] ) {
    NSLog( @"GyroscopeExtension - Initializing..." );
    
    gyroext_eventContext = ctx;
    
    motionManager = [[CMMotionManager alloc] init];
    motionManager.gyroUpdateInterval = 0;
    motionManager.deviceMotionUpdateInterval = 0;
	
	opQ = [[NSOperationQueue currentQueue] retain];
    
    return NULL;
}

#pragma mark - AS3 bootstrap

void GyroscopeExtensionContextInitializer(void* extData, const uint8_t* ctxType, FREContext ctx, uint32_t* numFunctionsToTest, const FRENamedFunction** functionsToSet) {
    
    *numFunctionsToTest = 3;
    
    FRENamedFunction* func = (FRENamedFunction*) malloc(sizeof(FRENamedFunction) * *numFunctionsToTest);
    
    func[ 0 ].name = (const uint8_t*) "initialize";
    func[ 0 ].functionData = NULL;
    func[ 0 ].function = &gyroext_initialize;
    
    func[ 1 ].name = (const uint8_t*) "startReadings";
    func[ 1 ].functionData = NULL;
    func[ 1 ].function = &gyroext_startReadings;
    
    func[ 2 ].name = (const uint8_t*) "stopReadings";
    func[ 2 ].functionData = NULL;
    func[ 2 ].function = &gyroext_stopReadings;
    
    /* DO NOT FORGET TO INCREASE numFunctionsToTest! - AND make sure indices are right */
    
    *functionsToSet = func;
}

void GyroscopeExtensionInitializer(void** extDataToSet, FREContextInitializer* ctxInitializerToSet, FREContextFinalizer* ctxFinalizerToSet) {
    *extDataToSet = NULL;
    *ctxInitializerToSet = &GyroscopeExtensionContextInitializer;
}

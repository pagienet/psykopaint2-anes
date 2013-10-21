#import "FlashRuntimeExtensions.h"
#import <UIKit/UIKit.h>

FREContext notext_eventContext;

#pragma mark - Internal

void notext_notifyMemoryWarning() {
    NSLog(@"notifyMemoryWarning");
    NSString *eventName = @"received/memory/warning";
    const uint8_t* eventCode = (const uint8_t*) [eventName UTF8String];
    FREDispatchStatusEventAsync( notext_eventContext, eventCode, eventCode );
}

#pragma mark - Interface

FREObject notext_simulateMemoryWarning(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]) {
    
    NSLog( @"NotificationsExtension - Simulating memory warning..." );
    
    [ [NSNotificationCenter defaultCenter] postNotificationName:UIApplicationDidReceiveMemoryWarningNotification object:nil ];
    
    return NULL;
}

#pragma mark - Initialization

FREObject notext_initialize(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]) {
    
    NSLog( @"NotificationsExtension - Initializing..." );
    
    notext_eventContext = ctx;
    
    [ [ NSNotificationCenter defaultCenter ] addObserverForName:UIApplicationDidReceiveMemoryWarningNotification
                                                         object:nil
                                                          queue:nil usingBlock:^(NSNotification *notification) {
                                                              NSLog( @"NotificationsExtension - Received notification: %@", notification );
                                                              notext_notifyMemoryWarning();
                                                          } ];
    
    return NULL;
}

#pragma mark - AS3 bootstrap

void NotificationsExtensionContextInitializer(void* extData, const uint8_t* ctxType, FREContext ctx, uint32_t* numFunctionsToTest, const FRENamedFunction** functionsToSet) {
    
    *numFunctionsToTest = 2;
    
    FRENamedFunction* func = (FRENamedFunction*) malloc(sizeof(FRENamedFunction) * *numFunctionsToTest);
    
    func[ 0 ].name = (const uint8_t*) "initialize";
    func[ 0 ].functionData = NULL;
    func[ 0 ].function = &notext_initialize;
    
    func[ 1 ].name = (const uint8_t*) "simulateMemoryWarning";
    func[ 1 ].functionData = NULL;
    func[ 1 ].function = &notext_simulateMemoryWarning;
    
    /* DO NOT FORGET TO INCREASE numFunctionsToTest! - AND make sure indices are right */
    
    *functionsToSet = func;
}

void NotificationsExtensionInitializer(void** extDataToSet, FREContextInitializer* ctxInitializerToSet, FREContextFinalizer* ctxFinalizerToSet) {
    *extDataToSet = NULL;
    *ctxInitializerToSet = &NotificationsExtensionContextInitializer;
}
















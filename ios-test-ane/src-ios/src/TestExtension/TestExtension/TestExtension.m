#import "FlashRuntimeExtensions.h"

FREContext testext_eventContext;

#pragma mark - Initialization

FREObject testext_initialize(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]) {
    
    NSLog( @"TestExtension - Initializing..." );
    
    testext_eventContext = ctx;
    
    return NULL;
}

#pragma mark - AS3 bootstrap

void TestExtensionContextInitializer(void* extData, const uint8_t* ctxType, FREContext ctx, uint32_t* numFunctionsToTest, const FRENamedFunction** functionsToSet) {
    
    *numFunctionsToTest = 1;
    
    FRENamedFunction* func = (FRENamedFunction*) malloc(sizeof(FRENamedFunction) * *numFunctionsToTest);
    
    func[ 0 ].name = (const uint8_t*) "initialize";
    func[ 0 ].functionData = NULL;
    func[ 0 ].function = &testext_initialize;
    
    /* DO NOT FORGET TO INCREASE numFunctionsToTest! - AND make sure indices are right */
    
    *functionsToSet = func;
}

void TestExtensionInitializer(void** extDataToSet, FREContextInitializer* ctxInitializerToSet, FREContextFinalizer* ctxFinalizerToSet) {
    *extDataToSet = NULL;
    *ctxInitializerToSet = &TestExtensionContextInitializer;
}
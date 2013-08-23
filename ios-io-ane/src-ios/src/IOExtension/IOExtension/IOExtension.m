#import "FlashRuntimeExtensions.h"
#import "../Objective-Zip/ZipFile.h"
#import "../Objective-Zip/ZipException.h"
#import "../Objective-Zip/FileInZipInfo.h"
#import "../Objective-Zip/ZipWriteStream.h"
#import "../Objective-Zip/ZipReadStream.h"

FREContext eventContext;

#pragma mark - Write to disk

FREObject ioext_writeWithCompression(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]) {
    
    eventContext = ctx;
    
    NSLog(@"IOExtension - writing with compression...");
    
    // Get byte array.
    FREByteArray byteArray;
    FREObject objectByteArray = argv[ 0 ];
    FREAcquireByteArray( objectByteArray, &byteArray );
    NSData *data = [ NSData dataWithBytes:(void *)byteArray.bytes length:(NSUInteger)byteArray.length ];
    FREReleaseByteArray( objectByteArray );
    
    // Get file name.
    uint32_t fileNameLength;
    const uint8_t *fileNameRaw;
    FREGetObjectAsUTF8( argv[ 1 ], &fileNameLength, &fileNameRaw );
    NSString *fileName = [ NSString stringWithUTF8String:(char*)fileNameRaw ];
    NSLog(@"IOExtension - incoming file name: %@", fileName);
    
    // Determine file path to write to.
    NSString *finalFileName = [ NSString stringWithFormat:@"Documents/%@", fileName ];
    NSString *filePath = [ NSHomeDirectory() stringByAppendingPathComponent:finalFileName ];
    
    // Write using compression.
    ZipFile *zipFile= [ [ ZipFile alloc ] initWithFileName:filePath mode:ZipFileModeCreate ];
    ZipWriteStream *stream= [ zipFile writeFileInZipWithName:fileName compressionLevel:ZipCompressionLevelFastest ];
    [ stream writeData:data ];
    [ stream finishedWriting ];
    [ zipFile close ];
    [ zipFile release ];
    
    return NULL;
}

FREObject ioext_write(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]) {
    
    eventContext = ctx;
    
    NSLog(@"IOExtension - writing...");
    
    // Get byte array.
    FREByteArray byteArray;
    FREObject objectByteArray = argv[ 0 ];
    FREAcquireByteArray( objectByteArray, &byteArray );
    NSData *data = [ NSData dataWithBytes:(void *)byteArray.bytes length:(NSUInteger)byteArray.length ];
    FREReleaseByteArray( objectByteArray );
    
    // Get file name.
    uint32_t fileNameLength;
    const uint8_t *fileNameRaw;
    FREGetObjectAsUTF8( argv[ 1 ], &fileNameLength, &fileNameRaw );
    NSString *fileName = [ NSString stringWithUTF8String:(char*)fileNameRaw ];
    NSLog(@"IOExtension - incoming file name: %@", fileName);
    
    // Determine file path to write to.
    NSString *finalFileName = [ NSString stringWithFormat:@"Documents/%@", fileName ];
    NSString *filePath = [ NSHomeDirectory() stringByAppendingPathComponent:finalFileName ];
    
    // Write without using compression.
    [ data writeToFile:filePath atomically:YES ];
    
    return NULL;
}

#pragma mark - Initialization

FREObject ioext_initialize(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]) {
    
    eventContext = ctx;
    
    NSLog(@"IOExtension - initializing...");
    
    
    
    return NULL;
}

#pragma mark - AS3 bootstrap

void IOExtensionContextInitializer(void* extData, const uint8_t* ctxType, FREContext ctx, uint32_t* numFunctionsToTest, const FRENamedFunction** functionsToSet) {
    
    *numFunctionsToTest = 3;
    
    FRENamedFunction* func = (FRENamedFunction*) malloc(sizeof(FRENamedFunction) * *numFunctionsToTest);
    
    func[ 0 ].name = (const uint8_t*) "initialize";
    func[ 0 ].functionData = NULL;
    func[ 0 ].function = &ioext_initialize;
    
    func[ 1 ].name = (const uint8_t*) "write";
    func[ 1 ].functionData = NULL;
    func[ 1 ].function = &ioext_write;
    
    func[ 2 ].name = (const uint8_t*) "writeWithCompression";
    func[ 2 ].functionData = NULL;
    func[ 2 ].function = &ioext_writeWithCompression;
    
    /* DO NOT FORGET TO INCREASE numFunctionsToTest! - AND make sure indices are right */
    
    *functionsToSet = func;
}

void IOExtensionInitializer(void** extDataToSet, FREContextInitializer* ctxInitializerToSet, FREContextFinalizer* ctxFinalizerToSet) {
    *extDataToSet = NULL;
    *ctxInitializerToSet = &IOExtensionContextInitializer;
}
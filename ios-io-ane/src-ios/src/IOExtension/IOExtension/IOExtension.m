#import "FlashRuntimeExtensions.h"
#import "../Objective-Zip/ZipFile.h"
#import "../Objective-Zip/ZipException.h"
#import "../Objective-Zip/FileInZipInfo.h"
#import "../Objective-Zip/ZipWriteStream.h"
#import "../Objective-Zip/ZipReadStream.h"

FREContext eventContext;

#pragma mark - Read from disk

FREObject ioext_readWithDeCompression(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]) {
    
    eventContext = ctx;
    
    NSLog( @"IOExtension - reading with de-compression..." );
    
    // Get byte array.
    FREByteArray byteArray;
    FREObject objectByteArray = argv[ 0 ];
    
    // Get file name.
    uint32_t fileNameLength;
    const uint8_t *fileNameRaw;
    FREGetObjectAsUTF8( argv[ 1 ], &fileNameLength, &fileNameRaw );
    NSString *fileName = [ NSString stringWithUTF8String:(char*)fileNameRaw ];
    NSLog( @"IOExtension - target file name: %@", fileName );
    
    // Determine file path to read from.
    NSString *finalFileName = [ NSString stringWithFormat:@"Documents/%@", fileName ];
    NSString *filePath = [ NSHomeDirectory() stringByAppendingPathComponent:finalFileName ];
    
    // Unzip.
    ZipFile *unzipFile= [ [ ZipFile alloc ] initWithFileName:filePath mode:ZipFileModeUnzip ];
    NSArray *infos= [unzipFile listFileInZipInfos];
    FileInZipInfo *firstInfo = infos[ 0 ];
    [ unzipFile goToFirstFileInZip ];
//    NSLog( @"IOExtension - file size: %u", firstInfo.length );
    ZipReadStream *read= [ unzipFile readCurrentFileInZip ];
    NSMutableData *buffer = [ [ NSMutableData alloc ] initWithLength: firstInfo.length ];
    [ read readDataWithBuffer:buffer ];
    [ read finishedReading ];
    
    // NSData -> ByteArray.
    FREObject bytesLength;
    FRENewObjectFromUint32( buffer.length, &bytesLength );
    FRESetObjectProperty( objectByteArray, (uint8_t *)"length", bytesLength, NULL );
    FREAcquireByteArray( objectByteArray, &byteArray );
    memcpy( byteArray.bytes, buffer.bytes, buffer.length );
    FREReleaseByteArray( objectByteArray );
    
    [ unzipFile close ];
    [ unzipFile release ];
    
    return NULL;
}

#pragma mark - Write to disk

FREObject ioext_writeWithCompression(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]) {
    
    eventContext = ctx;
    
    NSLog(@"IOExtension - writing with compression...");
    
    // Get byte array.
    FREByteArray byteArray;
    FREObject objectByteArray = argv[ 0 ];
    FREAcquireByteArray( objectByteArray, &byteArray );
    NSData *data = [ NSData dataWithBytes:(void *)byteArray.bytes length:(NSUInteger)byteArray.length ];
    NSLog(@"IOExtension - bytes: %u", data.length );
    FREReleaseByteArray( objectByteArray );
    
    // Get file name.
    uint32_t fileNameLength;
    const uint8_t *fileNameRaw;
    FREGetObjectAsUTF8( argv[ 1 ], &fileNameLength, &fileNameRaw );
    NSString *fileName = [ NSString stringWithUTF8String:(char*)fileNameRaw ];
    NSLog(@"IOExtension - incoming file name: %@", fileName);
    
    // Determine file path to write to.
    NSString *finalFileName = [ NSString stringWithFormat:@"Documents/%@", fileName ];
    NSLog(@"IOExtension - finalFileName: %@", finalFileName);
    NSString *filePath = [ NSHomeDirectory() stringByAppendingPathComponent:finalFileName ];
    NSLog(@"IOExtension - filePath: %@", filePath);
    
    // Write using compression.
    ZipFile *zipFile= [ [ ZipFile alloc ] initWithFileName:filePath mode:ZipFileModeCreate ];
    NSLog(@"IOExtension - zipFile: %@", zipFile);
    ZipWriteStream *stream= [ zipFile writeFileInZipWithName:fileName compressionLevel:ZipCompressionLevelFastest ];
    NSLog(@"IOExtension - stream: %@", stream);
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

#pragma mark - AS3 bootstrap

void IOExtensionContextInitializer(void* extData, const uint8_t* ctxType, FREContext ctx, uint32_t* numFunctionsToTest, const FRENamedFunction** functionsToSet) {
    
    *numFunctionsToTest = 3;
    
    FRENamedFunction* func = (FRENamedFunction*) malloc(sizeof(FRENamedFunction) * *numFunctionsToTest);
    
    func[ 0 ].name = (const uint8_t*) "write";
    func[ 0 ].functionData = NULL;
    func[ 0 ].function = &ioext_write;
    
    func[ 1 ].name = (const uint8_t*) "writeWithCompression";
    func[ 1 ].functionData = NULL;
    func[ 1 ].function = &ioext_writeWithCompression;
    
    func[ 2 ].name = (const uint8_t*) "readWithDeCompression";
    func[ 2 ].functionData = NULL;
    func[ 2 ].function = &ioext_readWithDeCompression;
    
    /* DO NOT FORGET TO INCREASE numFunctionsToTest! - AND make sure indices are right */
    
    *functionsToSet = func;
}

void IOExtensionInitializer(void** extDataToSet, FREContextInitializer* ctxInitializerToSet, FREContextFinalizer* ctxFinalizerToSet) {
    *extDataToSet = NULL;
    *ctxInitializerToSet = &IOExtensionContextInitializer;
}
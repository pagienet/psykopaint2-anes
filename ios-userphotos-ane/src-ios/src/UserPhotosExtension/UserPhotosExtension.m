#import "FlashRuntimeExtensions.h"
#import "Utils.h"
#import <AssetsLibrary/AssetsLibrary.h>

#pragma mark - internal

FREContext eventContext;
NSArray *libraryItems;
NSArray *thumbnails;

void notifyLibraryItemsRetrieved() {
    //NSLog(@"notifyLibraryItemsRetrieved");
    NSString *eventName = @"user/library/items/retrieved";
    const uint8_t* eventCode = (const uint8_t*) [eventName UTF8String];
    FREDispatchStatusEventAsync( eventContext, eventCode, eventCode );
}

void paintImageIntoBitmapData( FREBitmapData *bmd, CGImageRef imageRef, int offX, int offY ) {
    
    // TODO: offsets are no longer used, remove to simplify code.
    
    NSUInteger width = CGImageGetWidth( imageRef );
    NSUInteger height = CGImageGetHeight( imageRef );
    
    // Read asset "imageRef" pixels into byte array "rawData".
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    unsigned char *rawData = malloc( height * width * 4 );
    NSUInteger bytesPerPixel = 4;
    NSUInteger bytesPerRow = bytesPerPixel * width;
    NSUInteger bitsPerComponent = 8;
    CGContextRef context = CGBitmapContextCreate( rawData, width, height,
                                                 bitsPerComponent, bytesPerRow, colorSpace,
                                                 kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big );
    CGColorSpaceRelease( colorSpace );
    CGContextDrawImage( context, CGRectMake( 0, 0, width, height ), imageRef );
    CGContextRelease( context );
    
    // Pixels are now in rawData in the format RGBA8888
    // We'll now loop over each pixel write them into the AS3 bitmapData memory
    int x, y;
    // There may be extra pixels in each row due to the value of
    // bmd.lineStride32, we'll skip over those as needed
    int offset = bmd->lineStride32 - bmd->width;
    int offset2 = bytesPerRow - width * 4;
    int offset3 = bmd->width - width;
    int byteIndex = 0;
    uint32_t *bmdPixels = bmd->bits32;
    bmdPixels += offY * ( bmd->width ) + offX;
    for( y = 0; y < height; y++ ) {
        for( x = 0; x < width; x++, bmdPixels++, byteIndex += 4 ) {
            // Values are currently in RGBA8888, so each colour
            // value is currently a separate number
            int red   = ( rawData[ byteIndex ] );
            int green = ( rawData[ byteIndex + 1 ] );
            int blue  = ( rawData[ byteIndex + 2 ] );
            int alpha = ( rawData[ byteIndex + 3 ] );
            // Combine values into ARGB32
            * bmdPixels = ( alpha << 24 ) | ( red << 16 ) | ( green << 8 ) | blue;
        }
        bmdPixels += offset + offset3;
        byteIndex += offset2;
    }
    
    // free the the memory we allocated
    free( rawData );
}

#pragma mark - Single image retrieval

FREObject getThumbnailAtIndex(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]) {
    
    // First parameter is the index.
    uint32_t index;
    FREGetObjectAsUint32( argv[ 0 ], &index );
    
    // Second parameter is the bitmap data to draw to.
    FREBitmapData bmd;
    FREAcquireBitmapData( argv[ 1 ], &bmd );
    
    // Identify the asset for this index.
    ALAsset *asset = [ libraryItems objectAtIndex: index ];
    CGImageRef thumbnail = [ asset aspectRatioThumbnail];
    
    // Paint the bmd.
    paintImageIntoBitmapData( &bmd, thumbnail, 0, 0 );
    
    // Tell Flash which region of the bitmapData changes (all of it here)
    FREInvalidateBitmapDataRect( argv[ 1 ], 0, 0, bmd.width, bmd.height );
    
    // Release our control over the bitmapData
    FREReleaseBitmapData( argv[ 1 ] );
    
    return NULL;
}

FREObject getFullImageAtIndex(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]) {

    // First parameter is the index.
    uint32_t index;
    FREGetObjectAsUint32( argv[ 0 ], &index );
    
    // Second parameter is the bitmap data to draw to.
    FREBitmapData bmd;
    FREAcquireBitmapData( argv[ 1 ], &bmd );
    
    // Identify the asset for this index.
    ALAsset *asset = [libraryItems objectAtIndex: index ];
    ALAssetRepresentation *rep = [ asset defaultRepresentation ];
    CGImageRef image = [ rep fullResolutionImage ];
    
    // Paint the bmd.
    paintImageIntoBitmapData( &bmd, image, 0, 0 );
    
    // Tell Flash which region of the bitmapData changes (all of it here)
    FREInvalidateBitmapDataRect( argv[ 1 ], 0, 0, bmd.width, bmd.height );
    
    // Release our control over the bitmapData
    FREReleaseBitmapData( argv[ 1 ] );
    
     return NULL;
}

#pragma mark - Asset info

FREObject getNumberOfLibraryItems(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]) {
    float num = libraryItems.count;
    FREObject numFre = nil;
    FRENewObjectFromDouble(num, &numFre);
    return numFre;
}

FREObject getThumbDimensionsAtIndex(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]) {
    
    // Input index parameter from FREObject to uint32.
    uint32_t index;
    FREGetObjectAsUint32( argv[ 0 ], &index );
    
    // Identify thumbnail dimensions and put them into a string with format "widthxheight".
    ALAsset *asset = [libraryItems objectAtIndex: index ];
    CGImageRef thumb = [ asset aspectRatioThumbnail ];
    NSUInteger width = CGImageGetWidth( thumb );
    NSUInteger height = CGImageGetHeight( thumb );
    NSString *wStr = [ NSString stringWithFormat:@"%d", width ];
    NSString *hStr = [ NSString stringWithFormat:@"%d", height ];
    NSMutableString *msg = [ NSMutableString stringWithFormat:@"%@x%@", wStr, hStr ];
    
    // Translate for as3.
    const char *str = [ msg UTF8String ]; // Convert Obj-C string to C UTF8String
    FREObject msgAs3;
    FRENewObjectFromUTF8( strlen(str) + 1, (const uint8_t*)str, &msgAs3 );
    
    return msgAs3;
}

FREObject getFullImageDimensionsAtIndex(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]) {
    
    // Input index parameter from FREObject to uint32.
    uint32_t index;
    FREGetObjectAsUint32( argv[ 0 ], &index );
    
    // Identify thumbnail dimensions and put them into a string with format "widthxheight".
    ALAsset *asset = [libraryItems objectAtIndex: index ];
    ALAssetRepresentation *rep = [ asset defaultRepresentation ];
    CGImageRef image = [ rep fullResolutionImage ];
    NSUInteger width = CGImageGetWidth( image );
    NSUInteger height = CGImageGetHeight( image );
    NSString *wStr = [ NSString stringWithFormat:@"%d", width ];
    NSString *hStr = [ NSString stringWithFormat:@"%d", height ];
    NSMutableString *msg = [ NSMutableString stringWithFormat:@"%@x%@", wStr, hStr ];
    
    // Translate for as3.
    const char *str = [ msg UTF8String ]; // Convert Obj-C string to C UTF8String
    FREObject msgAs3;
    FRENewObjectFromUTF8( strlen(str) + 1, (const uint8_t*)str, &msgAs3 );
    
    return msgAs3;
}

#pragma mark - Clean up

FREObject releaseLibraryItems(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]) {
    [ libraryItems release ];
    [ thumbnails release ];
    return NULL;
}

#pragma mark - Initialization

FREObject initialize(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]) {
    
    eventContext = ctx;
    
    NSLog(@"UserPhotosExtension - initializing...");
    
    // Prepare an asset collector and get a reference to the asset library.
    NSMutableArray *assetCollector = [ [ NSMutableArray alloc ] initWithCapacity:0 ];
    NSMutableArray *thumbnailCollector = [ [ NSMutableArray alloc ] initWithCapacity:0 ];
    ALAssetsLibrary *assetsLibrary = [ Utils defaultAssetsLibrary ];
    
    // Request enumeration of all assets in the library.
    [ assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos
    usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
        // NSLog(@"group retrieved: %@", group);
        if( group ) {
            [ group enumerateAssetsUsingBlock:^(ALAsset *asset, NSUInteger index, BOOL *stop) {
                if( asset ) {
                    [ assetCollector addObject:asset ];
                    CGImageRef thumb = asset.aspectRatioThumbnail;
                    [ thumbnailCollector addObject:(id)thumb ];
                }
            } ];
            // All assets retrieved.
            libraryItems = assetCollector;
            thumbnails = thumbnailCollector;
            notifyLibraryItemsRetrieved();
        }
    }
    failureBlock:^(NSError *error) {
        NSLog(@"UserPhotosExtension - Error retrieving users media library items.");
    } ];
    
    return NULL;
}

#pragma mark - AS3 bootstrap

void UserPhotosExtensionContextInitializer(void* extData, const uint8_t* ctxType, FREContext ctx, uint32_t* numFunctionsToTest, const FRENamedFunction** functionsToSet) {
    
    *numFunctionsToTest = 7;
    
    FRENamedFunction* func = (FRENamedFunction*) malloc(sizeof(FRENamedFunction) * *numFunctionsToTest);
    
    func[ 0 ].name = (const uint8_t*) "initialize";
    func[ 0 ].functionData = NULL;
    func[ 0 ].function = &initialize;
    
    func[ 1 ].name = (const uint8_t*) "getNumberOfLibraryItems";
    func[ 1 ].functionData = NULL;
    func[ 1 ].function = &getNumberOfLibraryItems;
    
    func[ 2 ].name = (const uint8_t*) "getThumbnailAtIndex";
    func[ 2 ].functionData = NULL;
    func[ 2 ].function = &getThumbnailAtIndex;
    
    func[ 3 ].name = (const uint8_t*) "getFullImageAtIndex";
    func[ 3 ].functionData = NULL;
    func[ 3 ].function = &getFullImageAtIndex;
    
    func[ 4 ].name = (const uint8_t*) "getFullImageDimensionsAtIndex";
    func[ 4 ].functionData = NULL;
    func[ 4 ].function = &getFullImageDimensionsAtIndex;
    
    func[ 5 ].name = (const uint8_t*) "releaseLibraryItems";
    func[ 5 ].functionData = NULL;
    func[ 5 ].function = &releaseLibraryItems;
    
    func[ 6 ].name = (const uint8_t*) "getThumbDimensionsAtIndex";
    func[ 6 ].functionData = NULL;
    func[ 6 ].function = &getThumbDimensionsAtIndex;
    
    /* DO NOT FORGET TO INCREASE numFunctionsToTest! - AND make sure indices are right */
    
    *functionsToSet = func;
}

void UserPhotosExtensionInitializer(void** extDataToSet, FREContextInitializer* ctxInitializerToSet, FREContextFinalizer* ctxFinalizerToSet) {
    *extDataToSet = NULL;
    *ctxInitializerToSet = &UserPhotosExtensionContextInitializer;
}









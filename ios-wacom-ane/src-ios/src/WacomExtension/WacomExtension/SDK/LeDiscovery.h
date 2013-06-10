// File: LeDiscovery.h
// 
// Abstract: Scan for and discover nearby LE peripherals with the 
// matching service UUID.
//
//	Copyright (c) 2012 Wacom Technology Corporation. All rights reserved.
//

#pragma once
#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

#import "LeWacomStylusService.h"



/****************************************************************************/
/*							UI protocols									*/
/****************************************************************************/
@protocol LeDiscoveryDelegate <NSObject>
- (void) deviceDiscovered:(CBPeripheral *)inPeripheral;
- (void) discoveryStatePoweredOff;
- (void) deviceConnected:(CBPeripheral *) inPeripheral;
- (void) deviceDisconnected:(CBPeripheral *) inPeripheral;
@end



/****************************************************************************/
/*							Discovery class									*/
/****************************************************************************/
@interface LeDiscovery : NSObject

+ (id) sharedInstance;


/****************************************************************************/
/*								UI controls									*/
/****************************************************************************/
@property (nonatomic, assign) id<LeDiscoveryDelegate>   discoveryDelegate;
@property (nonatomic, assign) id<LeWacomStylusProtocol>	peripheralDelegate;


/****************************************************************************/
/*								Actions										*/
/****************************************************************************/
- (void) startScanningForUUIDString:(NSString *)uuidString;
- (void) stopScanning;

- (void) connectPeripheral:(CBPeripheral*)peripheral;
- (void) disconnectPeripheral:(CBPeripheral*)peripheral;

- (void) addSavedDevice:(CFUUIDRef) uuid;
- (void) loadSavedDevices;
- (void) removeSavedDevice:(CFUUIDRef) uuid;

/****************************************************************************/
/*							Access to the devices							*/
/****************************************************************************/
@property (retain, nonatomic) NSMutableArray *foundPeripherals;
@property (retain, nonatomic) NSMutableArray	*connectedServices;	// Array of LeTemperatureAlarmService
@end

// File: LeWacomStylusService.h
// 
// Abstract: Wacom Stylus Service Code - Connect to a peripheral
// get notified when the pressure changes or a stylus button is clicked.
//
//	Copyright (c) 2013 Wacom Technology Corporation. All rights reserved.
//



#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "TrackedTouch.h"

/****************************************************************************/
/*						Service Characteristics								*/
/****************************************************************************/
extern NSString *kWacomStylusServiceUUIDString;                     // Service UUID
extern NSString *kWacomStylusPressureCharacteristicUUIDString;   // WacomStylus Mesurement Characteristic
extern NSString *kBatteryServiceUUIDString;
extern NSString *kBatteryLevelCharacteristicUUIDString;

extern NSString *kAlarmServiceEnteredBackgroundNotification;
extern NSString *kAlarmServiceEnteredForegroundNotification;


/****************************************************************************/
/*								Protocol									*/
/****************************************************************************/
@class LeWacomStylusService;

@protocol LeWacomStylusProtocol<NSObject>
- (void) alarmServiceDidChangeButtonSelected:(LeWacomStylusService*)service;
- (void) alarmServiceDidChangePressure:(LeWacomStylusService*)service;
- (void) alarmServiceDidChangeStatus:(LeWacomStylusService*)service;
- (void) alarmServiceDidChangeBatteryLevel:(LeWacomStylusService*)service;
- (void) alarmServiceDidReset;
@end

/****************************************************************************/
/*						        WacomStylus service.                          */
/****************************************************************************/
@interface LeWacomStylusService : NSObject

- (id) initWithPeripheral:(CBPeripheral *)peripheral controller:(id<LeWacomStylusProtocol>)controller;
- (void) reset;
- (void) start;

/* Querying Sensor */
@property (readonly) NSInteger pressure;
@property (readonly) NSUInteger lastButtonClicked;
@property (readonly) NSInteger batteryLevel;

/* Behave properly when heading into and out of the background */
- (void)enteredBackground;
- (void)enteredForeground;

@property (readonly) CBPeripheral *peripheral;
@end

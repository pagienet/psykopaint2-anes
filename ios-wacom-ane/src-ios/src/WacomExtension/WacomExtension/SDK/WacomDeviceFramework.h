//
//  WacomDeviceFramework.h
//
//
//  Copyright (c) 2013 Wacom Technology Corporation. All rights reserved.
//


#ifndef WACOMDEVICEFRAMEWORK_H
#define WACOMDEVICEFRAMEWORK_H
#import <Foundation/Foundation.h>
#import "WacomDeviceFrameworkTypes.h"
#import "LeWacomStylusService.h"
#import "LeDiscovery.h"
#define WAC_ERROR (-1)
#define WAC_SUCCESS 0


#pragma mark -
#pragma mark "Stylus Event"
#pragma mark -

typedef enum {eStylusEventType_PressureChange, eStylusEventType_ButtonPressed = 1, eStylusEventType_ButtonReleased = 2, eStylusEventType_BatteryLevelChanged = 3} WacomStylusEventType;

/*
 Class: WacomStylusEvent
 Purpose: Serves the purpose of supplying stylus data to the shimmed views and view controllers, as
 well as the callback.
 */

@interface WacomStylusEvent : NSNotification <NSCopying>
/*
 Function: getType
 Returns: a WacomStylusEventType to determine what kind of event is coming through.
 */
- (WacomStylusEventType) getType;


/*
 Function: getPressure
 Returns: a CGFloat representing the pressure that was received from the stylus
 */
- (CGFloat)getPressure;


/*
 Function: getButton
 Returns: a uint representing the button number for which the button event is happening
 */
- (uint)getButton;

/*
 Function: getBatteryLevel
 Returns: a uint representing the remaining battery life in percent form.
 */
- (uint)getBatteryLevel;

@end



#pragma mark -
#pragma mark "Device Object"
#pragma mark -
typedef enum { eTipType_TipInvalid, eTipType_TipPen} WacomStylusTipType;
typedef enum { eDeviceType_Stylus} WacomDeviceType;
typedef enum { eButtonState_Invalid, eButtonState_Down, eButtonState_Up} WacomStylusButtonState;

/*
 Class: WacomDevice
 Purpose: Provides a object where a device can be identified and attributes determined.
 */
@interface WacomDevice : NSObject <NSCopying>


/*
 Function: getDeviceID
 Returns: returns the unique id for this device (Bluetooth address).
 */
-(NSString *) getDeviceID;


/*
 Function: getDeviceType
 Returns: a WacomDeviceType to determine if you are using a stylus or a Wacom tablet with a stylus
 */
-(WacomDeviceType) getDeviceType;


/*
 Function: getButtonCount
 Returns: returns a button count that can then be used with a loop to walk through the buttons.
 */
-(uint) getButtonCount;


/*
 Function: getButtonStateWithButtonIndex
 Returns: returns the state of the requested button.
 */
-(WacomStylusButtonState) getButtonStateWithButtonIndex:(uint) button;


/*
 Function: supportsPressure
 Returns: returns YES/NO based on whether the device supports pressure events.
 */
-(BOOL) supportsPressure;


/* 
 Function: getMaxPressure
 returns: the maximum pressure reading that can be supplied by the stylus. The range will
 always start from 0
 */
-(NSInteger) getMaximumPressure;


/*
 Function: getMinumum Pressure
 returns: the minimum pressure reading that can be supplied by the stylus. This value will always
 be 0.
 */
-(NSInteger) getMinimumPressure;


/*
 Function: getName
 Returns:  the name of the device, such as "Intuos Creative Stylus"
 */
-(NSString *) getName;


/*
 Function: getManufacturerName
 Returns:  the manufacturer of the device "Wacom Co. Ltd."
 */
-(NSString *) getManufacturerName;


/*
 Function: getFirmwareVersion
 Returns: the version of the firmware
 */
-(int) getFirmwareVersion;


/*
 Function: isCurrentlyConnected
 Returns: true if the device is currently connected
 */
-(BOOL) isCurrentlyConnected;

@end


#pragma mark -
#pragma mark "Device Manager"
#pragma mark -

/*
 Class: WacomManager
 Purpose: Singleton for accessing accessing devices and for registering for notifications.
 */
@interface WacomManager: NSObject <LeDiscoveryDelegate, LeWacomStylusProtocol>

/*
 Function: getManager
 Returns: returns a pointer to the singleton that is the WacomManager.
 */
+ (WacomManager *) getManager;


/*
 Function: getDevices
 Returns: returns a pointer an NSArray of devices.
 */
- (NSArray *)getDevices;


/*
 Function: registerForNotifications
 Returns: WAC_ERROR or WAC_SUCCESS if the registration call was successful
 */
- (int) registerForNotifications:(id)registrant;


/*
 Function: unregisterForNotifications
 Returns: WAC_ERROR or WAC_SUCCESS if the unregistration call was successful
 */
- (int) deregisterForNotifications:(id)registrant;


/*
 Function: startDeviceDiscovery
 Returns: WAC_ERROR or WAC_SUCCESS depending.
 Notes: upon return of this function you can query the manager for the devices using the getDevices
 method
 */
- (int) startDeviceDiscovery;


/*
 Function: stopDeviceDiscovery
 Returns: WAC_ERROR or WAC_SUCCESS depending.
 Notes: upon return of this function you can query the manager for the devices using the getDevices
 method
 */
- (int) stopDeviceDiscovery;


/*
 Property: isDiscoveryInProgress
 Notes: a simple BOOL to indicate whether or not discovery is in progess or not.
 */
@property (readonly) BOOL isDiscoveryInProgress;


/*
 Function: selectDevice
 Returns: WAC_ERROR or WAC_SUCCESS depending.
 Notes: tells the singleton to provide updates from this device.
 */
- (int) selectDevice:(WacomDevice *)device;

/*
 Function: getSelectedDevice
 Returns: WAC_ERROR or WAC_SUCCESS depending.
 Notes: returns the device that has been selected for use.
 */
-(WacomDevice *) getSelectedDevice;

/*
 Function: isADeviceSelected
 Returns: WAC_ERROR or WAC_SUCCESS depending.
 Notes: returns true if a device is selected for use, otherwise false
 */
- (BOOL) isADeviceSelected;

/*
 Function: getSDKVersion
 Returns: WAC_ERROR or WAC_SUCCESS depending.
 Notes: returns the SDK version string.
 */
-(NSString *) getSDKVersion;


/*
 Property: connectedServices
 Notes: it is possible to have more than one stylus connected at a time so this is the array of services.
 */
@property (retain, nonatomic) NSMutableArray *connectedServices;


@property (readonly) TrackedTouches * currentlyTrackedTouches;


- (void)didEnterBackgroundNotification:(NSNotification*)notification;

- (void)didEnterForegroundNotification:(NSNotification*)notification;
@end

#pragma mark -
#pragma mark "Protocols"
#pragma mark -

/*
 Protocol: WacomStylusEventCallback
 Notes: this protocol provides the stylus Event callback which enables the registrant to be called
 back in the event that the manger receives an event such as pressure or a button state change from
 the stylus.
 */
@protocol WacomStylusEventCallback <NSObject>
@required
- (void)stylusEvent:(WacomStylusEvent *)stylusEvent;
@end


/*
 Protocol: WacomDiscoveryCallback
 Notes: this protocol provides the registrant with notifications of when individual devices are
 discovered or when bluetooth is turned off
 */
@protocol WacomDiscoveryCallback <NSObject>
@required
- (void) deviceDiscovered:(WacomDevice *)device;
- (void) discoveryStatePoweredOff;
@optional
- (void) deviceConnected:(WacomDevice *)device;
- (void) deviceDisconnected:(WacomDevice *)device;
@end

#endif
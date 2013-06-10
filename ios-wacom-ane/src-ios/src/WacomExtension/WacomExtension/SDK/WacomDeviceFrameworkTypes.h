//
//  WacomDeviceFrameworkTypes.h
//
//  Copyright (c) 2013 Wacom Technology Corporation. All rights reserved.//
//
#ifndef WacomInputDeviceSample_WacomDeviceFrameworkTypes_h
#define WacomInputDeviceSample_WacomDeviceFrameworkTypes_h
typedef struct
{
	int32_t ID;
	int32_t type;
	int32_t button;
	int32_t buttonState;
	int32_t pressure;
    int32_t batteryLevel;
} StylusEvent;


#endif

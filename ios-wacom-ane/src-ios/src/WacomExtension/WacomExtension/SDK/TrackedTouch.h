//
//  TrackedTouches.h
//
//Copyright (c) 2013 Wacom Technology Corporation. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

// TrackedTouch
// The purpose of TrackedTouch is to be a central class for correlating UITouches and location
// data. The problem is that sometimes you can have a touch that while in the same location has a
// different pointer. There can also be the case where there is the same pointer and slightly different
// x and y. This class attempts to contain that knowledge
@interface TrackedTouch : NSObject
-(void)setTouch:(CGPoint) previousLocation currentLocation:(CGPoint) currentPosition touch:(UITouch *) inTouch;
-(BOOL)isRejected;
@property (readonly) CGPoint lastKnownLocation;
@property (readonly) UITouch * associatedTouch;
@property (readonly) BOOL isStylus;
@end




// TrackedTouches
// The purpose of TrackedTouches is to be the container for TrackedTouch'es such that you can
// query it to see if a touch is in it adjust touches' locations. This is also the all important
// keeper of the pen touch concept not to mention the touch rejection construct.
@interface TrackedTouches : NSObject
-(NSUInteger)count;
-(void) addTouches:(NSSet *)inTouches knownTouches:(NSSet *)knownTouches view:(id)inView;
-(void) removeTouches:(NSSet *)inTouches knownTouches:(NSSet *)knownTouches view:(id)inView;
-(void) moveTouches:(NSSet *)inTouches knownTouches:(NSSet *)knownTouches view:(id)inView;
-(NSArray *)getTouches;
-(void)clearTheStylusTouch;
-(void)setPressure:(NSInteger)inPressure;
@property (readonly) TrackedTouch *theStylusTouch;
@property (readwrite) BOOL touchRejectionEnabled;
@end
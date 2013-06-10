//
//  UDPSocketAdapter.m
//  UDPSocketiOSLibrary
//
//  Created by Wouter Verweirder on 08/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "UDPSocketAdapter.h"
#import "AsyncUdpSocket.h"

@implementation UDPSocketAdapter

- (id)initWithContext:(FREContext)ctx
{
    if(self = [super init])
    {
        _ctx = ctx;
        
        theReceiveQueue = [[NSMutableArray alloc] initWithCapacity:5];
        
        NSError *error = nil;
        
        socket = [[AsyncUdpSocket alloc] initWithDelegate:self];
        [socket enableBroadcast:YES error:&error];
        
        _address = nil;
    }
    return self;
}

- (void)dealloc
{
    [socket close];
    [socket release];
    socket = nil;
    [theReceiveQueue release];
    theReceiveQueue = nil;
	[super dealloc];
}

- (BOOL)send:(NSData *)data toHost:(NSString*)host port:(int)port
{
    return [socket sendData:data toHost:host port:port withTimeout:-1 tag:0];
}

- (BOOL)bind:(int)port onAddress:(NSString*)address
{
    if(_address != nil)
        [_address release];
    
    _port = port;
    _address = [address retain];
    
    return YES;
}

- (BOOL)receive
{
    NSError *error = nil;
    if(![socket bindToAddress:_address port:_port error:&error])
    {
        return NO;
    }
    [socket receiveWithTimeout:-1 tag:0];
    return YES;
}

- (UDPPacket *)readPacket
{
    if([theReceiveQueue count] > 0)
    {
        id packet = [[theReceiveQueue objectAtIndex:0] retain];
        [theReceiveQueue removeObjectAtIndex:0];
        return packet;
    }
    return nil;
}

- (BOOL)close
{
    [socket close];
    return YES;
}

- (BOOL) onUdpSocket:(AsyncUdpSocket *)sock didReceiveData:(NSData *)data withTag:(long)tag fromHost:(NSData *)host port:(int)port
{
    //create packet
    UDPPacket *packet = [[UDPPacket alloc] init];
    packet->srcPort = port;
    packet->srcAddress = [host retain];
    packet->data = [data retain];
    packet->dstAddress = [sock localHost];
    packet->dstPort = [sock localPort];
    
    
    //add it to the queue, so Actionscript can pick it up later
    [theReceiveQueue addObject:packet];
    //dispatch the event to the actionscript library
	FREDispatchStatusEventAsync(_ctx, (const uint8_t *) "receive", (const uint8_t *) "");
    //listen for incoming packets
    [socket receiveWithTimeout:-1 tag:0];
    return YES;
}

@end

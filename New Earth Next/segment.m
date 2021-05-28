//
//  segment.m
//  junk
//
//  Created by Scott on 7/14/19.
//  Copyright © 2019 Scott. All rights reserved.
//

#import "segment.h"

@class segment;

@implementation segment

@synthesize  myID, destID, srcID, myStatus, myLoc, myName, myValue, myType;

-(id) initFromSegment: (id) startSeg toLoc: (CGPoint) theLoc {
    self = [super init];
    if (self) {
        segment* theStart = startSeg;
        
        srcID = startSeg;
        myType = theStart.myType;
        _myLimit = theStart.myLimit;
        myLoc = theLoc;
        myStatus = 0;
        myName = theStart.myName;
        myValue = 1.0;
        
    }
    
    // future make ENUM for types
    switch (myType) {
        case 1: _myLimit = 5; break; // power
        case 2: _myLimit = 5; break; // water
        case 3: _myLimit = 10; break; // roads
        default: _myLimit = 0; break;
    }
    return self;
}

-(id) initType: (int) theType atLoc: (CGPoint) theLoc status: (int) theStatus startingAt: (id) mySource name: (NSString*) theName value: (float) theValue
{
    self = [super init];
    if (self) {
        myType = theType;
        myLoc = theLoc;
        myStatus = theStatus;
        srcID = mySource;
        myName = theName;
        myValue = theValue;
    }
    
    // future make ENUM for types
    switch (myType) {
        case 1: _myLimit = 5; break; // power
        case 2: _myLimit = 5; break; // water
        case 3: _myLimit = 10; break; // roads
        default: _myLimit = 0; break;
    }
    return self;
}

-(id) initWithId: (id) theID name: (NSString*) theName loc: (CGPoint) theLoc value: (float) theValue status: (int) theStatus
{
    self = [super init];
    if (self) {
        myID = theID;
        myName = theName;
        myValue = theValue;
        myLoc = theLoc;
        myStatus = theStatus;
    }
    return self;
}

-(id) init
{
    self = [super init];
    if (self) {
        myValue = 0;
        myName = @"none";
        myID = 0;
        myLoc = CGPointMake(0, 0);
        myStatus = 0;
        destID = 0;
        srcID = 0;
    }
    return self;
}

@end

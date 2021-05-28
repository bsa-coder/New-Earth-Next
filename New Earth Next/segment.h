//
//  segment.h
//  junk
//
//  Created by Scott on 7/14/19.
//  Copyright © 2019 Scott. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface segment : NSObject

@property id myID;
@property id destID; // comma delimited list of IDs
@property id srcID; //x comma delimited list of IDs
@property int myStatus; //x on/off/dmg/destroy/new
@property CGPoint myLoc; //x cgpoint in string form ... position of end
@property NSString* myName; //x
@property float myValue; //x capacity of the segment
@property float myLimit; // max value of myValue
@property int myType; //x type of grid item (power, water, air, road, oth)

-(id) initWithId: (id) theID name: (NSString*) theName loc: (CGPoint) theLoc value: (float) thevalue status: (int) theStatus;
-(id) initType: (int) theType atLoc: (CGPoint) theLoc status: (int) theStatus startingAt: (id) mySource name: (NSString*) theName value: (float) thevalue;

@end

NS_ASSUME_NONNULL_END

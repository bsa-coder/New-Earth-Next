//
//  NENotification.m
//  New Earth
//
//  Created by Scott Alexander on 7/19/17.
//  Copyright © 2017 Big Dog Tools. All rights reserved.
//

#import "NENotification.h"

@implementation NENotification

-(id) initNotificationOnDay: (NSInteger) theDay
                       from: (noteSource) theSource
                       type: (noteType) theType
                    content: (NSString*) theMessage
                       date: (NSDate*) theDate
                   isRemote: (BOOL) isRemote
{
    self = [super init];
    
    if (self) {
        _day = theDay;
        _source = theSource;
        _type = theType;
        _message = theMessage;
        _date = theDate;
        _remote = isRemote;
    }
    return self;
}

@end

//
//  AvailTech.h
//  New Earth
//
//  Created by Scott Alexander on 7/5/16.
//  Copyright © 2016 Big Dog Tools. All rights reserved.
//

/*  dictionary of items that are or can be installed  */

#import <Foundation/Foundation.h>
#import "UnitInventory.h"

extern NSString* const AvailTechBeginChangesNotification;
extern NSString* const AvailTechInsertEntryNotification;
extern NSString* const AvailTechDeleteEntryNotification;
extern NSString* const AvailTechChangesCompleteNotification;

// to access data in the notifications
extern NSString* const AvailTechNotificationIndexPathKey;


@interface AvailTech : UnitInventory <NSCoding>

//@property UnitInventory* theStore;

-(void) fillTheStore;
+(id)sharedSelf;

@end

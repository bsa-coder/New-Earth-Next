//
//  NeNotifications.h
//  New Earth
//
//  Created by Scott Alexander on 7/20/17.
//  Copyright © 2017 Big Dog Tools. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "NENotification.h"
//#import "ItemEnums.h"

@class NENotification;
typedef void (^NoteEnumeratorBlock) (NENotification* neNote);

extern NSString* const kNENoteBeginChangesNotification;
extern NSString* const kNENoteInsertNoteNotification;
extern NSString* const kNENoteDeleteNoteNotification;
extern NSString* const kNENoteChangesCompleteNotification;

// to access data in the notifications
extern NSString* const kNENoteNotificationIndexPathKey;

@interface NeNotifications : NSObject

//@property (strong, nonatomic) NewEarthGlobals* theGlobals;
@property (nonatomic, readonly) NSUInteger count;

-(NENotification*) noteAtIndexPath:(NSIndexPath*) indexPath;
-(NSIndexPath*) indexPathForNote:(NENotification*) neNotification;
-(void) addNote:(NENotification*) neNotification;
-(void) deleteNoteAtIndexPath:(NSIndexPath*) indexPath;
-(void) enumerateNotesAscending:(BOOL) ascending withBlock:(NoteEnumeratorBlock) block;

+(id)sharedSelf;

@end


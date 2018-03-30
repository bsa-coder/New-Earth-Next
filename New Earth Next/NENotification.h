//
//  NENotification.h
//  New Earth
//
//  Created by Scott Alexander on 7/19/17.
//  Copyright © 2017 Big Dog Tools. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ItemEnums.h"

@class NENotification;
typedef void (^NoteEnumeratorBlock) (NENotification* neNote);

@interface NENotification : NSObject

@property NSInteger day;
@property NSString* message;
@property BOOL remote;
@property noteType type;
@property noteSource source;
@property NSDate* date;

-(id) initNotificationOnDay: (NSInteger) theDay from: (noteSource) theSource type: (noteType) theType content: (NSString*) theMessage date: (NSDate*) theDate isRemote: (BOOL) isRemote;

/*
-(NENotification*) noteAtIndexPath:(NSIndexPath*) indexPath;
-(NSIndexPath*) indexPathForUnit:(NENotification*) neNote;
-(void) addNote:(NENotification*) neNote;
-(void) deleteNoteAtIndexPath:(NSIndexPath*) indexPath;
-(void) enumerateNotesAscending:(BOOL) ascending withBlock:(NoteEnumeratorBlock) block;
*/
 
@end

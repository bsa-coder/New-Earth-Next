//
//  NeNotifications.m
//  New Earth
//
//  Created by Scott Alexander on 7/20/17.
//  Copyright © 2017 Big Dog Tools. All rights reserved.
//

#import "NeNotifications.h"

NSString* const kNENoteBeginChangesNotification     = @"NENoteBeginChangesNotification";
NSString* const kNENoteInsertNoteNotification       = @"NENoteInsertNoteNotification";
NSString* const kNENoteDeleteNoteNotification       = @"NENoteDeleteNoteNotification";
NSString* const kNENoteChangesCompleteNotification  = @"NENoteChangesCompleteNotification";

// to access data in the notifications
NSString* const kNENoteNotificationIndexPathKey     = @"NENoteNotificationIndexPathKey";


@interface NeNotifications ()
@property (strong, nonatomic) NSMutableArray* neNoteList;
@end

@implementation NeNotifications

#pragma mark - Singleton Methods
+(id)sharedSelf
{
    static NeNotifications *sharedNeNotes = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedNeNotes = [[self alloc] init];
    });
    return sharedNeNotes;
    
}

#pragma mark - Initialization Methods
-(id)init
{
    self = [super init];
    if (self)
    {
        _neNoteList = [NSMutableArray array];
    }
    return self;
}

#pragma mark - Public Methods

-(NENotification*) noteAtIndexPath:(NSIndexPath *)indexPath
{
    return self.neNoteList[(NSUInteger)indexPath.row];
}

-(NSIndexPath*) indexPathForNote:(NENotification*) neNote
{
    NSUInteger row = [self.neNoteList indexOfObject:neNote];
    return [NSIndexPath indexPathForRow:row inSection:0];
    // TODO: may have sections and will need to handle
}

-(void) addNote:(NENotification*) neNote// toLoc:(CGPoint)theLoc
{
    // adding a new entry to the note list
    // the new note must have a unique location; but, unplaced as it is the index for the inventory so ...
    // find the first entry that is unplaced (will have negative coordinates)
    
    NSLog(@"in %@:%@ - %@", [self class], @"addNote", neNote.message);
    
    NSInteger index = [self insertionPointForNote: neNote];
    NSIndexPath* indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    
    // update unit
    NSNotificationCenter* center = [NSNotificationCenter defaultCenter];
    [center postNotificationName:kNENoteBeginChangesNotification object:self];
    
    [self insertObject:neNote inNeNoteListAtIndex:index];
    
    [center postNotificationName:kNENoteInsertNoteNotification
                          object:self
                        userInfo:@{kNENoteNotificationIndexPathKey:indexPath}];
    [center postNotificationName:kNENoteChangesCompleteNotification object:self];
    
    __unused int tempCount = (int)self.count;
}

-(void) deleteNoteAtIndexPath:(NSIndexPath *)indexPath
{
    NSNotificationCenter* center = [NSNotificationCenter defaultCenter];
    [center postNotificationName:kNENoteBeginChangesNotification object:self];

    [self removeObjectFromNeNoteListAtIndex:indexPath.row];
    
    [center postNotificationName:kNENoteDeleteNoteNotification object:self
                        userInfo:@{kNENoteNotificationIndexPathKey:indexPath}];
    [center postNotificationName:kNENoteChangesCompleteNotification object:self];
}

-(void) enumerateNotesAscending:(BOOL)ascending withBlock:(NoteEnumeratorBlock)block
{
    NSUInteger options = 0;
    if (ascending) {
        options = NSEnumerationReverse;
    }
    
    [self.neNoteList enumerateObjectsWithOptions:options
                                      usingBlock:^(id obj, NSUInteger idx, BOOL* stop)
     {
         block(obj);
     }];
}

#pragma mark - Private Methods

-(NSInteger) insertionPointForNote: (NENotification*) newNote
{
    NSInteger index = 0;
    
    for (NENotification* neNote in self.neNoteList)
    {
        if (neNote.day < newNote.day) {
            return index;
        }
        index++;
    }
    return index;
}

#pragma mark - NSObject Methods

-(NSString*) description
{
    return [NSString stringWithFormat:@"Notifications: count = %@, history = %@", @(self.count), self.neNoteList];
}

#pragma mark - Accessor Methods
-(NSUInteger) count
{
    return [self.neNoteList count];
}

+(NSSet*) keyPathsforValuesAffectingCount
{
    return [NSSet setWithObjects:@"neNoteList", nil];
}

#pragma mark - KVO Accessors
/*
-(void) insertObject:(NENotification*)object inNENotificationListAtIndex:(NSUInteger)index
{
    [self.neNoteList insertObject:object atIndex:index];
}

 -(void) removeObjectFromNENotificationListAtIndex:(NSUInteger)index
 {
 [self.neNoteList removeObjectAtIndex:index];
 }
 
*/
-(void) insertObject:(NENotification *)object inNeNoteListAtIndex:(NSUInteger)index
{
    [self.neNoteList insertObject:object atIndex:index];
}

-(void) removeObjectFromNeNoteListAtIndex:(NSUInteger)index
{
    [self.neNoteList removeObjectAtIndex:index];
}

@end

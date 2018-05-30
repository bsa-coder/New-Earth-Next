//
//  Calendar.m
//  New Earth
//
//  Created by Scott Alexander on 4/14/17.
//  Copyright © 2017 Big Dog Tools. All rights reserved.
//
/*
 This contains the calendar of events, bonuses, etc. that
 cause notices and get feedback from Mars (sponsor)
 
 */

#import "Calendar.h"

NSString* const kCalendarBeginChangesNotification = @"CalendarBeginChangesNotification";
NSString* const kCalendarInsertEntryNotification = @"CalendarInsertEntryNotification";
NSString* const kkCalendarDeleteEntryNotification = @"CalendarDeleteEntryNotification";
NSString* const kCalendarChangesCompleteNotification = @"CalendarChangesCompleteNotification";
NSString* const kCalendarGameOverNotification = @"CalendarGameOverNotification";

// to access data in the notifications
NSString* const kCalendarNotificationIndexPathKey = @"CalendarNotificationIndexPathKey";

CGPoint milestonesA[5]; // point of x=dayOfContract y=settlers

@implementation NECalendar
@synthesize firstBonus, secondBonus, thirdBonus, fourthBonus;
@synthesize firstPayment, secondPayment;
@synthesize onSchedule, farBehindSchedule, theWarehouse, theMessage;
//@synthesize gi;

#pragma mark - Singleton Methods
+(id)sharedSelf
{
    static NECalendar *sharedCalendar = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedCalendar = [[self alloc] init];
    });
    return sharedCalendar;
}

#pragma mark - Initialization
-(id) init
{
    self = [super init];
    
    if (self) {
        onSchedule = YES;
        farBehindSchedule = NO;
        firstBonus = NO;
        secondBonus = NO;
        thirdBonus = NO;
        fourthBonus = NO;
        
        firstBonus = 500000;
        secondPayment = 300000;
        
        milestonesA[0] = CGPointMake(0.0, 0.0);
        milestonesA[1] = CGPointMake(365.0, 25.0);
        milestonesA[2] = CGPointMake(730.0, 50.0);
        milestonesA[3] = CGPointMake(1095.0, 75.0);
        milestonesA[4] = CGPointMake(1460.0, 100.0);
        
        milestonesA[0] = CGPointMake(0.0, 0.0);
        milestonesA[1] = CGPointMake(10.0, 1.0);
        milestonesA[2] = CGPointMake(20.0, 2.0);
        milestonesA[3] = CGPointMake(30.0, 3.0);
        milestonesA[4] = CGPointMake(40.0, 4.0);

        NSArray *_milestoneList3 = @[
                                    [NSValue valueWithCGPoint:milestonesA[0]],
                                    [NSValue valueWithCGPoint:milestonesA[1]],
                                    [NSValue valueWithCGPoint:milestonesA[2]],
                                    [NSValue valueWithCGPoint:milestonesA[3]],
                                    [NSValue valueWithCGPoint:milestonesA[4]]
                                    ];
        _milestoneList = [[NSMutableArray alloc] initWithArray:_milestoneList3];
        
        theMessage = [[NENotification alloc] initNotificationOnDay:0 from:headquarters type:info content:@"" date:nil isRemote:YES];
        _myGlobals = [NewEarthGlobals sharedSelf]; //myAppDel.theGlobals;// [[NewEarthGlobals alloc] init];
        _neNotes = [NeNotifications sharedSelf]; //myAppDel.neNotes; // [[NeNotifications alloc] init];
//        gi = [[GameInit alloc] init];
    }
    return self;
}

#pragma mark - Methods

-(void) performanceOnDay: (int) thisDay withMySettlers: (int) settlers
{
    CGFloat planAngleToMilestone = 0; // angle from last to next milestone
    CGFloat actAngleToMilestone  = 0; // angle from me to next milestone
    CGFloat distanceToMilestone  = 0; // distance for me to next milestone
    CGFloat distanceForMilestone = 0; // distance from last to next milestone
    
    CGPoint tempPt;
    CGPoint myStatus = CGPointMake(thisDay, (CGFloat)settlers);
    
    NSTimeInterval twentyFourHours = 60.0 * 60.0 * 24.0;
    NSDate* now = [NSDate date];
    
//    planAngleToMilestone = [self angleFromPoint:milestonesA[0] toPoint:milestonesA[1]];
//    tempPt = [self pointBetweenPoint:milestonesA[0] toPoint:milestonesA[1] onDay:thisDay];
//    actAngleToMilestone = [self angleFromPoint: myStatus toPoint: milestonesA[1]];
//    distanceToMilestone = [self distFromPoint:myStatus toPoint:milestonesA[1]];
    
    if (([_milestoneList count] < 2) && (_myGlobals.sustainScore >= 0))
    { NSLog(@"\n\n\n******* GAME OVER ... GAME OVER ... GAME OVER *******\n\n\n");
        [[NSNotificationCenter defaultCenter] postNotificationName:kCalendarGameOverNotification
                                                            object:self
                                                          userInfo:nil];

        return; } // game over really ... nothing left to do for the bosses
    
    CGPoint ptA = [_milestoneList[0] CGPointValue];
    CGPoint ptB = [_milestoneList[1] CGPointValue];

    planAngleToMilestone = [self angleFromPoint:ptA toPoint:ptB];
    tempPt = [self pointBetweenPoint:ptA toPoint:ptB onDay:thisDay];
    actAngleToMilestone = [self angleFromPoint: myStatus toPoint: ptB];
    
    distanceToMilestone = [self distFromPoint:myStatus toPoint:ptB];
    distanceForMilestone = [self distFromPoint:ptA toPoint:ptB];
    
    // calculate message intensity based upon distance to next milestone.
    // for good sectors, large distances are better
    // for bad sectors, large distances are worse
    // small distances add little intensity
    // TODO: determine the weighting of intensity based upon distance, perhaps distance ratio
    // influence text and message type (statusGood, statusBad, warning, urgent, eventGood, eventBad)
    noteType thisNoteType = info;
    NSString* messageToYou = @"";
    
    NSDate* eventDate = [now dateByAddingTimeInterval:twentyFourHours * thisDay];
    if (_myGlobals.dateOfLastMessage == nil) { _myGlobals.dateOfLastMessage = eventDate; }
    
    NSDate* testDate = [_myGlobals.dateOfLastMessage dateByAddingTimeInterval: (twentyFourHours * 27.0)]; // increased from 1 week to be less verbose
    
    BOOL makeMessage = [[eventDate laterDate: testDate] isEqualToDate:eventDate];
    
    if (makeMessage) { _myGlobals.dateOfLastMessage = eventDate; }
    
    // sector A: plan angle decrease to 0 ... 0 better end
    // on or ahead of schedule ... encouragement
    // bigger distance ... more time to succeed ... encouragement
    if (planAngleToMilestone >= actAngleToMilestone && actAngleToMilestone > 0.0) {

        // progressing well
        NSLog(@"in Sector A: planAng = %0.4f actAng = %0.4f dist = %0.0f", planAngleToMilestone, actAngleToMilestone, distanceToMilestone);
        
        thisNoteType = statusGood; // sector A and C
        messageToYou = @"You are making good progress.  Keep it up!"; // good, great, terrific

        if ([_myGlobals.progressSector  isEqual: @"A"]) {
            if (makeMessage) {
//                make a notice, it has been a week
                NSLog(@"in Sector A: message = %@ %@ > %@", messageToYou, eventDate, testDate);
            } else {messageToYou = @"";}
        }
        else {
            // need to make a notice as just entered this sector from somewhere else
            _myGlobals.progressSector = @"A";
            NSLog(@"in Sector A: message = %@ %@ > %@ NEW", messageToYou, eventDate, testDate);
        }
    }
    
    // sector B: plan angle increase to 90 ... 90 bad end
    // behind schedule ... encouragement closer to plan ... caution closer to 90
    // bigger distance ... more time to succeed ... encouragement
    else if (90.0 >= actAngleToMilestone && actAngleToMilestone >= planAngleToMilestone) {
        // met the milestone
        NSLog(@"in Sector B: planAng = %0.4f actAng = %0.4f dist = %0.0f", planAngleToMilestone, actAngleToMilestone, distanceToMilestone);

        if ([_myGlobals.progressSector  isEqual: @"B"]) {
            if (makeMessage) {
                // make a notice, it has been a week
                messageToYou = @"You are falling behind schedule.  You have time, don't waste it.  Remember you have commitments to keep.";
                thisNoteType = statusBad; // sector B
                NSLog(@"in Sector B: message = %@ %@ > %@", messageToYou, eventDate, testDate);
            } else {messageToYou = @""; return; }
        }
        else {
            // need to make a notice as just entered this sector from somewhere else
            _myGlobals.progressSector = @"B";
            messageToYou = @"You are falling behind schedule.  You have time, don't waste it.  Remember you have commitments to keep.";
            thisNoteType = statusBad; // sector B
            NSLog(@"in Sector B: message = %@ %@ > %@ NEW", messageToYou, eventDate, testDate);
        }
    }
    
    // sector C: 0 decrease to -90 past milestone early
    // ahead of schedule ... praise for accomplishing goal
    // bigger distance ... great praise ... smaller distance ... weaker praise
    else if (0 >= actAngleToMilestone && actAngleToMilestone >= -90) {
        // met the milestone
        NSLog(@"in Sector C: planAng = %0.4f actAng = %0.4f dist = %0.0f", planAngleToMilestone, actAngleToMilestone, distanceToMilestone);


        // get rid of milestone
        if (([_milestoneList count] == 2) && (_myGlobals.sustainScore <= 0))
        { NSLog(@"******* GAME OVER ... GAME OVER ... GAME OVER *******");
            [[NSNotificationCenter defaultCenter] postNotificationName:kCalendarGameOverNotification
                                  object:self
                                userInfo:nil];
            

            return;
        } // game over
        else if ([_milestoneList count] > 2)
        { [_milestoneList removeObjectAtIndex:0]; }
        else { NSLog(@"Should never get here."); return; }
        
        if ([_myGlobals.progressSector  isEqual: @"C"]) {
            if (makeMessage) {
                // make a notice, it has been a week
                thisNoteType = eventGood; // sector C
                messageToYou = @"Congratulations meeting this milestone.  Good job.  Don't lose focus as there is another milestone to meet."; // good, great, terrific
                NSLog(@"in Sector C: message = %@ %@ > %@", messageToYou, eventDate, testDate);
            } else {messageToYou = @"";}
        }
        else {
            // need to make a notice as just entered this sector from somewhere else
            _myGlobals.progressSector = @"C";
            thisNoteType = eventGood; // sector C
            messageToYou = @"Congratulations meeting this milestone.  Good job.  Don't lose focus as there is another milestone to meet."; // good, great, terrific
            NSLog(@"in Sector C: message = %@ %@ > %@ NEW", messageToYou, eventDate, testDate);
        }
    }
    
    // sector D: -90 decrease to -180 past milestone late
    // behind schedule but past milestone ... caution
    // bigger distance ... caution to threat as distance increases
    else if (-90 >= actAngleToMilestone && actAngleToMilestone >= -180) {
        // met the milestone
        // get rid of milestone
        if ([_milestoneList count] == 2) { return; } // game over
        else if ([_milestoneList count] > 2)
        { [_milestoneList removeObjectAtIndex:0]; }
        else { NSLog(@"Should never get here."); return; }
        
        NSLog(@"in Sector D: planAng = %0.4f actAng = %0.4f dist = %0.0f", planAngleToMilestone, actAngleToMilestone, distanceToMilestone);
        

        if ([_myGlobals.progressSector  isEqual: @"D"]) {
            if (makeMessage) {
                // make a notice, it has been a week
                thisNoteType = warning; // sector D
                messageToYou = @"Our goals are reasonable and attainable.  Get back on schedule!  Our customers are packed and waiting on you.  ";
                NSLog(@"in Sector D: message = %@ %@ > %@", messageToYou, eventDate, testDate);
            } else {messageToYou = @"";}
        }
        else { // just entered sector D
            // need to make a notice as just entered this sector from somewhere else
            _myGlobals.progressSector = @"D";
            thisNoteType = warning; // sector D
            messageToYou = @"Our goals are reasonable and attainable.  Get back on schedule!  Our customers are packed and waiting on you.  ";
            NSLog(@"in Sector D: message = %@ %@ > %@ NEW", messageToYou, eventDate, testDate);
        }
    }
    
    // sector E: 90 increase to 180 behind schedule and behind milestone
    // need to catch up ... closer to 180 better so weaker threats
    // bigger distance ... demands for better performance ... threats
    else if (180.0 >= actAngleToMilestone && actAngleToMilestone >= 90.0) {
        // met the milestone
        // get rid of milestone
        NSLog(@"in Sector E: planAng = %0.4f actAng = %0.4f dist = %0.0f", planAngleToMilestone, actAngleToMilestone, distanceToMilestone);
        

        if ([_myGlobals.progressSector  isEqual: @"E"]) { // been in here before
            if (makeMessage) {
                // make a notice, it has been a week
                thisNoteType = urgent; //sector E
                messageToYou = @"This is unacceptable.  We have commitments that will be met ... by you or your successor.  Get back on schedule!";
                NSLog(@"in Sector E: message = %@ %@ > %@", messageToYou, eventDate, testDate);
            } else {messageToYou = @"";}
        }
        else { // just entered sector E
            // need to make a notice as just entered this sector from somewhere else
            _myGlobals.progressSector = @"E";
            thisNoteType = urgent; //sector E
            messageToYou = @"This is unacceptable.  We have commitments that will be met ... by you or your successor.  Get back on schedule!";
            NSLog(@"in Sector E: message = %@ %@ > %@ NEW", messageToYou, eventDate, testDate);
        }
    }
    
    if ([messageToYou isEqualToString: @""]) { return; }
    
    NSLog(@"AAAA %@: thisDay: %d eventDate: %@", messageToYou, thisDay, eventDate);
    NENotification* theNote = [[NENotification alloc] initNotificationOnDay:thisDay from:headquarters type:thisNoteType content:messageToYou date:eventDate isRemote:YES];
    [_neNotes addNote:theNote];
}

-(CGPoint) pointBetweenPoint: (CGPoint) startPoint toPoint: (CGPoint) endPoint onDay: (int) theDay
{
    CGFloat yForDay = 0.0;
    yForDay = ((endPoint.y - startPoint.y) / (endPoint.x - startPoint.x)) * (theDay - startPoint.x) + startPoint.y;
    return CGPointMake(theDay,yForDay);
}

-(CGFloat) distFromPoint:(CGPoint) firstPoint toPoint: (CGPoint) secondPoint
{
    double theDist = 0.0;
    theDist = sqrt(pow(secondPoint.x - firstPoint.x, 2.0) + pow(secondPoint.y - firstPoint.y, 2.0));
    return (CGFloat) theDist;
}

-(CGFloat) angleFromPoint: (CGPoint) firstPoint toPoint: (CGPoint) secondPoint
{
    double theAngleInDegrees = 0.0;
    theAngleInDegrees = atan((secondPoint.y - firstPoint.y) / (secondPoint.x - firstPoint.x)) * 180 / M_PI;
    if ((secondPoint.x - firstPoint.x) < 0) { theAngleInDegrees = 180.0 + theAngleInDegrees; }
    return theAngleInDegrees;
}

-(CGFloat) calcBonusForDay: (int) dayOfContract withLabor: (int) workers
{
    // two bonuses available for years one and two
    int yearOneLaborGoal  = 25;
    int yearTwoLaborGoal  = 50;
    int yearOneEndOfBonus = 365;
    int yearTwoEndOfBonus = 730;
    
    int endOfBonus = 0;
    int bonusGoal  = 0;
    CGFloat bonusAmount = 100000.0;
    
    CGFloat theBonus = 0;
    
    if (dayOfContract > yearTwoEndOfBonus) { return theBonus; } // bonuses expired
    // in the bonus period (first two years)
    if (workers       < yearOneLaborGoal)  { return theBonus; } // no bonus if too few workers
    
    endOfBonus = (dayOfContract <= yearOneEndOfBonus ? yearOneEndOfBonus : yearTwoEndOfBonus);
    bonusGoal  = (dayOfContract <= yearOneEndOfBonus ? yearOneLaborGoal  : yearTwoLaborGoal);

    if (workers >= bonusGoal) {
        // earned a bonus ... now how big is it
        if      (dayOfContract <= endOfBonus - 160)
        {
            theBonus = bonusAmount;
        }
        else if (dayOfContract > endOfBonus - 160 && dayOfContract <= endOfBonus - 115)
        {
            theBonus = bonusAmount * 0.5;
        }
        else if (dayOfContract > endOfBonus - 115 && dayOfContract <= endOfBonus - 69)
        {
            theBonus = bonusAmount * 0.25;
        }
        else if (dayOfContract > endOfBonus -  69 && dayOfContract <= endOfBonus)
        {
            theBonus = bonusAmount * 0.1;
        }
    }
    
    if (theBonus > 0) {
        // congratulations bonus attained
    }

    return theBonus;
}

/*
-(float)checkTheCalendarOnDay:(int) dayOfContract withLabor: (int) theLaborers
{
    NSString* strMessage = @"";
    
    if (dayOfContract < 274) {
        // do nothing
    }
    else if (dayOfContract >= 274 && dayOfContract < 320) {
        if (theLaborers >= 25) {
            strMessage = @"you get a bonus for being ahead of schedule";
//            if(!firstBonus) firstBonus = [self grantBonus:1];
            onSchedule = YES;
            theMessage.message = strMessage;
        }
    }
    else if (dayOfContract >= 320 && dayOfContract < 365) {
        if (theLaborers >= 25) {
            strMessage = @"you get no bonus but still on schedule";
            firstBonus = YES;
        } else {
            strMessage = @"behind schedule";
            onSchedule = NO;
        }
    }
    else if (dayOfContract >= 365 && dayOfContract < 456) {
        if (theLaborers < 25) {
            strMessage = @"behind schedule";
            firstBonus = NO;
        } else {
            strMessage = @"no bonus but on schedule ... barely ";
            onSchedule = YES;
        }
    }
    else if (dayOfContract >= 456 && dayOfContract < 548) {
        if (theLaborers >= 25) {
            strMessage = @"on schedule";
            onSchedule = YES;
        } else {
            strMessage = @"behind schedule";
            onSchedule = NO;
        }
    }
    else if (dayOfContract >= 548 && dayOfContract < 639) {
        if (theLaborers >= 50) {
            strMessage = @"you get a bonus for being ahead of schedule";
//            if(!secondBonus) secondBonus = [self grantBonus:2]  ;
        } else if (theLaborers < 25) {
            strMessage = @"you get a bonus for good work";
            farBehindSchedule = YES;
        } else {
            onSchedule = YES;
            farBehindSchedule = NO;
        }
    }
    else if (dayOfContract >= 639 && dayOfContract < 730) {
        if (theLaborers >= 50) {
            strMessage = @"you get no bonus but still on schedule";
            firstBonus = YES;
        }
        strMessage = @"you get a bonus for good work";
    }
    else if (dayOfContract >= 730 && dayOfContract < 821) {
        if (theLaborers >= 50) {
            strMessage = @"behind schedule";
            firstBonus = YES;
        }
        strMessage = @"you get a bonus for good work";
    }
    else if (dayOfContract >= 821 && dayOfContract < 958) {
        if (theLaborers >= 25) {
            strMessage = @"you get a bonus for being ahead of schedule";
            firstBonus = YES;
        }
        strMessage = @"you get a bonus for good work";
    }
    else if (dayOfContract >= 958 && dayOfContract < 1095) {
        if (theLaborers >= 25) {
            strMessage = @"no bonus and on schedule";
            firstBonus = YES;
        }
        strMessage = @"you get a bonus for good work";
    }
    else if (dayOfContract >= 1095 && dayOfContract < 1186) {
        if (theLaborers >= 25) {
            strMessage = @"behind schedule";
            firstBonus = YES;
        }
        strMessage = @"you get a bonus for good work";
    }
    else if (dayOfContract >= 1186 && dayOfContract < 1278) {
        if (theLaborers >= 25) {
            strMessage = @"you get a bonus for being ahead of schedule";
            firstBonus = YES;
        }
        strMessage = @"you get a bonus for good work";
    }
    else if (dayOfContract >= 1278 && dayOfContract < 1460) {
        if (theLaborers >= 25) {
            strMessage = @"no bonus behind schedule";
            firstBonus = YES;
        }
        
        strMessage = @"you get a bonus for good work";
    }
    else {
        strMessage = @"end of the contract";
    }

//    (int) <noteType> calendarNoteType = (noteType) info;
    
    theMessage.type = warning;
    theMessage.day = dayOfContract;
    
    return 1.0;
}
*/

@end

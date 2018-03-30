//
//  NotificationsViewController.m
//  New Earth
//
//  Created by Scott Alexander on 7/17/17.
//  Copyright © 2017 Big Dog Tools. All rights reserved.
//

#import "NotificationsViewController.h"
//#import "localTableViewCell.h"
//#import "remoteTableViewCell.h"

@class NeNotifications;

@interface NotificationsViewController ()
@property (strong, nonatomic) id noteBeganObserver;
@property (strong, nonatomic) id noteInsertedObserver;
@property (strong, nonatomic) id noteDeletedObserver;
@property (strong, nonatomic) id noteChangeCompleteObserver;

@property (strong, nonatomic) NeNotifications* neNoteList;

//@property UITableView* testTable;

@end

//NSString* const kSetUpdateNotification = @"SetUpdateNotification";

@interface NotificationsViewController()
{
    UITableView* theTable;
}
@end

@implementation NotificationsViewController
//@synthesize tableView, tableViewCellLocal, tableViewCellRemote;

// delete this after TESTING!
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    NSLog(@"%@ appeared, notes %@", [self class], self.neNoteList);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

}

-(void) viewWillAppear:(BOOL)animated
{
    // do some stuff here
    [super viewWillAppear:YES];

    const CGFloat* aColorComp;
    CGColorRef aColor = (__bridge CGColorRef)([UIColor whiteColor]);// [itemTypeColor CGColor];
    aColorComp = CGColorGetComponents(aColor);
    UIColor* myBkgdColor = [UIColor colorWithRed:aColorComp[0] green:aColorComp[1] blue:aColorComp[2] alpha:0.5];
    
    self.view.alpha = 1.0;
    self.view.backgroundColor = myBkgdColor;

    _center = [NSNotificationCenter defaultCenter];
    
    [_center addObserver:self
               selector:@selector(handleUpdateNotification:)
                   name:kSetUpdateNotification
                 object:nil];
}

-(void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - Table view data source

-(void) handleUpdateNotification:(NSNotification*) paramNotification { [self updateUI]; }
-(void) updateUI {[theTable setNeedsDisplay];}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
//    NSLog(@"numberofSectionsInTable = %lu",(unsigned long)1);
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_neNoteList count];
}

- (void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.backgroundColor = [self messageColor:[_neNoteList noteAtIndexPath:indexPath].type];
}

#define TOP_LABEL_TAG 1001
#define BOTTOM_LABEL_TAG 1002
#define PHOTO_TAG 1003


- (UITableViewCell *)tableView:(UITableView *) tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NENotification* theNote = [_neNoteList noteAtIndexPath:indexPath];
    
    UILabel *topLabel;
    UILabel *bottomLabel;
    UIImageView* photo;

    static NSString *CellIDLeft = @"CellLeft";
    static NSString* CellIDRight = @"CellRight";
    
    UITableViewCell *cell;
    
    if (theNote.remote) {
        cell = [theTable dequeueReusableCellWithIdentifier:CellIDLeft];
    }
    else {
        cell = [theTable dequeueReusableCellWithIdentifier:CellIDRight];
    }
    
    if (cell == nil)
    {
        //
        // Create the cell.
        //
        if (theNote.remote) {
            cell = [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleSubtitle reuseIdentifier: CellIDLeft];
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        else {
            cell = [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleValue1 reuseIdentifier: CellIDRight];
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.detailTextLabel.font = [UIFont italicSystemFontOfSize:12];
            cell.detailTextLabel.textColor = [UIColor blackColor];
        }
        
        
        topLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 220.0, 15.0)];
        topLabel.tag = TOP_LABEL_TAG;
        topLabel.font = [UIFont systemFontOfSize:14.0];
//        topLabel.textAlignment = UITextAlignmentRight;
        topLabel.textColor = [UIColor blackColor];
        topLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleHeight;
//        [cell.contentView addSubview:topLabel];
        
        bottomLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 20.0, 220.0, 25.0)];
        bottomLabel.tag = BOTTOM_LABEL_TAG;
        bottomLabel.font = [UIFont systemFontOfSize:12.0];
//        bottomLabel.textAlignment = UITextAlignmentRight;
        bottomLabel.textColor = [UIColor darkGrayColor];
        bottomLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleHeight;
//        [cell.contentView addSubview:bottomLabel];
        
        photo = [[UIImageView alloc] initWithFrame:CGRectMake(225.0, 0.0, 80.0, 45.0)];
        photo.tag = PHOTO_TAG;
        photo.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleHeight;
//        [cell.contentView addSubview:photo];
    } else {
//        topLabel = (UILabel *)[cell.contentView viewWithTag:TOP_LABEL_TAG];
//        bottomLabel = (UILabel *)[cell.contentView viewWithTag:BOTTOM_LABEL_TAG];
//        photo = (UIImageView *)[cell.contentView viewWithTag:PHOTO_TAG];
    }

//    NSDictionary *aDict = [self.list objectAtIndex:indexPath.row];
    topLabel.text = [NSString stringWithFormat:@"%@ - %ld.",[_neNoteList noteAtIndexPath:indexPath].date, (unsigned long)[_neNoteList count]];
    bottomLabel.text = [NSString stringWithFormat: @"%@", theNote.message];
//    topLabel.text = [aDict objectForKey:@"mainTitleKey"];
//    bottomLabel.text = [aDict objectForKey:@"secondaryTitleKey"];
//    NSString *imagePath = [[NSBundle mainBundle] pathForResource:[aDict objectForKey:@"imageKey"] ofType:@"png"];
//    UIImage *theImage = [UIImage imageWithContentsOfFile:imagePath];
    UIImage *indicatorImage = [UIImage imageNamed: @"Image-2"];
    photo.image = indicatorImage;
    photo.backgroundColor = [self showMyColor:theNote.source];
    
    cell.textLabel.text = [NSString stringWithFormat:@"Date: %ld",(long)[_neNoteList noteAtIndexPath:indexPath].day];
    cell.detailTextLabel.text = [NSString stringWithFormat: @"%@", theNote.message];
    UIImage *indicatorImage2 = [UIImage imageNamed: @"Image-2"];
    cell.imageView.image = indicatorImage2;
    cell.imageView.backgroundColor = [self showMyColor:theNote.source];

    return cell;
}

- (void)tableView:(UITableView *)tableView2 didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    NSLog(@"section: %ld  row: %ld", indexPath.section, (long)indexPath.row);
    
    UITableViewCell* selectedCell = [[UITableViewCell alloc]init];
    selectedCell = [self tableView:tableView2 cellForRowAtIndexPath:indexPath];
//    [self configureCell:selectedCell forIndexPath:indexPath];
    
    NSLog(@"    -----    cell item = %ld", (long)indexPath.item);
    
//    NewTech* aUnit = [[myStore unitInventoryList] objectAtIndex:indexPath.item];
//    NewTech* aUnit = [_availTech unitAtIndexPath:indexPath];
//    aNewUnit = aUnit;
    
//    [self performSegueWithIdentifier:@"toUnitDetailViewController" sender:self];
}

#pragma mark - Accessor Methods

-(void) setNeNoteList:(NeNotifications*) noteList
{
    if (noteList) {
        [self removeNotifications];
    }
    _neNoteList = noteList;
    [self setupNotifications];
}

#pragma mark - Private Methods

-(UIColor*) configureCellBackgroundColor: (UITableViewCell*) cell forType: (noteType) theType
{
    UIColor* retVal;
    
//    cell.textLabel.font = [UIFont systemFontOfSize:20];
    
    switch (theType) {
        case urgent:
            retVal = [UIColor redColor];
            cell.textLabel.textColor = [UIColor yellowColor];
            cell.textLabel.font = [UIFont boldSystemFontOfSize:20];
            break;
            
        case warning:
            retVal = [UIColor yellowColor];
            cell.textLabel.textColor = [UIColor redColor];
            cell.textLabel.font = [UIFont boldSystemFontOfSize:20];
            break;
            
        case statusBad:
            retVal = [UIColor whiteColor];
            cell.textLabel.textColor = [UIColor redColor];
            cell.textLabel.font = [UIFont boldSystemFontOfSize:20];
            break;
            
        case statusGood:
            retVal = [UIColor whiteColor];
            cell.textLabel.textColor = [UIColor greenColor];
            break;
            
        case eventBad:
            retVal = [UIColor lightGrayColor];
            cell.textLabel.textColor = [UIColor redColor];
            cell.textLabel.font = [UIFont boldSystemFontOfSize:20];
            break;
            
        case eventGood:
            retVal = [UIColor lightGrayColor];
            cell.textLabel.textColor = [UIColor greenColor];
            //            cell.textLabel.textColor = [UIColor lightTextColor];
            break;
            
        default: // info
            retVal = [UIColor whiteColor];
            cell.textLabel.textColor = [UIColor blackColor];
            break;
    }
    return retVal;
}

-(void) configureCell: (UITableViewCell*) cell forType: (noteType) theType
{
    cell.textLabel.font = [UIFont systemFontOfSize:20];
    
    switch (theType) {
        case urgent:
            cell.backgroundColor = [UIColor redColor];
            cell.textLabel.textColor = [UIColor yellowColor];
            cell.textLabel.font = [UIFont boldSystemFontOfSize:20];
            break;
            
        case warning:
            cell.backgroundColor = [UIColor yellowColor];
            cell.textLabel.textColor = [UIColor redColor];
            cell.textLabel.font = [UIFont boldSystemFontOfSize:20];
            break;
            
        case statusBad:
            cell.backgroundColor = [UIColor whiteColor];
            cell.textLabel.textColor = [UIColor redColor];
            cell.textLabel.font = [UIFont boldSystemFontOfSize:20];
            break;
            
        case statusGood:
            cell.backgroundColor = [UIColor whiteColor];
            cell.textLabel.textColor = [UIColor greenColor];
            break;
            
        case eventBad:
            cell.backgroundColor = [UIColor lightGrayColor];
            cell.textLabel.textColor = [UIColor redColor];
            cell.textLabel.font = [UIFont boldSystemFontOfSize:20];
            break;
            
        case eventGood:
            cell.backgroundColor = [UIColor lightGrayColor];
            cell.textLabel.textColor = [UIColor greenColor];
            //            cell.textLabel.textColor = [UIColor lightTextColor];
            break;
            
        default: // info
            cell.backgroundColor = [UIColor whiteColor];
            cell.textLabel.textColor = [UIColor blackColor];
            break;
    }
}
/*
-(void) configureCell:(UITableViewCell*) cell forIndexPath: (NSIndexPath*) indexPath
{
    NENotification* theNote = [self.neNoteList noteAtIndexPath:indexPath];
    
    if (theNote.remote) {
        [self configureRemoteCell:(remoteTableViewCell*) cell forIndexPath:indexPath];
    }
    else
    {
        [self configureLocalCell:(localTableViewCell*) cell forIndexPath:indexPath];
    }
}
 */

/*
-(void) configureLocalCell:(localTableViewCell*) cell forIndexPath: (NSIndexPath*) indexPath
{
    NENotification* theNote = [self.neNoteList noteAtIndexPath:indexPath];
    cell.textLabel.text = [theNote message];
    cell.noteColorView.backgroundColor = [self showMyColor: [theNote source]];
    [cell.textLabel setAdjustsFontSizeToFitWidth:YES];
    
//    UIFont* labelFont = [UIFont systemFontOfSize:10.0f];
//    [cell.textLabel setFont:labelFont];
    [self configureCell: (UITableViewCell*) cell forType: theNote.type];
}
*/
/*
-(void) configureRemoteCell:(remoteTableViewCell*) cell forIndexPath: (NSIndexPath*) indexPath
{
    NENotification* theNote = [self.neNoteList noteAtIndexPath:indexPath];
    cell.textLabel.text = [theNote message];
    cell.noteColorView.backgroundColor = [self showMyColor: [theNote source]];
    [cell.textLabel setAdjustsFontSizeToFitWidth:YES];
    
//    UIFont* labelFont = [UIFont systemFontOfSize:10.0f];
//    [cell.textLabel setFont:labelFont];
    [self configureCell: (UITableViewCell*) cell forType: theNote.type];
}
*/

-(UIColor*) showMyColor: (noteSource)myType
{
    /*
     plant, // plant food
     meat, // animal food (fish, poultry, etc.)
     air, // generates breathable air
     water, // generates potable water
     mineral, // mining, etc to get minerals
     power, // converts input to useable power
     waste, // waste treatment
     civil, // services police, fire, admin
     home, // homestead
     tree // trees ... non food producing but may provide lumber or fruit
     */
    UIColor* theColorIs;
    
    switch (myType) {
        case news: theColorIs = [UIColor purpleColor]; break;
        case goal: theColorIs = [UIColor greenColor]; break;
        case headquarters: theColorIs = [UIColor redColor]; break;
        case fromHome: theColorIs = [UIColor purpleColor]; break;
        case fromPlant: theColorIs = [UIColor greenColor]; break;
        case fromMeat: theColorIs = [UIColor redColor]; break;
        case fromAir: theColorIs = [UIColor whiteColor]; break;
        case fromWater: theColorIs = [UIColor blueColor]; break;
        case fromWaste: theColorIs = [UIColor brownColor]; break;
        case fromMine: theColorIs = [UIColor grayColor]; break;
        case fromCivil: theColorIs = [UIColor magentaColor]; break;
        case fromTree: theColorIs = [UIColor orangeColor]; break;
        case fromPower: theColorIs = [UIColor yellowColor]; break;
        case fromFab: theColorIs = [UIColor lightGrayColor]; break;
            
        default:
            theColorIs = [UIColor cyanColor]; break;
    }
    return theColorIs;
}

-(UIColor*) messageColor: (noteType)myType
{
    UIColor* theColorIs;
    
    switch (myType) {
        case urgent: theColorIs = [UIColor redColor]; break;
        case warning: theColorIs = [UIColor yellowColor]; break;
        case statusBad: theColorIs = [UIColor whiteColor]; break;
        case statusGood: theColorIs = [UIColor whiteColor]; break;
        case eventBad: theColorIs = [UIColor lightGrayColor]; break;
        case eventGood: theColorIs = [UIColor lightGrayColor]; break;
        default: theColorIs = [UIColor whiteColor]; break;
    }
    return theColorIs;
}

-(UIColor*) messageTextColor: (noteType)myType
{
    UIColor* theColorIs;
    
    switch (myType) {
        case urgent: theColorIs = [UIColor yellowColor]; break;
        case warning: theColorIs = [UIColor redColor]; break;
        case statusBad: theColorIs = [UIColor redColor]; break;
        case statusGood: theColorIs = [UIColor greenColor]; break;
        case eventBad: theColorIs = [UIColor redColor]; break;
        case eventGood: theColorIs = [UIColor blackColor]; break;
        default: theColorIs = [UIColor blackColor]; break;
    }
    return theColorIs;
}

-(void) removeNotifications
{
    NSNotificationCenter* center = [NSNotificationCenter defaultCenter];
    
    if (self.noteBeganObserver) {
        [center removeObserver:self.noteBeganObserver];
        self.noteBeganObserver = nil;
    }
    
    if (self.noteInsertedObserver) {
        [center removeObserver:self.noteInsertedObserver];
        self.noteInsertedObserver = nil;
    }
    
    if (self.noteDeletedObserver) {
        [center removeObserver:self.noteDeletedObserver];
        self.noteDeletedObserver = nil;
    }
    
    if (self.noteChangeCompleteObserver) {
        [center removeObserver:self.noteChangeCompleteObserver];
        self.noteChangeCompleteObserver = nil;
    }
}

-(void) setupNotifications
{
    NSNotificationCenter* center = [NSNotificationCenter defaultCenter];
    NSOperationQueue* mainQueue = [NSOperationQueue mainQueue];
    NeNotifications* noteList = self.neNoteList;
    __weak NotificationsViewController* _self = self;
    
    self.noteBeganObserver = [center
                             addObserverForName:kNENoteBeginChangesNotification
                             object:noteList
                             queue:mainQueue
                             usingBlock:^(NSNotification* note) {
//                                 NSLog(@"noteBeganObserver");
                                 if ([self isViewLoaded]) {
                                     [theTable beginUpdates];
                                 }
                             }];
    
    self.noteInsertedObserver = [center
                                addObserverForName:kNENoteInsertNoteNotification
                                object:noteList
                                queue:mainQueue
                                usingBlock:^(NSNotification* note){
//                                    NSLog(@"noteInsertedObserver - %ld", [self.neNoteList count]);
                                    NSIndexPath* indexPath = note.userInfo[kNENoteNotificationIndexPathKey];
                                    
                                    NSAssert(indexPath != nil,
                                             @"we should have an index path in the "
                                             @"notifications's user infor dictionary");
                                    
                                    if ([_self isViewLoaded]) {
                                        [theTable cellForRowAtIndexPath:indexPath];
                                        [theTable insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                                    }
                                }];
    
    self.noteDeletedObserver = [center
                               addObserverForName:kNENoteDeleteNoteNotification
                               object:noteList
                               queue:mainQueue
                               usingBlock:^(NSNotification* note){
//                                   NSLog(@"noteDeletedObserver");
                                   NSIndexPath* indexPath = note.userInfo[kNENoteNotificationIndexPathKey];
                                   
                                   NSAssert(indexPath != nil,
                                            @"we should have an index path in the "
                                            @"notifications's user infor dictionary");
                                   if ([_self isViewLoaded]) {
                                       [theTable deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                                   }
                               }];
    
    self.noteChangeCompleteObserver = [center
                                      addObserverForName:kNENoteChangesCompleteNotification
                                      object:noteList
                                      queue:mainQueue
                                      usingBlock:^(NSNotification* note){
//                                          NSLog(@"noteChangeCompleteObserver");
                                          [theTable endUpdates];
                                      }];
    
}

@end

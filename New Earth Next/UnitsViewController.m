//
//  UnitsViewController.m
//  New Earth
//
//  Created by Scott Alexander on 4/21/17.
//  Copyright © 2017 Big Dog Tools. All rights reserved.
//

#import "UnitsViewController.h"
#import "UnitInventory.h"
#import "AvailTech.h"
#import "Globals.h"
#import "NewTech.h"
#import "GameViewController.h"

@class UnitInventory;
@class AvailTech;
@class NewEarthGlobals;

@interface UnitsViewController ()
@property (strong, nonatomic) id docBeganObserver;
@property (strong, nonatomic) id docInsertedObserver;
@property (strong, nonatomic) id docDeletedObserver;
@property (strong, nonatomic) id docChangeCompleteObserver;

@property (strong, nonatomic) UnitInventory* unitInventory;
@property (strong, nonatomic) AvailTech* availTech;
@property (strong, nonatomic) NewEarthGlobals* theGlobals;

@end

@implementation UnitsViewController
{
//    NSArray* aTable;
}

@synthesize aNewUnit;

// delete this after TESTING!
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    NSLog(@"%@ appeared, availtec %@", [self class], self.availTech);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"%@ loaded, availtec %@", [self class], self.availTech);
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void) dealloc
{
    [self removeNotifications];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
//    NSLog(@"numberofSectionsInTable = %lu",(unsigned long)1);
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_availTech count];
}

- (NSString*)tableView:(UITableView*)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"Unit Type";
}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* CellIdentifier = @"NewTechCell";
    
//    UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    // Configure the cell...
    
    NewTech* aUnit = [[myStore unitInventoryList] objectAtIndex:indexPath.item];
    aNewUnit = aUnit;
    
    cell.textLabel.text = aUnit.myName;
    cell.backgroundColor = aUnit.showMyColor;
    
    return cell;
 
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    cell.textLabel.text = [myStore.unitInventoryList objectAtIndex:indexPath.row];
    return cell;
    
}
 */

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    NewTech* aUnit = [_availTech unitAtIndexPath:indexPath];
//    cell.textLabel.text = [NSString stringWithFormat:@"%@:%f-%f", aUnit.myName, self.theTapLocation.x, self.theTapLocation.y];
    cell.textLabel.text = [NSString stringWithFormat:@"%@", aUnit.myName];
    cell.backgroundColor = aUnit.showMyColor;
    cell.imageView.image = [UIImage imageNamed:[aUnit getMyIcon]];
//    cell.imageView.image = [UIImage imageNamed:aUnit.itemIcon];
//    cell.textLabel.text = [aTable objectAtIndex:indexPath.row];
//    cell.imageView.image = [UIImage imageNamed:@"img_1664.jpg"];//    cell.textLabel.text = [aTable objectAtIndex:indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"section: %ld  row: %ld", (long)indexPath.section, (long)indexPath.row);
    
    UITableViewCell* selectedCell = [[UITableViewCell alloc]init];
    selectedCell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    NSLog(@"    -----    cell item = %ld", (long)indexPath.item);
    
//    NewTech* aUnit = [[myStore unitInventoryList] objectAtIndex:indexPath.item];
    NewTech* aUnit2 =  [_availTech unitAtIndexPath:indexPath];
    NewTech* aUnit = [[NewTech alloc] initWithUnit: aUnit2];
    
//    NSLog(@"----- table values: %@::%@", aNewUnit.myName, aUnit.myName);
    if (aUnit.myName == aNewUnit.myName) {
//        aNewUnit = aUnit;
        [self performSegueWithIdentifier:@"toUnitDetailViewController" sender:self];
    }
    aNewUnit = aUnit;
}

#pragma mark - Accessor Methods

-(void) setAvailTech: (AvailTech*) availTech
{
    if (_availTech) {
        [self removeNotifications];
    }
    _availTech = availTech;
    [self setupNotifications];
}

-(void) setUnitInventory:(UnitInventory *) unitInventory
{
    if (_unitInventory) {
        [self removeNotifications];
    }
    _unitInventory = unitInventory;
    [self setupNotifications];
}

-(void) setMyGlobals:(NewEarthGlobals *)theGlobals { _theGlobals = theGlobals; }

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSLog(@"in prepareForSegue UVC");
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if([segue.identifier isEqualToString:@"toUnitDetailViewController"])
    {
        
        id destController = segue.destinationViewController;

        if ([destController respondsToSelector:@selector(setUnitInventory:)]) {
            [destController setUnitInventory:self.unitInventory];
        }
//        if ([controller respondsToSelector:@selector(setNeNoteList:)]) {
//            [controller setNeNoteList:self.neNotes];
//        }
        if ([destController respondsToSelector:@selector(setMyGlobals:)]) {
            [destController setMyGlobals:self.theGlobals];
        }
        

        UnitsDetailViewController* destController2 = segue.destinationViewController;
        
        destController2.aUnit = aNewUnit;
        destController2.theTapLocation = self.theTapLocation;
    
    }
    else if([segue.identifier isEqualToString:@"toMapViewController"])
    {
        UITabBarController* destController = segue.destinationViewController;
        destController.selectedViewController = [destController.viewControllers objectAtIndex:0];
    }
}

#pragma mark - Private Methods

- (IBAction)placeTheNewUnit:(id)sender
{
    NSLog(@"++++++++++++++ clicked the PlaceTheNewUnit ++++++++++++++");

    if (aNewUnit) {
        aNewUnit.myLoc = [self theTapLocation];
//        aNewUnit.myLoc = [(GameViewController*)(self.presentingViewController) theTapLocation];
        aNewUnit.myCreateDate = [NSDate date];
//        aNewUnit.myName = theNewUnitName.text;

        [_unitInventory addUnit:aNewUnit];
        _theGlobals.bankAccountBalance -= aNewUnit.myCost;
        [self performSegueWithIdentifier:@"toMapViewController" sender:self];

        [aNewUnit printMe];
    } 
}


-(void) removeNotifications
{
    NSNotificationCenter* center = [NSNotificationCenter defaultCenter];
    
    if (self.docBeganObserver) {
        [center removeObserver:self.docBeganObserver];
        self.docBeganObserver = nil;
    }
    
    if (self.docInsertedObserver) {
        [center removeObserver:self.docInsertedObserver];
        self.docInsertedObserver = nil;
    }
    
    if (self.docDeletedObserver) {
        [center removeObserver:self.docDeletedObserver];
        self.docDeletedObserver = nil;
    }
    
    if (self.docChangeCompleteObserver) {
        [center removeObserver:self.docChangeCompleteObserver];
        self.docChangeCompleteObserver = nil;
    }
}

-(void) setupNotifications
{
    NSNotificationCenter* center = [NSNotificationCenter defaultCenter];
    NSOperationQueue* mainQueue = [NSOperationQueue mainQueue];
    UnitInventory* store = self.availTech;
    __weak UnitsViewController* _self = self;
    
    self.docBeganObserver = [center
                             addObserverForName:kUnitInventoryBeginChangesNotification
                             object:store
                             queue:mainQueue
                             usingBlock:^(NSNotification* note) {
        if ([self isViewLoaded]) {
            [self.theTable beginUpdates];
        }
    }];
    
    self.docInsertedObserver = [center
                                addObserverForName:kUnitInventoryInsertEntryNotification
                                object:store
                                queue:mainQueue
                                usingBlock:^(NSNotification* note){
        NSIndexPath* indexPath = note.userInfo[kUnitInventoryNotificationIndexPathKey];
        NSAssert(indexPath != nil,
                 @"we should have an index path in the "
                 @"notifications's user infor dictionary");
        
        if ([_self isViewLoaded]) {
            [_self.theTable insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
    }];
    
    self.docDeletedObserver = [center
                               addObserverForName:kUnitInventoryDeleteEntryNotification
                               object:store
                               queue:mainQueue
                               usingBlock:^(NSNotification* note){
        NSIndexPath* indexPath = note.userInfo[kUnitInventoryNotificationIndexPathKey];
        
        NSAssert(indexPath != nil,
                 @"we should have an index path in the "
                 @"notifications's user infor dictionary");
    }];
    
    self.docChangeCompleteObserver = [center
                                      addObserverForName:kUnitInventoryChangesCompleteNotification object:store
                                      queue:mainQueue
                                      usingBlock:^(NSNotification* note){
        [_self.theTable endUpdates];
    }];
    
}

@end

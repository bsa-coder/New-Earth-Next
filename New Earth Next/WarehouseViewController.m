//
//  WarehouseViewController.m
//  New Earth
//
//  Created by Scott Alexander on 9/23/17.
//  Copyright © 2017 Big Dog Tools. All rights reserved.
//

#import "WarehouseViewController.h"
#import "UnitInventory.h"
#import "AvailTech.h"
#import "Globals.h"
#import "NewTech.h"
#import "GameViewController.h"

@class UnitInventory;
@class AvailTech;
@class NewEarthGlobals;

@interface WarehouseViewController ()
@property (strong, nonatomic) id docBeganObserver;
@property (strong, nonatomic) id docInsertedObserver;
@property (strong, nonatomic) id docDeletedObserver;
@property (strong, nonatomic) id docChangeCompleteObserver;
@property (strong, nonatomic) id gameEndObserver;

@property (strong, nonatomic) UnitInventory* unitInventory;
@property (strong, nonatomic) AvailTech* availTech;
@property (strong, nonatomic) NewEarthGlobals* theGlobals;

@end

@implementation WarehouseViewController
@synthesize aNewUnit;

// delete this after TESTING!
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    NSLog(@"%@ appeared, warehous %@", [self class], self.availTech);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSLog(@"%@ loaded, warehous %@", [self class], self.availTech);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) dealloc
{
    [self removeNotifications];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    //    NSLog(@"numberofSectionsInTable = %lu",(unsigned long)1);
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_unitInventory count];
}

- (NSString*)tableView:(UITableView*)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"Unit Type";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    NewTech* aUnit = [_unitInventory unitAtIndexPath:indexPath];
    cell.textLabel.text = [NSString stringWithFormat:@"%@", aUnit.myName];
    cell.backgroundColor = aUnit.showMyColor;
//    cell.imageView.image = [UIImage imageNamed:aUnit.itemIcon];
    cell.imageView.image = [UIImage imageNamed:[aUnit getMyIcon]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"section: %ld  row: %ld", (long)indexPath.section, (long)indexPath.row);
    
    UITableViewCell* selectedCell = [[UITableViewCell alloc] init];
    selectedCell = [self tableView: tableView cellForRowAtIndexPath: indexPath];
    NSLog(@"    -----    cell item = %ld", (long)indexPath.item);
    
    NewTech* aUnit2 =  [_unitInventory unitAtIndexPath: indexPath];
    NewTech* aUnit = [[NewTech alloc] initWithUnit: aUnit2];
    
    aUnit.myLoc = aUnit2.myLoc;
    aUnit.myCreateDate = aUnit2.myCreateDate;
    aUnit.myStatus = aUnit2.myStatus;
    aUnit.myPlaced = aUnit2.myPlaced;
    
    if (aUnit.myName == aNewUnit.myName) {
        [self performSegueWithIdentifier:@"toUnitDetailViewController" sender:self];
    }
    aNewUnit = aUnit;
}

#pragma mark - Accessor Methods
/*
-(void) setAvailTech: (AvailTech*) availTech
{
    if (_availTech) { [self removeNotifications]; }
    _availTech = availTech;
    [self setupNotifications];
}
*/
-(void) setUnitInventory:(UnitInventory *) unitInventory
{
    if (_unitInventory) { [self removeNotifications]; }
    _unitInventory = unitInventory;
    [self setupNotifications];
}

-(void) setMyGlobals:(NewEarthGlobals *)theGlobals { _theGlobals = theGlobals; }

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSLog(@"in prepareForSegue");
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if([segue.identifier isEqualToString:@"toUnitDetailViewController"])
    {
        id destController = segue.destinationViewController;
        
        if ([destController respondsToSelector:@selector(setUnitInventory:)]) { [destController setUnitInventory:self.unitInventory]; }
        if ([destController respondsToSelector:@selector(setMyGlobals:)]) { [destController setMyGlobals:self.theGlobals]; }
        
        UnitsDetailViewController* destController2 = segue.destinationViewController;
        
        destController2.aUnit = aNewUnit;
        destController2.theTapLocation = self.theTapLocation;
        
    }
    else if([segue.identifier isEqualToString:@"toMapViewController"])
    {
        UITabBarController* destController = segue.destinationViewController;
//        destController.selectedViewController = [destController.viewControllers objectAtIndex:2];
        destController.selectedViewController = [destController.viewControllers objectAtIndex:0];
    }
}

#pragma mark - Private Methods

- (IBAction)placeTheNewUnit:(id)sender
{
    NSLog(@"++++++++++++++ clicked the PlaceTheNewUnit ++++++++++++++");
    
    if (!aNewUnit.myPlaced) {
        aNewUnit.myLoc = [self theTapLocation];
        aNewUnit.myCreateDate = [NSDate date];
        aNewUnit.myPlaced = YES;
        
        [_unitInventory addUnit:aNewUnit];
        _theGlobals.bankAccountBalance -= aNewUnit.myCost;
        [self performSegueWithIdentifier:@"toMapViewController" sender:self];
    }
}

-(void) handleGameOverNotification: (NSNotification*) paramNotification
{
    NSLog(@"must have received the GameOverNotification (Whous)");
    // need to disable controls that shouldn't work after the game ends
}

#pragma mark - Notification Methods

-(void) removeNotifications
{
    NSNotificationCenter* center = [NSNotificationCenter defaultCenter];
    
    if (self.docBeganObserver) { [center removeObserver:self.docBeganObserver]; self.docBeganObserver = nil; }
    if (self.docInsertedObserver) { [center removeObserver:self.docInsertedObserver]; self.docInsertedObserver = nil; }
    if (self.docDeletedObserver) { [center removeObserver:self.docDeletedObserver]; self.docDeletedObserver = nil; }
    if (self.docChangeCompleteObserver) { [center removeObserver:self.docChangeCompleteObserver]; self.docChangeCompleteObserver = nil; }
    if (self.gameEndObserver) { [center removeObserver:self.gameEndObserver]; self.gameEndObserver = nil; }
}

-(void) setupNotifications
{
    NSNotificationCenter* center = [NSNotificationCenter defaultCenter];
    NSOperationQueue* mainQueue = [NSOperationQueue mainQueue];
    UnitInventory* wHouse = self.unitInventory;
    __weak WarehouseViewController* _self = self;
    
    self.docBeganObserver = [center
                             addObserverForName:kUnitInventoryBeginChangesNotification
                             object:wHouse
                             queue:mainQueue
                             usingBlock:^(NSNotification* note) {
                                 if ([self isViewLoaded]) {
                                     [self.theTable beginUpdates];
                                 }
                             }];
    
    self.docInsertedObserver = [center
                                addObserverForName:kUnitInventoryInsertEntryNotification
                                object:wHouse
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
                               object:wHouse
                               queue:mainQueue
                               usingBlock:^(NSNotification* note){
                                   NSIndexPath* indexPath = note.userInfo[kUnitInventoryNotificationIndexPathKey];
                                   
                                   NSAssert(indexPath != nil,
                                            @"we should have an index path in the "
                                            @"notifications's user infor dictionary");
                               }];
    
    self.docChangeCompleteObserver = [center
                                      addObserverForName:kUnitInventoryChangesCompleteNotification
                                      object:wHouse
                                      queue:mainQueue
                                      usingBlock:^(NSNotification* note){
                                          [_self.theTable endUpdates];
                                      }];
    
    [center
                            addObserver:self
                            selector:@selector(handleGameOverNotification:)
                            name:kCalendarGameOverNotification
                            object:nil];

}


@end



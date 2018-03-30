//
//  UnitsDetailViewController.m
//  New Earth
//
//  Created by Scott Alexander on 4/22/17.
//  Copyright © 2017 Big Dog Tools. All rights reserved.
//

#import "UnitsDetailViewController.h"

#import "UnitInventory.h"
#import "Globals.h"

@class UnitInventory;

@interface UnitsDetailViewController ()

@property (strong, nonatomic) UnitInventory* unitInventory;
@property (strong, nonatomic) NewEarthGlobals* theGlobals;

@end

@implementation UnitsDetailViewController
//@synthesize aUnit, label01, label02, label03, label04, label05;

@synthesize resource01, label01a, label01b, label01c, label01d;
@synthesize resource02, label02a, label02b, label02c, label02d;
@synthesize resource03, label03a, label03b, label03c, label03d;
@synthesize resource04, label04a, label04b, label04c, label04d;
@synthesize resource05, label05a, label05b, label05c, label05d;
@synthesize resource06, label06a, label06b, label06c, label06d;
@synthesize resource07, label07a, label07b, label07c, label07d;
@synthesize resource08, label08a, label08b, label08c, label08d;
@synthesize resource09, label09a, label09b, label09c, label09d;
@synthesize resource10, label10a, label10b, label10c, label10d;

//@synthesize aNewUnit;
@synthesize labelUnitSize, labelUnitEnvelope, labelUnitTypeClass, labelUnitCost, imageUnitIcon, textUnitName, textUnitName2;
@synthesize labelRateProd, labelRateTake, labelRateMake, resourceInput, resourceStack;
//@synthesize labelRateProd, labelRateTake, labelRateMake;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIView* myView = [self view];
    
    __unused CGRect stackRect = CGRectMake(8,
                                  (myView.frame.size.width < myView.frame.size.height ? myView.frame.size.height - myView.frame.size.width : 10),
                                  (myView.frame.size.width < myView.frame.size.height ? myView.frame.size.width : myView.frame.size.height), (myView.frame.size.width < myView.frame.size.height ? myView.frame.size.width : myView.frame.size.height));
    
//    if (!resourceStack) {
//        resourceStack = [[UIStackView alloc] initWithFrame:stackRect];
        
//        [myView addSubview:resourceStack];

//        [myView addSubview:resourceStack];
        
        //    resource01 = [[UIView alloc] init];
    resource01 = [[DetailResourceView2 alloc] initWithUnit:_aUnit forResource:laborStock];
    resource02 = [[DetailResourceView2 alloc] initWithUnit:_aUnit forResource:foodStock];
    resource03 = [[DetailResourceView2 alloc] initWithUnit:_aUnit forResource:waterStock];
    resource04 = [[DetailResourceView2 alloc] initWithUnit:_aUnit forResource:airStock];
    resource05 = [[DetailResourceView2 alloc] initWithUnit:_aUnit forResource:powerStock];
    resource06 = [[DetailResourceView2 alloc] initWithUnit:_aUnit forResource:materialStock];
    resource07 = [[DetailResourceView2 alloc] initWithUnit:_aUnit forResource:supplyStock];
    resource08 = [[DetailResourceView2 alloc] initWithUnit:_aUnit forResource:componentStock];
    resource09 = [[DetailResourceView2 alloc] initWithUnit:_aUnit forResource:structureStock];
        //    resource10 = [[DetailResourceView alloc] initForResource:happinessStock WithUnit:_aUnit];
        
        [resourceStack addArrangedSubview:resource01];
        [resourceStack addArrangedSubview:resource02];
        [resourceStack addArrangedSubview:resource03];
        [resourceStack addArrangedSubview:resource04];
        [resourceStack addArrangedSubview:resource05];
        [resourceStack addArrangedSubview:resource06];
        [resourceStack addArrangedSubview:resource07];
        [resourceStack addArrangedSubview:resource08];
        [resourceStack addArrangedSubview:resource09];
        
//    }
    
    CGFloat minDim = ((myView.frame.size.width < myView.frame.size.height) ? myView.frame.size.width : myView.frame.size.height) - 20;
    
    CGFloat horVert = ((myView.frame.size.width < myView.frame.size.height) ? 10 : myView.frame.size.width - minDim);
    CGFloat verVert = ((myView.frame.size.width < myView.frame.size.height) ? myView.frame.size.height - minDim : 10);
    NSLog(@"hor %f : ver %f : min %f", horVert, verVert, minDim);
    
    __unused CGPoint myOrigin = CGPointMake(horVert, verVert);
    CGRect myRect = CGRectMake( horVert, verVert, (minDim - 20.0), (minDim - 20.0));
    
    self.resourceStack.frame = myRect; //fixedFrame;
    
    resourceInput = [[DetailResourceView alloc] initForResource:laborStock WithUnit:_aUnit];
//    label01a.text = resourceInput.ResourceName;

    __unused CGRect tempRect = label01a.frame;
    
//    label01b.text = resourceInput.ResourceRateMake;
//    label01b.frame = resourceInput.produceRect;
//    label01c.text = resourceInput.ResourceRateTake;
//    label01c.frame = resourceInput.buildRect;
//    label01d.text = resourceInput.ResourceRateBake;
//    label01d.frame = resourceInput.repairRect;
    
    resourceInput = [[DetailResourceView alloc] initForResource:foodStock WithUnit:_aUnit];
    label02a.text = resourceInput.ResourceName;
    label02b.text = resourceInput.ResourceRateMake;
    label02c.text = resourceInput.ResourceRateTake;
    label02d.text = resourceInput.ResourceRateBake;
    
//    label01b.frame = resourceInput.produceRect;
    
    resourceInput = [[DetailResourceView alloc] initForResource:waterStock WithUnit:_aUnit];
    label03a.text = resourceInput.ResourceName;
    label03b.text = resourceInput.ResourceRateMake;
    label03c.text = resourceInput.ResourceRateTake;
    label03d.text = resourceInput.ResourceRateBake;
    
    resourceInput = [[DetailResourceView alloc] initForResource:airStock WithUnit:_aUnit];
    label04a.text = resourceInput.ResourceName;
    label04b.text = resourceInput.ResourceRateMake;
    label04c.text = resourceInput.ResourceRateTake;
    label04d.text = resourceInput.ResourceRateBake;
    
    resourceInput = [[DetailResourceView alloc] initForResource:laborStock WithUnit:_aUnit];
    label05a.text = resourceInput.ResourceName;
    label05b.text = resourceInput.ResourceRateMake;
    label05c.text = resourceInput.ResourceRateTake;
    label05d.text = resourceInput.ResourceRateBake;
    
    resourceInput = [[DetailResourceView alloc] initForResource:materialStock WithUnit:_aUnit];
    label06a.text = resourceInput.ResourceName;
    label06b.text = resourceInput.ResourceRateMake;
    label06c.text = resourceInput.ResourceRateTake;
    label06d.text = resourceInput.ResourceRateBake;
    
    resourceInput = [[DetailResourceView alloc] initForResource:supplyStock WithUnit:_aUnit];
    label07a.text = resourceInput.ResourceName;
    label07b.text = resourceInput.ResourceRateMake;
    label07c.text = resourceInput.ResourceRateTake;
    label07d.text = resourceInput.ResourceRateBake;
    
    resourceInput = [[DetailResourceView alloc] initForResource:componentStock WithUnit:_aUnit];
    label08a.text = resourceInput.ResourceName;
    label08b.text = resourceInput.ResourceRateMake;
    label08c.text = resourceInput.ResourceRateTake;
    label08d.text = resourceInput.ResourceRateBake;
    
    resourceInput = [[DetailResourceView alloc] initForResource:structureStock WithUnit:_aUnit];
    label09a.text = resourceInput.ResourceName;
    label09b.text = resourceInput.ResourceRateMake;
    label09c.text = resourceInput.ResourceRateTake;
    label09d.text = resourceInput.ResourceRateBake;
    
//    resource10 = [[DetailResourceView alloc] initForResource:happinessStock WithUnit:_aUnit];
//    label10a.text = resource10.ResourceName;
//    label10b.text = resource10.ResourceRateMake;
//    label10c.text = resource10.ResourceRateTake;
//    label10d.text = resource10.ResourceRateBake;
 
    labelRateProd.text = [NSString stringWithFormat: @"%2.2f", (float)_aUnit.myProduceRate];
    labelRateTake.text = [NSString stringWithFormat: @"%2.2f", (float)_aUnit.myRepairRate];
    labelRateMake.text = [NSString stringWithFormat: @"%2.2f", (float)_aUnit.myBuildRate];
    
    labelUnitSize.text = [NSString stringWithFormat: @"%ld x %ld m", (long)_aUnit.mySize.height, (long)_aUnit.mySize.width];
    labelUnitEnvelope.text = [NSString stringWithFormat: @"%ld m", (long)_aUnit.myEnvelope];
    labelUnitTypeClass.text = [NSString stringWithFormat: @"%u::%ld", _aUnit.myType, (long)_aUnit.myClass];
    labelUnitCost.text = [NSString stringWithFormat: @"%2.0f",_aUnit.myCost];
    imageUnitIcon.image = [UIImage imageNamed:_aUnit.itemIcon];
    textUnitName.text = [NSString stringWithFormat: @"%@-%0.0f-%0.0f", _aUnit.myName, _theTapLocation.x, _theTapLocation.y];
    textUnitName2.text = [NSString stringWithFormat: @"%@-%0.0f-%0.0f", _aUnit.myName, _theTapLocation.x, _theTapLocation.y];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if([segue.identifier isEqualToString:@"toMapViewController2"])
    {
        UITabBarController* destController = segue.destinationViewController;
        destController.selectedViewController = [destController.viewControllers objectAtIndex:0];
//        destController.selectedViewController = [destController.viewControllers objectAtIndex:1];
//        destController.selectedViewController = [destController.viewControllers objectAtIndex:2];
    }
}


#pragma mark - Accessor Methods

-(void) setUnitInventory:(UnitInventory *) unitInventory { _unitInventory = unitInventory; }
-(void) setMyGlobals:(NewEarthGlobals *)theGlobals { _theGlobals = theGlobals; }

#pragma mark - private methods

-(void) portraitLayout
{
    // orientation of controls when in portrait mode
}

-(void) landscapeLayout
{
    // orientation of controls when in landscape mode
}

- (IBAction)placeTheNewUnit:(id)sender
{
    NSLog(@"++++++++++++++ clicked the PlaceTheNewUnit ++++++++++++++");
    
    if (!_aUnit.myPlaced) {
        _aUnit.myLoc = [self theTapLocation];
        _aUnit.myLoc = self.theTapLocation;
        _aUnit.myCreateDate = [NSDate date];
        _aUnit.myName = textUnitName.text;
        _aUnit.myPlaced = YES;
        
        [_unitInventory addUnit:_aUnit];
        _theGlobals.bankAccountBalance -= _aUnit.myCost;
        [self performSegueWithIdentifier:@"toMapViewController2" sender:self];
        
        [_aUnit printMe];
    } 
}

@end

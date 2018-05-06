//
//  StatusViewController.m
//  New Earth
//
//  Created by Scott Alexander on 6/15/17.
//  Copyright © 2017 Big Dog Tools. All rights reserved.
//
//  Controls display of the sustainability score and components

#import "StatusViewController.h"
#import "AppDelegate.h"

int const kHorizNarrow = 0;
int const kHorizWide = 1;
int const kVertical = 2;

@class UnitInventory;
@class NewEarthGlobals;

@interface StatusViewController ()
@property (strong, nonatomic) UnitInventory* unitInventory;
@property (strong, nonatomic) NewEarthGlobals* globals;

@end

@implementation StatusViewController

//@synthesize myGlobals;
//@synthesize myWarehouse, myGlobals, myStatusBar;
@synthesize theScrollView, myView;
@synthesize aStatusBarItem01, aStatusBarItem02, aStatusBarItem03, aStatusBarItem04, aStatusBarItem05, aStatusBarItem06;
@synthesize aStatusBarItem07, aStatusBarItem08, aStatusBarItem09, aStatusBarItem10, aStatusBarItem11, aStatusBarItem12;
@synthesize aStatusBar01, aStatusBar02, aStatusBar03, aStatusBar04, aStatusBar05, aStatusBar06;
@synthesize aStatusBar07, aStatusBar08, aStatusBar09, aStatusBar10, aStatusBar11, aStatusBar12, myStatusRoom, myStatusBar, gameProgress, gameBalance, gameProgressAmount;
@synthesize barHeight, barWidth, margin, minMargin, minBarHeight, layout, screenUpdateTimer;

-(IBAction) quitApp: (id) sender
{
    NSLog(@"Pressed the quitApp button");
}

-(CGPoint) statusBarLoc:(AppStatusView*) requestor {return CGPointMake(0, 0);}
-(UIColor*) statusMyColor:(AppStatusView*) requestor {return [UIColor cyanColor];}
-(UIScrollView*) statBarScrollView:(AppStatusView*) requestor {return theScrollView;}

-(CGFloat) statItemProduce: (AppStatusBarView*) requestor { return 75.0;}
-(CGFloat) statItemConsume: (AppStatusBarView*) requestor { return 50.0;}
-(CGFloat) statItemNewProd: (AppStatusBarView*) requestor { return 10.0;}
-(CGPoint) statItemBarLoc: (AppStatusBarView*) requestor { return CGPointMake(10, 10);}
-(UIColor*) statItemMyColor:(AppStatusBarView*) requestor { return [UIColor blueColor];}
-(UIScrollView*) statItemScrollView:(AppStatusBarView*) requestor { return theScrollView;}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    // delete this after TESTING!
    NSLog(@"%@ appeared", [self class]);
    
    if(!myStatusRoom) myStatusRoom = [[StatusRoom alloc] init];
    
    if(!myStatusBar) {
        myStatusBar = [[AppStatusView alloc] init];
        myStatusBar.myAppStatusDel = self;
        myStatusBar.backgroundColor = [UIColor redColor];
    }
    
    if (!theScrollView) { theScrollView = [[UIScrollView alloc] init]; }

    CGPoint myOrigin = CGPointMake(0.0, 20.0);
    CGRect myRect;
    
    if ([[self view] window].frame.size.height > [[self view] window].frame.size.width) {
        myRect = CGRectMake( myOrigin.x, myOrigin.y, 170.0, [[self view] window].frame.size.height-50.0 - 20.0);
        layout = 0;
    } else {
        myRect = CGRectMake( myOrigin.x, myOrigin.y, 320.0, [[self view] window].frame.size.height-50.0 - 20.0);
        layout = 1;
    }
    
    // Place the status bar
    
    const CGFloat* aColorComp;
    CGColorRef aColor = (__bridge CGColorRef)([UIColor yellowColor]);
    aColorComp = CGColorGetComponents(aColor);
    UIColor* myColorBkgd = [UIColor colorWithRed:aColorComp[1] green:aColorComp[1] blue:aColorComp[2] alpha:0.75];
    
    self.myStatusBar.backgroundColor = myColorBkgd;
    
    self.myStatusBar.frame = myRect; //fixedFrame;
    [self.myStatusBar setFrame:myRect];
    myRect = self.myStatusBar.frame;
    
    [self.myStatusRoom addSubview:myStatusBar]; // added status bar to status room tab
        
    [self makeControlRoomBars];
    
//    [self updateUI];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // assign delegates
//    AppDelegate* myAppDel = (AppDelegate*) [UIApplication sharedApplication].delegate;
//    myWarehouse = myAppDel.theWarehouse;
//    myGlobals = myAppDel.theGlobals;
    if(!theScrollView) theScrollView = [[UIScrollView alloc] init];
    
    
    // initialize variables
    minBarHeight = 40.0f;
    minMargin = 1.0f;
    
    CGPoint myOrigin = CGPointMake(10.0, 0);
    CGRect myRect = CGRectMake( myOrigin.x, myOrigin.y, 170.0, [[self view] window].frame.size.height - 50);
    
    self.myStatusBar.frame = myRect; //fixedFrame;
    [self.myStatusBar setFrame:myRect];
    
    if(!gameProgress) gameProgress = [[UIProgressView alloc] init];
    gameProgress.progress = (float) _globals.dayOfContract / _globals.lengthOfContract;

//    [self startScreenUpdateTimer];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleUpdateNotification:)
                                                 name:kSetUpdateNotification
                                               object:nil];

}

-(void) handleUpdateNotification:(NSNotification*) paramNotification
{
    NSLog(@"got update message");
    [self updateUI];
}

-(void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    if ([[self view] window].frame.size.height > [[self view] window].frame.size.width) {
//        self.myStatusBar.frame = CGRectMake( myOrigin.x, myOrigin.y, 170.0, [[self view] window].frame.size.height-50.0 - 20.0);
        layout = 0;
    } else {
//        self.myStatusBar.frame = CGRectMake( myOrigin.x, myOrigin.y, 320.0, [[self view] window].frame.size.height-50.0 - 20.0);
        layout = 1;
    }
    
    switch (layout) {
        case kHorizNarrow:
            self.myStatusBar.myPosition = self.myStatusBar.frame.origin; // CGPointMake(10, 0);
            self.myStatusBar.myRect = CGRectMake(self.myStatusBar.myPosition.x, self.myStatusBar.myPosition.y, 170, [[self view] window].frame.size.height - 50 - 20);
            self.myStatusBar.frame = self.myStatusBar.myRect;
            
            break;
            
        case kHorizWide:
            self.myStatusBar.myPosition = self.myStatusBar.frame.origin; // CGPointMake(10, 0);
            self.myStatusBar.myRect = CGRectMake(self.myStatusBar.myPosition.x, self.myStatusBar.myPosition.y, 320, [[self view] window].frame.size.height - 50 - 20);
            self.myStatusBar.frame = self.myStatusBar.myRect;
            
            break;
            
        case kVertical:
            self.myStatusBar.myPosition = CGPointMake(10, [[self view] window].frame.size.height - 50);
            self.myStatusBar.myRect = CGRectMake(self.myStatusBar.myPosition.x, self.myStatusBar.myPosition.y, [[self view] window].frame.size.width - 20, 50);
            self.myStatusBar.frame = self.myStatusBar.myRect;
            
            break;
            
        default:
            break;
    }
    
//    [self calcStatusBarSizeForLayout:layout];
    
    aStatusBar01.layout = layout;
    aStatusBar02.layout = layout;
    aStatusBar03.layout = layout;
    aStatusBar04.layout = layout;
    aStatusBar05.layout = layout;
    aStatusBar07.layout = layout;
    aStatusBar08.layout = layout;
    aStatusBar09.layout = layout;
    aStatusBar10.layout = layout;
    
    [self makeControlRoomBars];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) setUnitInventory:(UnitInventory *)unitInventory { _unitInventory = unitInventory; }
-(void) setTheGlobals:(NewEarthGlobals *)globals { _globals = globals; }

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(AppStatusBarView*) makeStatusBar: (AppStatusItem*) statusItem
                            inRect: (CGRect) aRect
                         stockType: (stockType) statusType
                        stockColor: (UIColor*) aBarColor
                             named: (NSString*) aLegend
                            layout: (int) orientation
{
    if (!statusItem) { statusItem = [[AppStatusItem alloc] initOfType: statusType
                                                      WithViewControl: [self unitInventory]];
    }
    
    AppStatusBarView* aBar = [[AppStatusBarView alloc] initAtPosition: aRect.origin
                                                             withSize: aRect
                                                             withType: aBarColor
                                                           withLegend: aLegend
                                                           layoutType: orientation];
    
    aBar.myAppStatBarItemDel = statusItem;
    aBar.myScrollDel = self;
    
//    aBar.myAppStatBarItemVCDel = self;
    
    return aBar;
}

// routine to place vertical oriented status bars
-(void) makeControlRoomBars
{
    
    switch (layout) {
        case kHorizNarrow:
            self.myStatusBar.myPosition = self.myStatusBar.frame.origin; // CGPointMake(10, 0);
            self.myStatusBar.myRect = CGRectMake(self.myStatusBar.myPosition.x, self.myStatusBar.myPosition.y, 170, [[self view] window].frame.size.height - 50 - 20);
            self.myStatusBar.frame = self.myStatusBar.myRect;
            
            break;
            
        case kHorizWide:
            self.myStatusBar.myPosition = self.myStatusBar.frame.origin; // CGPointMake(10, 0);
            self.myStatusBar.myRect = CGRectMake(self.myStatusBar.myPosition.x, self.myStatusBar.myPosition.y, 320, [[self view] window].frame.size.height - 50 - 20);
            self.myStatusBar.frame = self.myStatusBar.myRect;

            break;
            
        case kVertical:
            self.myStatusBar.myPosition = CGPointMake(10, [[self view] window].frame.size.height - 50);
            self.myStatusBar.myRect = CGRectMake(self.myStatusBar.myPosition.x, self.myStatusBar.myPosition.y, [[self view] window].frame.size.width - 20, 50);
            self.myStatusBar.frame = self.myStatusBar.myRect;
            
            break;
            
        default:
            break;
    }
    
    [self calcStatusBarSizeForLayout:layout];
    [self placeBarsForLayout:layout];

    for (int i = 0; i < self.myStatusBar.subviews.count; i++) {
        [self.myStatusBar.subviews[i] setNeedsDisplay];
    }
}


// routine to place vertical oriented status bars
-(void) placeVerticalBars
{
    CGFloat barMargin = 2;
    CGFloat nextBarStart = 0.0;
    
    barHeight = 40.0;
    barWidth = 37.0;
    CGFloat colTop = barMargin;
    
    // create the status progress bar items
    nextBarStart += barMargin + 1;
    AppStatusBarView* aBar = [self makeStatusBar: aStatusBarItem01 inRect: CGRectMake(nextBarStart, colTop, barWidth, barHeight) stockType: laborStock stockColor: [self getResourceColor:laborStock] named: @"Labor" layout: 2];
    aBar.myAppStatBarItemDel = aStatusBarItem01;
 //   aBar.myAppStatBarItemVCDel = self;
    [self.myStatusBar addSubview:aBar];
    
    nextBarStart += barMargin + barWidth;
    aBar = [self makeStatusBar: aStatusBarItem02 inRect: CGRectMake(nextBarStart, colTop, barWidth, barHeight) stockType: foodStock stockColor: [self getResourceColor:foodStock] named: @"Food" layout: 2];
    aBar.myAppStatBarItemDel = aStatusBarItem02;
 //   aBar.myAppStatBarItemVCDel = self;
    [self.myStatusBar addSubview:aBar];
    
    nextBarStart += barMargin + barWidth;
    aBar = [self makeStatusBar: aStatusBarItem03 inRect: CGRectMake(nextBarStart, colTop, barWidth, barHeight) stockType: waterStock stockColor: [self getResourceColor:waterStock] named: @"Water" layout: 2];
    aBar.myAppStatBarItemDel = aStatusBarItem03;
 //   aBar.myAppStatBarItemVCDel = self;
    [self.myStatusBar addSubview:aBar];
    
    nextBarStart += barMargin + barWidth;
    aBar = [self makeStatusBar: aStatusBarItem04 inRect: CGRectMake(nextBarStart, colTop, barWidth, barHeight) stockType: powerStock stockColor: [self getResourceColor:powerStock] named: @"Power" layout: 2];
    aBar.myAppStatBarItemDel = aStatusBarItem04;
 //   aBar.myAppStatBarItemVCDel = self;
    [self.myStatusBar addSubview:aBar];
    
    nextBarStart += barMargin + barWidth;
    aBar = [self makeStatusBar: aStatusBarItem05 inRect: CGRectMake(nextBarStart, colTop, barWidth, barHeight) stockType: airStock stockColor: [self getResourceColor:airStock] named: @"Air" layout: 2];
    aBar.myAppStatBarItemDel = aStatusBarItem05;
//    aBar.myAppStatBarItemVCDel = self;
    [self.myStatusBar addSubview:aBar];
    
    nextBarStart += barMargin + barWidth;
    nextBarStart += barMargin + barWidth;
    aBar = [self makeStatusBar: aStatusBarItem07 inRect: CGRectMake(nextBarStart, colTop, barWidth, barHeight) stockType: supplyStock stockColor: [self getResourceColor:supplyStock] named: @"Supply" layout: 2];
    aBar.myAppStatBarItemDel = aStatusBarItem07;
//    aBar.myAppStatBarItemVCDel = self;
    [self.myStatusBar addSubview:aBar];
    
    nextBarStart += barMargin + barWidth;
    aBar = [self makeStatusBar: aStatusBarItem08 inRect: CGRectMake(nextBarStart, colTop, barWidth, barHeight) stockType: materialStock stockColor: [self getResourceColor:materialStock] named: @"Matl" layout: 2];
    aBar.myAppStatBarItemDel = aStatusBarItem08;
//    aBar.myAppStatBarItemVCDel = self;
    [self.myStatusBar addSubview:aBar];
    
    nextBarStart += barMargin + barWidth;
    aBar = [self makeStatusBar: aStatusBarItem09 inRect: CGRectMake(nextBarStart, colTop, barWidth, barHeight) stockType: componentStock stockColor: [self getResourceColor:componentStock] named: @"Comp" layout: 2];
    aBar.myAppStatBarItemDel = aStatusBarItem09;
//    aBar.myAppStatBarItemVCDel = self;
    [self.myStatusBar addSubview:aBar];
    
    nextBarStart += barMargin + barWidth;
    aBar = [self makeStatusBar: aStatusBarItem10 inRect: CGRectMake(nextBarStart, colTop, barWidth, barHeight) stockType: structureStock stockColor: [self getResourceColor:structureStock] named: @"Struc" layout: 2];
    aBar.myAppStatBarItemDel = aStatusBarItem10;
//    aBar.myAppStatBarItemVCDel = self;
    [self.myStatusBar addSubview: aBar];
    
}

-(UIColor*) getResourceColor: (stockType) aResource
{
    UIColor* retVal;
    
    // create the status progress bar items
    switch (aResource) {
        case laborStock: retVal = [UIColor orangeColor]; break;
        case foodStock: retVal = [UIColor greenColor]; break;
        case waterStock: retVal = [UIColor blueColor]; break;
        case powerStock: retVal = [UIColor yellowColor]; break;
        case airStock: retVal = [UIColor cyanColor]; break;
        case supplyStock: retVal = [UIColor brownColor]; break;
        case materialStock: retVal = [UIColor magentaColor]; break;
        case componentStock: retVal = [UIColor grayColor]; break;
        case structureStock: retVal = [UIColor purpleColor]; break;
            
        default: break;
    }
    return retVal;
}



// routine to place status bars oriented per theLayout
-(void) placeBarsForLayout: (int) theLayout
{
    CGFloat colLeftStart = 10.0f;
    CGFloat nextBarStart = 0.0;
    CGFloat marginVert = 0.0;
    CGFloat marginHoriz = 0.0;
    CGFloat horOffset = 0.0f;
    CGFloat verOffset = 0.0f;
    
    switch (theLayout) {
        case 0: // vert alignment narrow bars
            barWidth = 150.0f;
            marginVert = margin;
            marginHoriz = 0.0f;
            horOffset = 0.0f;
            verOffset = 1.0f;
            break;
            
        case 1: // vert alignment wide bars
            barWidth = 300.0f;
            marginVert = margin;
            marginHoriz = 0.0f;
            horOffset = 0.0f;
            verOffset = 1.0f;
            break;
            
        case 2: // horiz alignment
            barWidth = 150.0f;
            marginVert = 0.0f;
            marginHoriz = margin;
            horOffset = 1.0f;
            verOffset = 0.0f;
            break;
            
        default:
            break;
    }

    // create the status progress bar items
    // LEFT SIDE
    CGRect itemRect02;
    
    nextBarStart += marginHoriz + marginVert;
    if (!aStatusBar01) {
        itemRect02 = CGRectMake(colLeftStart, nextBarStart, barWidth, barHeight);
        aStatusBarItem01 = [[AppStatusItem alloc] initOfType:laborStock WithViewControl:[self unitInventory]]; //appstatusitem
        aStatusBar01 = [[AppStatusBarView alloc] initAtPosition: CGPointMake(colLeftStart, nextBarStart) withSize: itemRect02 withType: [UIColor orangeColor] withLegend:@"Labor" layoutType: theLayout];
        aStatusBar01.myAppStatBarItemDel = aStatusBarItem01;
        aStatusBar01.myScrollDel = self;
        [self.myStatusBar addSubview:aStatusBar01];
    } else {
        itemRect02 = CGRectMake(colLeftStart, nextBarStart, barWidth, barHeight);
        aStatusBar01.frame = itemRect02;
        aStatusBar01.layout = theLayout;
        
        [self.aStatusBar01 setNeedsDisplay];
    }
    
    nextBarStart += marginHoriz + marginVert + barHeight*verOffset + barWidth*horOffset;
    if (!aStatusBar02) {
        itemRect02 = CGRectMake(colLeftStart, nextBarStart, barWidth, barHeight);
        aStatusBarItem02 = [[AppStatusItem alloc] initOfType:foodStock WithViewControl:[self unitInventory]];
        aStatusBar02 = [[AppStatusBarView alloc] initAtPosition:CGPointMake(colLeftStart, nextBarStart) withSize: itemRect02 withType: [UIColor greenColor] withLegend:@"Food" layoutType: theLayout];
        aStatusBar02.myAppStatBarItemDel = aStatusBarItem02;
        aStatusBar02.myScrollDel = self;
        [self.myStatusBar addSubview:aStatusBar02];
    } else {
        itemRect02 = CGRectMake(colLeftStart, nextBarStart, barWidth, barHeight);
        aStatusBar02.frame = itemRect02;
        aStatusBar02.layout = theLayout;
        [self.aStatusBar02 setNeedsDisplay];
    }
    
    nextBarStart += marginHoriz + marginVert + barHeight*verOffset + barWidth*horOffset;
    if (!aStatusBar03) {
        itemRect02 = CGRectMake(colLeftStart, nextBarStart, barWidth, barHeight);
        aStatusBarItem03 = [[AppStatusItem alloc] initOfType:waterStock WithViewControl:[self unitInventory]];
        aStatusBar03 = [[AppStatusBarView alloc] initAtPosition:CGPointMake(colLeftStart, nextBarStart) withSize: itemRect02 withType: [UIColor blueColor] withLegend:@"water" layoutType: theLayout];
        aStatusBar03.myAppStatBarItemDel = aStatusBarItem03;
        aStatusBar03.myScrollDel = self;
        [self.myStatusBar addSubview:aStatusBar03];
    } else {
        itemRect02 = CGRectMake(colLeftStart, nextBarStart, barWidth, barHeight);
        aStatusBar03.frame = itemRect02;
        aStatusBar03.layout = theLayout;
        [self.aStatusBar03 setNeedsDisplay];
    }
    
    nextBarStart += marginHoriz + marginVert + barHeight*verOffset + barWidth*horOffset;
    if (!aStatusBar04) {
        itemRect02 = CGRectMake(colLeftStart, nextBarStart, barWidth, barHeight);
        aStatusBarItem04 = [[AppStatusItem alloc] initOfType:powerStock WithViewControl:[self unitInventory]];
        aStatusBar04 = [[AppStatusBarView alloc] initAtPosition:CGPointMake(colLeftStart, nextBarStart) withSize: itemRect02 withType: [UIColor yellowColor] withLegend:@"Power" layoutType: theLayout];
        aStatusBar04.myAppStatBarItemDel = aStatusBarItem04;
        aStatusBar04.myScrollDel = self;
        [self.myStatusBar addSubview:aStatusBar04];
    } else {
        itemRect02 = CGRectMake(colLeftStart, nextBarStart, barWidth, barHeight);
        aStatusBar04.frame = itemRect02;
        aStatusBar04.layout = theLayout;
        [self.aStatusBar04 setNeedsDisplay];
    }
    
    nextBarStart += marginHoriz + marginVert + barHeight*verOffset + barWidth*horOffset;
    if (!aStatusBar05) {
        itemRect02 = CGRectMake(colLeftStart, nextBarStart, barWidth, barHeight);
        aStatusBarItem05 = [[AppStatusItem alloc] initOfType:airStock WithViewControl:[self unitInventory]];
        aStatusBar05 = [[AppStatusBarView alloc] initAtPosition:CGPointMake(colLeftStart, nextBarStart) withSize: itemRect02 withType: [UIColor lightGrayColor] withLegend:@"Air" layoutType: theLayout];
        aStatusBar05.myAppStatBarItemDel = aStatusBarItem05;
        aStatusBar05.myScrollDel = self;
        [self.myStatusBar addSubview:aStatusBar05];
    } else {
        itemRect02 = CGRectMake(colLeftStart, nextBarStart, barWidth, barHeight);
        aStatusBar05.frame = itemRect02;
        aStatusBar05.layout = theLayout;
        [self.aStatusBar05 setNeedsDisplay];
    }
    
    // RIGHT SIDE
    //    nextBarStart = 0.0;
    nextBarStart += marginHoriz + marginVert + barHeight*verOffset + barWidth*horOffset;
    nextBarStart += marginHoriz + marginVert + barHeight*verOffset + barWidth*horOffset;
    if (!aStatusBar07) {
        itemRect02 = CGRectMake(colLeftStart, nextBarStart, barWidth, barHeight);
        aStatusBarItem07 = [[AppStatusItem alloc] initOfType:supplyStock WithViewControl:[self unitInventory]];
        aStatusBar07 = [[AppStatusBarView alloc] initAtPosition:CGPointMake(colLeftStart, nextBarStart) withSize: itemRect02 withType: [UIColor brownColor] withLegend:@"Suppl" layoutType: theLayout];
        aStatusBar07.myAppStatBarItemDel = aStatusBarItem07;
        aStatusBar07.myScrollDel = self;
        [self.myStatusBar addSubview:aStatusBar07];
    } else {
        itemRect02 = CGRectMake(colLeftStart, nextBarStart, barWidth, barHeight);
        aStatusBar07.frame = itemRect02;
        aStatusBar07.layout = theLayout;
        [self.aStatusBar07 setNeedsDisplay];
    }
    
    nextBarStart += marginHoriz + marginVert + barHeight*verOffset + barWidth*horOffset;
    if (!aStatusBar08) {
        itemRect02 = CGRectMake(colLeftStart, nextBarStart, barWidth, barHeight);
        aStatusBarItem08 = [[AppStatusItem alloc] initOfType:materialStock WithViewControl:[self unitInventory]];
        aStatusBar08 = [[AppStatusBarView alloc] initAtPosition:CGPointMake(colLeftStart, nextBarStart) withSize: itemRect02 withType: [UIColor grayColor] withLegend:@"Matl" layoutType: theLayout];
        aStatusBar08.myAppStatBarItemDel = aStatusBarItem08;
        aStatusBar08.myScrollDel = self;
        [self.myStatusBar addSubview:aStatusBar08];
    } else {
        itemRect02 = CGRectMake(colLeftStart, nextBarStart, barWidth, barHeight);
        aStatusBar08.frame = itemRect02;
        aStatusBar08.layout = theLayout;
        [self.aStatusBar08 setNeedsDisplay];
    }
    
    nextBarStart += marginHoriz + marginVert + barHeight*verOffset + barWidth*horOffset;
    if (!aStatusBar09) {
        itemRect02 = CGRectMake(colLeftStart, nextBarStart, barWidth, barHeight);
        aStatusBarItem09 = [[AppStatusItem alloc] initOfType:componentStock WithViewControl:[self unitInventory]];
        aStatusBar09 = [[AppStatusBarView alloc] initAtPosition:CGPointMake(colLeftStart, nextBarStart) withSize: itemRect02 withType: [UIColor magentaColor] withLegend:@"Comp" layoutType: theLayout];
        aStatusBar09.myAppStatBarItemDel = aStatusBarItem09;
        aStatusBar09.myScrollDel = self;
        [self.myStatusBar addSubview:aStatusBar09];
    } else {
        itemRect02 = CGRectMake(colLeftStart, nextBarStart, barWidth, barHeight);
        aStatusBar09.frame = itemRect02;
        aStatusBar09.layout = theLayout;
        [self.aStatusBar09 setNeedsDisplay];
    }
    
    nextBarStart += marginHoriz + marginVert + barHeight*verOffset + barWidth*horOffset;
    if (!aStatusBar10) {
        itemRect02 = CGRectMake(colLeftStart, nextBarStart, barWidth, barHeight);
        aStatusBarItem10 = [[AppStatusItem alloc] initOfType:structureStock WithViewControl:[self unitInventory]];
        aStatusBar10 = [[AppStatusBarView alloc] initAtPosition:CGPointMake(colLeftStart, nextBarStart) withSize: itemRect02 withType: [UIColor cyanColor] withLegend:@"Struct" layoutType: theLayout];
        aStatusBar10.myAppStatBarItemDel = aStatusBarItem10;
        aStatusBar10.myScrollDel = self;
        [self.myStatusBar addSubview:aStatusBar10];
    } else {
        itemRect02 = CGRectMake(colLeftStart, nextBarStart, barWidth, barHeight);
        aStatusBar10.frame = itemRect02;
        aStatusBar10.layout = theLayout;
        [self.aStatusBar10 setNeedsDisplay];
    }
    
    [self updateUI];
    
}

-(void) placeHorizontalBarsForLayout: (int) theLayout
{
    CGFloat colLeftStart = 10.0f;
    CGFloat nextBarStart = 0.0;
    CGFloat marginVert = 0.0;
    CGFloat marginHoriz = 0.0;
    CGFloat horOffset = 0.0f;
    CGFloat verOffset = 0.0f;
    
    switch (theLayout) {
        case 0: // vert alignment narrow bars
            barWidth = 150.0f;
            marginVert = margin;
            marginHoriz = 0.0f;
            horOffset = 0.0f;
            verOffset = 1.0f;
            break;
            
        case 1: // vert alignment wide bars
            barWidth = 300.0f;
            marginVert = margin;
            marginHoriz = 0.0f;
            horOffset = 0.0f;
            verOffset = 1.0f;
            break;
            
        case 2: // horiz alignment
            barWidth = 150.0f;
            marginVert = 0.0f;
            marginHoriz = margin;
            horOffset = 1.0f;
            verOffset = 0.0f;
            break;
            
        default:
            break;
    }
    if (layout == 0) {
        barWidth = 150.0f;
    }
    else {
        barWidth = 300.0f;
    }
    // create the status progress bar items
    // LEFT SIDE
    CGRect itemRect02;
    
    nextBarStart += marginHoriz + marginVert;
    if (!aStatusBar01) {
        itemRect02 = CGRectMake(colLeftStart, nextBarStart, barWidth, barHeight);
        aStatusBarItem01 = [[AppStatusItem alloc] initOfType:laborStock WithViewControl:[self unitInventory]]; //appstatusitem
        aStatusBar01 = [[AppStatusBarView alloc] initAtPosition: CGPointMake(colLeftStart, nextBarStart) withSize: itemRect02 withType: [UIColor orangeColor] withLegend:@"Labor" layoutType: theLayout];
        aStatusBar01.myAppStatBarItemDel = aStatusBarItem01;
//        aStatusBar01.myAppStatBarItemVCDel = self;
        [self.myStatusBar addSubview:aStatusBar01];
    } else {
        itemRect02 = CGRectMake(colLeftStart, nextBarStart, barWidth, barHeight);
        aStatusBar01.frame = itemRect02;
    }
    
    nextBarStart += marginHoriz + marginVert + barHeight*verOffset + barWidth*horOffset;
    nextBarStart += margin + barHeight;
    if (!aStatusBar02) {
        itemRect02 = CGRectMake(colLeftStart, nextBarStart, barWidth, barHeight);
        aStatusBarItem02 = [[AppStatusItem alloc] initOfType:foodStock WithViewControl:[self unitInventory]];
        aStatusBar02 = [[AppStatusBarView alloc] initAtPosition:CGPointMake(colLeftStart, nextBarStart) withSize: itemRect02 withType: [UIColor greenColor] withLegend:@"Food" layoutType: theLayout];
        aStatusBar02.myAppStatBarItemDel = aStatusBarItem02;
//        aStatusBar02.myAppStatBarItemVCDel = self;
        [self.myStatusBar addSubview:aStatusBar02];
    } else {
        itemRect02 = CGRectMake(colLeftStart, nextBarStart, barWidth, barHeight);
        aStatusBar02.frame = itemRect02;
    }
    
    nextBarStart += margin + barHeight;
    if (!aStatusBar03) {
        itemRect02 = CGRectMake(colLeftStart, nextBarStart, barWidth, barHeight);
        aStatusBarItem03 = [[AppStatusItem alloc] initOfType:waterStock WithViewControl:[self unitInventory]];
        aStatusBar03 = [[AppStatusBarView alloc] initAtPosition:CGPointMake(colLeftStart, nextBarStart) withSize: itemRect02 withType: [UIColor blueColor] withLegend:@"water" layoutType: theLayout];
        aStatusBar03.myAppStatBarItemDel = aStatusBarItem03;
//        aStatusBar03.myAppStatBarItemVCDel = self;
        [self.myStatusBar addSubview:aStatusBar03];
    }
    
    nextBarStart += margin + barHeight;
    if (!aStatusBar04) {
        itemRect02 = CGRectMake(colLeftStart, nextBarStart, barWidth, barHeight);
        aStatusBarItem04 = [[AppStatusItem alloc] initOfType:powerStock WithViewControl:[self unitInventory]];
        aStatusBar04 = [[AppStatusBarView alloc] initAtPosition:CGPointMake(colLeftStart, nextBarStart) withSize: itemRect02 withType: [UIColor yellowColor] withLegend:@"Power" layoutType: theLayout];
        aStatusBar04.myAppStatBarItemDel = aStatusBarItem04;
//        aStatusBar04.myAppStatBarItemVCDel = self;
        [self.myStatusBar addSubview:aStatusBar04];
    }
    
    nextBarStart += margin + barHeight;
    if (!aStatusBar05) {
        itemRect02 = CGRectMake(colLeftStart, nextBarStart, barWidth, barHeight);
        aStatusBarItem05 = [[AppStatusItem alloc] initOfType:airStock WithViewControl:[self unitInventory]];
        aStatusBar05 = [[AppStatusBarView alloc] initAtPosition:CGPointMake(colLeftStart, nextBarStart) withSize: itemRect02 withType: [UIColor lightGrayColor] withLegend:@"Air" layoutType: theLayout];
        aStatusBar05.myAppStatBarItemDel = aStatusBarItem05;
//        aStatusBar05.myAppStatBarItemVCDel = self;
        [self.myStatusBar addSubview:aStatusBar05];
    }
    
    // RIGHT SIDE
    //    nextBarStart = 0.0;
    nextBarStart += margin + barHeight;
    nextBarStart += margin + barHeight;
    if (!aStatusBar07) {
        itemRect02 = CGRectMake(colLeftStart, nextBarStart, barWidth, barHeight);
        aStatusBarItem07 = [[AppStatusItem alloc] initOfType:supplyStock WithViewControl:[self unitInventory]];
        aStatusBar07 = [[AppStatusBarView alloc] initAtPosition:CGPointMake(colLeftStart, nextBarStart) withSize: itemRect02 withType: [UIColor brownColor] withLegend:@"Suppl" layoutType: theLayout];
        aStatusBar07.myAppStatBarItemDel = aStatusBarItem07;
//        aStatusBar07.myAppStatBarItemVCDel = self;
        [self.myStatusBar addSubview:aStatusBar07];
    }
    
    nextBarStart += margin + barHeight;
    if (!aStatusBar08) {
        itemRect02 = CGRectMake(colLeftStart, nextBarStart, barWidth, barHeight);
        aStatusBarItem08 = [[AppStatusItem alloc] initOfType:materialStock WithViewControl:[self unitInventory]];
        aStatusBar08 = [[AppStatusBarView alloc] initAtPosition:CGPointMake(colLeftStart, nextBarStart) withSize: itemRect02 withType: [UIColor grayColor] withLegend:@"Matl" layoutType: theLayout];
        aStatusBar08.myAppStatBarItemDel = aStatusBarItem08;
//        aStatusBar08.myAppStatBarItemVCDel = self;
        [self.myStatusBar addSubview:aStatusBar08];
    }
    
    nextBarStart += margin + barHeight;
    if (!aStatusBar09) {
        itemRect02 = CGRectMake(colLeftStart, nextBarStart, barWidth, barHeight);
        aStatusBarItem09 = [[AppStatusItem alloc] initOfType:componentStock WithViewControl:[self unitInventory]];
        aStatusBar09 = [[AppStatusBarView alloc] initAtPosition:CGPointMake(colLeftStart, nextBarStart) withSize: itemRect02 withType: [UIColor magentaColor] withLegend:@"Comp" layoutType: theLayout];
        aStatusBar09.myAppStatBarItemDel = aStatusBarItem09;
//        aStatusBar09.myAppStatBarItemVCDel = self;
        [self.myStatusBar addSubview:aStatusBar09];
    }
    
    nextBarStart += margin + barHeight;
    if (!aStatusBar10) {
        itemRect02 = CGRectMake(colLeftStart, nextBarStart, barWidth, barHeight);
        aStatusBarItem10 = [[AppStatusItem alloc] initOfType:structureStock WithViewControl:[self unitInventory]];
        aStatusBar10 = [[AppStatusBarView alloc] initAtPosition:CGPointMake(colLeftStart, nextBarStart) withSize: itemRect02 withType: [UIColor cyanColor] withLegend:@"Struct" layoutType: theLayout];
        aStatusBar10.myAppStatBarItemDel = aStatusBarItem10;
//        aStatusBar10.myAppStatBarItemVCDel = self;
        [self.myStatusBar addSubview:aStatusBar10];
    }
    
    [self updateUI];
    
}

-(void) updateUI
{
    [self.myStatusBar setNeedsDisplay];
    __unused CGFloat tempValue = (float) _globals.dayOfContract / _globals.lengthOfContract;
    gameProgress.progress = (float) _globals.dayOfContract / _globals.lengthOfContract;
    NSNumber* theBal = [NSNumber numberWithDouble:_globals.bankAccountBalance];
    NSNumberFormatter* nf = [[NSNumberFormatter alloc] init];
    [nf setNumberStyle:NSNumberFormatterCurrencyStyle];
    gameBalance.text = [nf stringFromNumber: theBal];
}

-(void) calcStatusBarSizeForLayout: (int) thisLayout
{
    
    switch (thisLayout) {
        case 0:
            minBarHeight = 40.0f;
            margin = (self.myStatusBar.frame.size.height - minBarHeight * 10.0f) / 11.0f;
            
            if (margin > 10.0f) {
                barHeight = self.myStatusBar.frame.size.height * 4.0f / 61.0f;
                margin = barHeight / 4.0f;
            } else if (margin < 2.0f) {
                barHeight = (self.myStatusBar.frame.size.height - 22.0f) / 10.0f;
                margin = 2.0f;
            } else {
                barHeight = minBarHeight;
            }

            break;
            
        case 1:
            minBarHeight = 20.0f;
            margin = (self.myStatusBar.frame.size.height - minBarHeight * 10.0f) / 11.0f;
            
            if (margin > 10.0f) {
                barHeight = self.myStatusBar.frame.size.height * 4.0f / 61.0f;
                margin = barHeight / 2.0f;
            } else if (margin < 2.0f) {
                barHeight = (self.myStatusBar.frame.size.height - 22.0f) / 10.0f;
                margin = 2.0f;
            } else {
                barHeight = minBarHeight;
            }
            break;
            
        case 2:
            barHeight = self.myStatusBar.frame.size.height - 2;
            barWidth = (self.myStatusBar.frame.size.width - minMargin * 11.0f) / 10.0f;
            
            if (barWidth > 50.0f) {
                margin = (self.myStatusBar.frame.size.width - 50 * 10.0f) / 11.0f;
                barWidth = 50.0f;
                
                if (margin > 5.0f) {
                    margin = self.myStatusBar.frame.size.width / 111.0f;
                    barWidth = margin * 10.0f;
                }
            }
            break;
            
        default:
            break;
    }
}

-(void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    [self stopScreenUpdateTimer];
}

-(void) startScreenUpdateTimer { self.screenUpdateTimer = [NSTimer
                                                           scheduledTimerWithTimeInterval:5.0
                                                           target:self
                                                           selector:@selector(screenUpdateTimer:)
                                                           userInfo:nil repeats:YES]; }
-(void) stopScreenUpdateTimer { if (self.screenUpdateTimer != nil) { [self.screenUpdateTimer invalidate]; } }
-(void) screenUpdateTimer: (NSTimer*) updateTimer { NSLog(@"+++++ another day (screen upda) has passed"); [self updateUI]; }


- (UIScrollView *)statusScrollView:(AppStatusView *)requestor { 
    return theScrollView;
}

- (void)encodeWithCoder:(nonnull NSCoder *)aCoder { 
    NSLog(@"somebody called StatusViewController::encodeWithCoder");
}

- (void)traitCollectionDidChange:(nullable UITraitCollection *)previousTraitCollection { 
    NSLog(@"somebody called StatusViewController::traitCollectionDidChange");
}

- (void)preferredContentSizeDidChangeForChildContentContainer:(nonnull id<UIContentContainer>)container { 
    NSLog(@"somebody called StatusViewController::preferredContentSizeDidChangeForChildContentContainer");
}

- (CGSize)sizeForChildContentContainer:(nonnull id<UIContentContainer>)container withParentContainerSize:(CGSize)parentSize { 
    NSLog(@"somebody called StatusViewController::encodeWithCoder");
    return myView.frame.size;
}

- (void)systemLayoutFittingSizeDidChangeForChildContentContainer:(nonnull id<UIContentContainer>)container { 
    NSLog(@"somebody called StatusViewController::systemLayoutFittingSizeDidChangeForChildContentContainer");
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(nonnull id<UIViewControllerTransitionCoordinator>)coordinator { 
    NSLog(@"somebody called StatusViewController::viewWillTransitionToSize");
}

- (void)willTransitionToTraitCollection:(nonnull UITraitCollection *)newCollection withTransitionCoordinator:(nonnull id<UIViewControllerTransitionCoordinator>)coordinator { 
    NSLog(@"somebody called StatusViewController::willTransitionToTraitCollection");
}

- (void)didUpdateFocusInContext:(nonnull UIFocusUpdateContext *)context withAnimationCoordinator:(nonnull UIFocusAnimationCoordinator *)coordinator { 
    NSLog(@"somebody called StatusViewController::didUpdateFocusInContext");
}

- (void)setNeedsFocusUpdate { 
    NSLog(@"somebody called StatusViewController::setNeedsFocusUpdate");
}

- (BOOL)shouldUpdateFocusInContext:(nonnull UIFocusUpdateContext *)context { 
    NSLog(@"somebody called StatusViewController::shouldUpdateFocusInContext");
    return YES;
}

- (void)updateFocusIfNeeded { 
    NSLog(@"somebody called StatusViewController::updateFocusIfNeeded");
}

@end

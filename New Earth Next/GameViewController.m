//
//  GameViewController.m
//  New Earth
//
//  Created by Scott Alexander on 7/5/16.
//  Copyright (c) 2016 Big Dog Tools. All rights reserved.
//

#import "GameViewController.h"
#import "AppDelegate.h"
#import "UnitsViewController.h"
#import "Globals.h"

@class UnitInventory;
@class AvailTech;
@class NewEarthGlobals;

@interface GameViewController()
@property (strong, nonatomic) id docBeganObserver;
@property (strong, nonatomic) id docInsertedObserver;
@property (strong, nonatomic) id docDeletedObserver;
@property (strong, nonatomic) id docChangeCompleteObserver;
@property (strong, nonatomic) id storeBeganObserver;
@property (strong, nonatomic) id storeInsertedObserver;
@property (strong, nonatomic) id storeDeletedObserver;
@property (strong, nonatomic) id storeChangeCompleteObserver;

@property (strong, nonatomic) UnitInventory* aWarehouse;
@property (strong, nonatomic) AvailTech* aStore;
@property (strong, nonatomic) NewEarthGlobals* aGlobals;

@end

@implementation GameViewController
//@synthesize contentSize, imageView, theScrollView, myMapView, myUnitView, myGridView, myGameView, myPopup, myEnvView;
@synthesize contentSize, buttonSize, imageView, theScrollView, myMapView, myUnitView, myGridView, myGameView, myEnvView;
@synthesize theTapGR, myTapLoc, myScale, theTapLocation, mySustain, myStatusBar, startNewGameButton, resumeGameButton;
@synthesize aStatusBarItem01, aStatusBarItem02, aStatusBarItem03, aStatusBarItem04, aStatusBarItem05, aStatusBarItem06;
@synthesize aStatusBarItem07, aStatusBarItem08, aStatusBarItem09, aStatusBarItem10, aStatusBarItem11, aStatusBarItem12;
@synthesize aStatusBarScroll01, aStatusBarScroll02, aStatusBarScroll03, aStatusBarScroll04, aStatusBarScroll05, aStatusBarScroll06;
@synthesize aStatusBarScroll07, aStatusBarScroll08, aStatusBarScroll09, aStatusBarScroll10, aStatusBarScroll11, aStatusBarScroll12;

@synthesize center;
//@synthesize myWarehouse, myGlobals;

// delete this after TESTING!
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    NSLog(@"%@ appeared, unitInv %@, availtec %@", [self class], self.aWarehouse, self.aStore);

    //imageView = myMapView.imageView;
/*
    myStatusBar = [[AppStatusView alloc] init];
    myStatusBar.myAppStatusDel = self;
    [self.myEnvView addSubview:myStatusBar]; // added status bar to envelope layer
*/
    // Place the status bar
//TODO:  fix positioning the status bar (and add the background)
//    CGPoint myOrigin = CGPointMake(10.0, [[self view] window].frame.size.height-50.0-10.0);
    CGPoint myOrigin = CGPointMake(10.0, 0.0);
    CGRect myRect = CGRectMake( myOrigin.x, myOrigin.y, ([[self view] window].frame.size.width - 20.0), 50);
    self.myStatusBar.frame = myRect; //fixedFrame;
    
//    bool isVert = YES; // isVert = NO;
//    if (isVert) { [self placeVerticalBars]; } else { [self placeHorizontalBars]; }

    contentSize = myMapView.image.size;
    theScrollView.contentSize = contentSize;
    [theScrollView addSubview:imageView];
    contentSize = theScrollView.contentSize;
    
//    [self placeGameButtons];

    [self placeGameButtons];
    
    if (self.aGlobals.dayOfContract > self.aGlobals.lengthOfContract) {
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"ALERT - Game Over!"
                                                                       message:@"The game is over and you ???"
                                                                preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK"
                                                                style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction* action) {}];
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
    }

}

- (void)viewDidLoad
{
    [super viewDidLoad];

//    theScrollView.myMapScrollDelegate = self;
    myMapView.myMapDelegate = self;
    myGameView.myGameViewDelegate = self;
    myGridView.myGridDelegate = self;
    myEnvView.myEnvDelegate = self;
    myUnitView.myUnitDelegate = self;
    
    theScrollView.minimumZoomScale = 0.5; //0.5;
    theScrollView.maximumZoomScale = 5.0; //10.0;
    theScrollView.zoomScale = 1.0;
    
    myScale = 1.0;
    
    theScrollView.clipsToBounds = YES;
    theScrollView.delegate = self;
    
    [self createGameButtons];

    myStatusBar = [[AppStatusView alloc] init];
    myStatusBar.myAppStatusDel = self;
    [self.myEnvView addSubview:myStatusBar]; // added status bar to envelope layer
    
    bool isVert = YES; // isVert = NO;
    if (isVert) { [self placeVerticalBars]; } else { [self placeHorizontalBars]; }

//    myStatusBar = [[AppStatusView alloc] init];
//    myStatusBar.myAppStatusDel = self;
//    [self.myEnvView addSubview:myStatusBar]; // added status bar to envelope layer
    
    // Place the status bar
//    CGPoint myOrigin = CGPointMake(10.0, [[self view] window].frame.size.height-50.0-10.0);
//    CGRect myRect = CGRectMake( myOrigin.x, myOrigin.y, ([[self view] window].frame.size.width - 20.0), 50);
//    self.myStatusBar.frame = myRect; //fixedFrame;

//    bool isVert = YES; // isVert = NO;
//    if (isVert) { [self placeVerticalBars]; } else { [self placeHorizontalBars]; }
}

-(void) viewWillAppear:(BOOL)animated
{
    // do some stuff here
    [super viewWillAppear:YES];
    
    center = [NSNotificationCenter defaultCenter];
    
    [center addObserver:self
               selector:@selector(handleUpdateNotification:)
                   name:kSetUpdateNotification
                 object:nil];
}

-(void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    [self stopScreenUpdateTimer];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


-(IBAction)startNewGame
{
    // reset contents of warehouse (HQ only ... unplaced)
    [_aWarehouse resetContents];
    // hide all Game buttons
    NSLog(@"startNewGame button pressed");
    [startNewGameButton setHidden:YES];
    [resumeGameButton setHidden:YES];
    _aGlobals.isRunning = YES;
}
-(IBAction)resumeGame
{
    // hide all Game buttons
    NSLog(@"resumeGame button pressed");
    [startNewGameButton setHidden:YES];
    [resumeGameButton setHidden:YES];
    _aGlobals.isRunning = YES;
}

-(void) createGameButtons
{
    if (startNewGameButton) { return; }
    if (_aGlobals.isRunning) {return;}
    
    // start new button
    startNewGameButton = [UIButton buttonWithType: UIButtonTypeRoundedRect];
    [startNewGameButton setTitle:@"New Game" forState:UIControlStateNormal];
    startNewGameButton.titleLabel.font = [UIFont boldSystemFontOfSize: 30];
    [startNewGameButton addTarget:self action:@selector(startNewGame) forControlEvents:UIControlEventTouchUpInside];
    [theScrollView addSubview:startNewGameButton];
    startNewGameButton.backgroundColor = [UIColor whiteColor];
    
    // resume button
    resumeGameButton = [UIButton buttonWithType: UIButtonTypeRoundedRect];
    [resumeGameButton setTitle:@"Resume" forState:UIControlStateNormal];
    resumeGameButton.titleLabel.font = [UIFont boldSystemFontOfSize: 30];
    [resumeGameButton addTarget:self action:@selector(resumeGame) forControlEvents:UIControlEventTouchUpInside];
    [theScrollView addSubview:resumeGameButton];
    resumeGameButton.backgroundColor = [UIColor greenColor];
}

-(void) placeGameButtons
{
    if (startNewGameButton.hidden == YES) { return; }
    if (_aGlobals.isRunning) {return;}
    
    buttonSize = CGSizeMake([[self view] window].frame.size.width*0.75, [[self view] window].frame.size.height*0.25);
    
    // button positions ...
    CGFloat buttonLeftEdge = [[self view] window].frame.size.width / 8.0;
    CGFloat buttonTopEdgeStart = [[self view] window].frame.size.height * 3.0 / 16.0;
    CGFloat buttonTopEdgeResume = [[self view] window].frame.size.height * 9.0 / 16.0;
    
    // start new button
    startNewGameButton.frame = CGRectMake(buttonLeftEdge, buttonTopEdgeStart, buttonSize.width, buttonSize.height);
    
    // resume button
    resumeGameButton.frame = CGRectMake(buttonLeftEdge, buttonTopEdgeResume, buttonSize.width, buttonSize.height);
}

#pragma mark - Accessor Methods

-(void) setUnitInventory: (UnitInventory*) unitInventory { _aWarehouse = unitInventory; }
-(void) setAvailTech: (AvailTech*) availTech { _aStore = availTech; }
-(void) setTheGlobals: (NewEarthGlobals *) myGlobals { _aGlobals = myGlobals; }


#pragma mark - Private Methods

// routine to place vertical oriented status bars
-(void) placeVerticalBars
{
//    CGFloat colLeftStart = 5.0;
//    CGFloat colRightStart = 165.0;
    CGFloat barHeight = 6.0;
    CGFloat barWidth = 150;
    CGFloat barMargin = 2;
    CGFloat nextBarStart = 0.0;
    
    barHeight = 40.0;
    barWidth = 37.0;
    CGFloat colTop = barMargin;
    
    // create the status progress bar items
    nextBarStart += barMargin + 1;
    AppStatusBarView* aBar = [self makeStatusBar: aStatusBarItem01 inRect: CGRectMake(nextBarStart, colTop, barWidth, barHeight) stockType: laborStock stockColor: [UIColor orangeColor] named: @"Labor"];
    [self.myStatusBar addSubview:aBar];
    
    nextBarStart += barMargin + barWidth;
    aBar = [self makeStatusBar: aStatusBarItem02 inRect: CGRectMake(nextBarStart, colTop, barWidth, barHeight) stockType: foodStock stockColor: [UIColor greenColor] named: @"Food"];
    [self.myStatusBar addSubview:aBar];
    
    nextBarStart += barMargin + barWidth;
    aBar = [self makeStatusBar: aStatusBarItem03 inRect: CGRectMake(nextBarStart, colTop, barWidth, barHeight) stockType: waterStock stockColor: [UIColor blueColor] named: @"Water"];
    [self.myStatusBar addSubview:aBar];
    
    nextBarStart += barMargin + barWidth;
    aBar = [self makeStatusBar: aStatusBarItem04 inRect: CGRectMake(nextBarStart, colTop, barWidth, barHeight) stockType: powerStock stockColor: [UIColor yellowColor] named: @"Power"];
    [self.myStatusBar addSubview:aBar];
    
    nextBarStart += barMargin + barWidth;
    aBar = [self makeStatusBar: aStatusBarItem05 inRect: CGRectMake(nextBarStart, colTop, barWidth, barHeight) stockType: airStock stockColor: [UIColor cyanColor] named: @"Air"];
    [self.myStatusBar addSubview:aBar];
    
    nextBarStart += barMargin + barWidth;
    nextBarStart += barMargin + barWidth;
    aBar = [self makeStatusBar: aStatusBarItem07 inRect: CGRectMake(nextBarStart, colTop, barWidth, barHeight) stockType: supplyStock stockColor: [UIColor brownColor] named: @"Supply"];
    [self.myStatusBar addSubview:aBar];
    
    nextBarStart += barMargin + barWidth;
    aBar = [self makeStatusBar: aStatusBarItem08 inRect: CGRectMake(nextBarStart, colTop, barWidth, barHeight) stockType: materialStock stockColor: [UIColor magentaColor] named: @"Matl"];
    [self.myStatusBar addSubview:aBar];
    
    nextBarStart += barMargin + barWidth;
    aBar = [self makeStatusBar: aStatusBarItem09 inRect: CGRectMake(nextBarStart, colTop, barWidth, barHeight) stockType: componentStock stockColor: [UIColor grayColor] named: @"Comp"];
    [self.myStatusBar addSubview:aBar];
    
    nextBarStart += barMargin + barWidth;
    aBar = [self makeStatusBar: aStatusBarItem10 inRect: CGRectMake(nextBarStart, colTop, barWidth, barHeight) stockType: structureStock stockColor: [UIColor purpleColor] named: @"Struc"];
    [self.myStatusBar addSubview: aBar];

}

-(AppStatusBarView*) makeStatusBar: (AppStatusItem*) statusItem
                            inRect: (CGRect) aRect
                         stockType: (stockType) statusType
                        stockColor: (UIColor*) aBarColor
                             named: (NSString*) aLegend
{
    statusItem = [[AppStatusItem alloc] initOfType: statusType
                                   WithViewControl: [self aWarehouse]];
    
    AppStatusBarView* aBar = [[AppStatusBarView alloc] initAtPosition: aRect.origin
                                                             withSize: aRect
                                                             withType: aBarColor
                                                           withLegend: aLegend
                                                           layoutType: 0];
    
    aBar.myAppStatBarItemDel = statusItem;
    aBar.myScrollDel = self;
    
    return aBar;
}

// routine to place horizontally oriented status bars
-(void) placeHorizontalBars
{
    __unused CGFloat colLeftStart = 5.0;
    __unused CGFloat colRightStart = 165.0;
    __unused CGFloat barHeight = 6.0;
    __unused CGFloat barWidth = 150;
    __unused CGFloat barMargin = 2;
    __unused CGFloat nextBarStart = 0.0;
/*
    // create the status progress bar items
    // LEFT SIDE
    nextBarStart += barMargin;
    CGRect itemRect02 = CGRectMake(colLeftStart, nextBarStart, barWidth, barHeight);
    aStatusBarItem01 = [[AppStatusItem alloc] initOfType:laborStock WithViewControl:[self aWarehouse]]; //appstatusitem
    AppStatusBarView* aBar = [[AppStatusBarView alloc] initAtPosition: CGPointMake(colLeftStart, nextBarStart) withSize: itemRect02 withType: [UIColor orangeColor] withLegend:@"Labor" layoutType: 0];
    aBar.myAppStatBarItemDel = aStatusBarItem01;
    aBar.myAppStatBarItemVCDel = self;
    [self.myStatusBar addSubview:aBar];
    
    nextBarStart += barMargin + barHeight;
    itemRect02 = CGRectMake(colLeftStart, nextBarStart, barWidth, barHeight);
    aStatusBarItem02 = [[AppStatusItem alloc] initOfType:foodStock WithViewControl:[self aWarehouse]];
    aBar = [[AppStatusBarView alloc] initAtPosition:CGPointMake(colLeftStart, nextBarStart) withSize: itemRect02 withType: [UIColor greenColor] withLegend:@"Food" layoutType: 0];
    aBar.myAppStatBarItemDel = aStatusBarItem02;
    aBar.myAppStatBarItemVCDel = self;
    [self.myStatusBar addSubview:aBar];
    
    nextBarStart += barMargin + barHeight;
    itemRect02 = CGRectMake(colLeftStart, nextBarStart, barWidth, barHeight);
    aStatusBarItem03 = [[AppStatusItem alloc] initOfType:waterStock WithViewControl:[self aWarehouse]];
    aBar = [[AppStatusBarView alloc] initAtPosition:CGPointMake(colLeftStart, nextBarStart) withSize: itemRect02 withType: [UIColor magentaColor] withLegend:@"Mag" layoutType: 0];
    aBar.myAppStatBarItemDel = aStatusBarItem03;
    aBar.myAppStatBarItemVCDel = self;
    [self.myStatusBar addSubview:aBar];
    
    nextBarStart += barMargin + barHeight;
    itemRect02 = CGRectMake(colLeftStart, nextBarStart, barWidth, barHeight);
    aStatusBarItem04 = [[AppStatusItem alloc] initOfType:powerStock WithViewControl:[self aWarehouse]];
    aBar = [[AppStatusBarView alloc] initAtPosition:CGPointMake(colLeftStart, nextBarStart) withSize: itemRect02 withType: [UIColor purpleColor] withLegend:@"Purple" layoutType: 0];
    aBar.myAppStatBarItemDel = aStatusBarItem04;
    aBar.myAppStatBarItemVCDel = self;
    [self.myStatusBar addSubview:aBar];
    
    nextBarStart += barMargin + barHeight;
    itemRect02 = CGRectMake(colLeftStart, nextBarStart, barWidth, barHeight);
    aStatusBarItem05 = [[AppStatusItem alloc] initOfType:airStock WithViewControl:[self aWarehouse]];
    aBar = [[AppStatusBarView alloc] initAtPosition:CGPointMake(colLeftStart, nextBarStart) withSize: itemRect02 withType: [UIColor yellowColor] withLegend:@"Power" layoutType: 0];
    aBar.myAppStatBarItemDel = aStatusBarItem05;
    aBar.myAppStatBarItemVCDel = self;
    [self.myStatusBar addSubview:aBar];
    
    
    // RIGHT SIDE
    nextBarStart = 0.0;
    nextBarStart += barMargin;
    itemRect02 = CGRectMake(colRightStart, nextBarStart, barWidth, barHeight);
    aStatusBarItem07 = [[AppStatusItem alloc] initOfType:supplyStock WithViewControl:[self aWarehouse]];
    aBar = [[AppStatusBarView alloc] initAtPosition:CGPointMake(colRightStart, nextBarStart) withSize: itemRect02 withType: [UIColor brownColor] withLegend:@"Matl" layoutType: 0];
    aBar.myAppStatBarItemDel = aStatusBarItem07;
    aBar.myAppStatBarItemVCDel = self;
    [self.myStatusBar addSubview:aBar];
    
    nextBarStart += barMargin + barHeight;
    itemRect02 = CGRectMake(colRightStart, nextBarStart, barWidth, barHeight);
    aStatusBarItem08 = [[AppStatusItem alloc] initOfType:materialStock WithViewControl:[self aWarehouse]];
    aBar = [[AppStatusBarView alloc] initAtPosition:CGPointMake(colRightStart, nextBarStart) withSize: itemRect02 withType: [UIColor blueColor] withLegend:@"Water" layoutType: 0];
    aBar.myAppStatBarItemDel = aStatusBarItem08;
    aBar.myAppStatBarItemVCDel = self;
    [self.myStatusBar addSubview:aBar];
    
    nextBarStart += barMargin + barHeight;
    itemRect02 = CGRectMake(colRightStart, nextBarStart, barWidth, barHeight);
    aStatusBarItem09 = [[AppStatusItem alloc] initOfType:componentStock WithViewControl:[self aWarehouse]];
    aBar = [[AppStatusBarView alloc] initAtPosition:CGPointMake(colRightStart, nextBarStart) withSize: itemRect02 withType: [UIColor grayColor] withLegend:@"Gray" layoutType: 0];
    aBar.myAppStatBarItemDel = aStatusBarItem09;
    aBar.myAppStatBarItemVCDel = self;
    [self.myStatusBar addSubview:aBar];
    
    nextBarStart += barMargin + barHeight;
    itemRect02 = CGRectMake(colRightStart, nextBarStart, barWidth, barHeight);
    aStatusBarItem10 = [[AppStatusItem alloc] initOfType:structureStock WithViewControl:[self aWarehouse]];
    aBar = [[AppStatusBarView alloc] initAtPosition:CGPointMake(colRightStart, nextBarStart) withSize: itemRect02 withType: [UIColor yellowColor] withLegend:@"Yellow" layoutType: 0];
    aBar.myAppStatBarItemDel = aStatusBarItem10;
    aBar.myAppStatBarItemVCDel = self;
    [self.myStatusBar addSubview:aBar];
*/    
}

- (IBAction)handleTap: (UITapGestureRecognizer*) recognizer
{
    CGPoint tapLoc;
    // do something special
    if (recognizer.state == UIGestureRecognizerStateEnded)
    {
        NewTech* aUnit = [[NewTech alloc] init];
        aUnit.mySize = CGSizeMake(100,100);
        
        tapLoc = [recognizer locationInView:myMapView];

        _unit = aUnit;
        _unit.myLoc = tapLoc;
        
        myTapLoc = tapLoc;
        [self updateUI];
    }
}

- (IBAction)handleDoubleTap: (UITapGestureRecognizer*) recognizer
{
    // CGPoint tapLoc;
    // do something special
    if (recognizer.state == UIGestureRecognizerStateEnded)
    {
//        myTapLoc = [recognizer locationInView:imageView];
//        NSLog(@"double tap gesture at X:%f Y:%f\n", myTapLoc.x, myTapLoc.y);
//        [self performSegueWithIdentifier:@"toInventory" sender:self];
//        [self performSegueWithIdentifier:@"toNavToTableView" sender:self];
        [self performSegueWithIdentifier:@"fromMapToStore" sender:self];
        
    }
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([segue.identifier isEqualToString:@"fromMapToStore"]) {
        UnitsViewController* controller = segue.destinationViewController;
        if ([controller respondsToSelector:@selector(setAvailTech:)]) {
            [controller setAvailTech:self.aStore];
        }
        if ([controller respondsToSelector:@selector(setUnitInventory:)]) {
            [controller setUnitInventory:self.aWarehouse];
        }
        if ([controller respondsToSelector:@selector(setMyGlobals:)]) {
            [controller setMyGlobals:self.aGlobals];
        }
        controller.theTapLocation = myTapLoc; // CGPointMake(myTapLoc.x / theScrollView.zoomScale, myTapLoc.y / theScrollView.zoomScale);
//        CGPoint abc = CGPointMake(myTapLoc.x * _theScale, myTapLoc.y * _theScale);
    }
}


- (IBAction)exitToHere:(UIStoryboardSegue*)sender
{
    // no action required
    [self updateUI];
}

-(UIView *) viewForZoomingInScrollView: (UIScrollView *) scrollView { return myGameView; }
//-(UIView *) viewForZoomingInScrollView: (UIScrollView *) scrollView { return self.myMapView; }
//-(UIView*) viewForZoomingInScrollView:(UIScrollView *) scrollView { return self.imageView; }

-(void) scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale{
//    NSLog(@"the zoom scale was: %f\n", scale);
//    myScale = scale;
    
// TODO: not executed ... was used for debugging ... eliminate eventually
    if (scale>5.0) { scrollView.zoomScale = 5.0; } else if (scale < 0.5) { scrollView.zoomScale = 0.5; } // max 5.0 min 0.5
    scrollView.zoomScale = scale;
    [self updateUI];
}

-(void) scrollViewDidScroll:(UIScrollView *)scrollView {
//    NSLog(@"scroll h=%f w=%f scale=%f", scrollView.contentSize.height, scrollView.contentSize.width, scrollView.zoomScale);
    [self updateUI];
    
}
-(void)scrollViewDidZoom:(UIScrollView *)scrollView {
//    NSLog(@"zoomed h=%f w=%f scale=%f", scrollView.contentSize.height, scrollView.contentSize.width, scrollView.zoomScale);
    [self updateUI];
    
}

-(void) updateUI
{
    [self.theScrollView setNeedsDisplay];
    [self.myMapView setNeedsDisplay];
    [self.myGridView setNeedsDisplay];
    [self.myUnitView setNeedsDisplay];
    [self.myGridView setNeedsDisplay];
    [self.myEnvView setNeedsDisplay];
    [self.mySustain setNeedsDisplay];
    [self.myStatusBar setNeedsDisplay];
}

-(UIView*) newViewWithCenter:(CGPoint)paramCenter
             backgroundColor:(UIColor*)paramBackgroundColor
{
    UIView* newView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 50.0f, 50.0f)];
    newView.backgroundColor = paramBackgroundColor;
    newView.center = paramCenter;
    return newView;
}

- (BOOL)shouldAutorotate { return YES; }
- (BOOL)prefersStatusBarHidden { return YES; }

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    } else {
        return UIInterfaceOrientationMaskAll;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - GameView Delegate Methods

// Implementation of GameViewDelegate functions
-(float) scaleForDrawingGame: (GameView*) requestor { return myScale; }
//-(CGPoint) placeForDrawing: (GameView*) requestor;

#pragma mark - Grid_View Delegate Methods

// Implementation of GridViewDelegate functions
-(float) scaleForDrawingGrid: (Grid_View*) requestor { return myScale; }
-(CGFloat) gridSpacingGlobal: (Grid_View*) requestor { return _aGlobals.gridSpacing; }
-(CGFloat) gridXOriginGlobal: (Grid_View*) requestor { return _aGlobals.gridXOrigin; }
-(CGFloat) gridYOriginGlobal: (Grid_View*) requestor { return _aGlobals.gridYOrigin; }
-(CGFloat) frameWidthGlobal: (Grid_View*) requestor { return _aGlobals.width; }
-(CGFloat) frameHeightGlobal: (Grid_View*) requestor { return _aGlobals.height; }


#pragma mark - UnitView Delegate Methods

// Implementation of UnitViewDelegate functions
-(float) scaleForDrawingUnit: (UnitView*) requestor { return myScale; }

#pragma mark - MapScrollView Delegate Methods

// Implementation of MapScrollViewDelegate functions
-(CGPoint) placeForDrawing:(MapScrollView*) requestor { return myTapLoc; }
-(NewTech*) unitToDraw:(MapScrollView*) requestor { return _unit; }
-(UnitInventory*) unitsToDraw:(MapScrollView*) requestor { return [self getTheWarehouse]; }

-(float) scaleForDrawing:(MapScrollView*) requestor { return myScale; }

#pragma mark - MapView Delegate Methods

// Implementation of MapViewDelegate functions
-(float) scaleForDrawingMap: (MapView*) requestor { return myScale; }

-(float) scaleForDrawingOnMap: (MapView*) requestor { return myScale; }
-(CGPoint) placeForDrawingOnMap:(MapView *) requestor { return myTapLoc; }

-(NewTech*) unitToDrawOnMap:(MapView *) requestor
{
    NewTech* someUnit = [[NewTech alloc] init];
    return someUnit;
}

-(UnitInventory*) unitsToDrawOnMap:(MapView *) requestor { return [self getTheWarehouse]; }

//-(AvailTech*) unitsInStore:(ViewController *) requestor { return _aStore; }

//-(CGFloat) accountBalance:(ViewController *)requestor { return _aGlobals.bankAccountBalance; }

#pragma mark - Envelope Delegate Methods

// Implementation of EnvelopeViewDelegate functions
-(float) scaleForDrawingEnv: (Envelope*) requestor { return myScale; }
-(UnitInventory*) unitsToDrawEnv:(Envelope*) requestor { return [self getTheWarehouse]; }
-(UnitInventory*) getTheWarehouse { return _aWarehouse; }
-(NSMutableDictionary*) tilesToDrawEnv:(Envelope*) requestor { return _aGlobals.geoTileList; }

-(CGFloat) gridSpacingEnv:(Envelope *)requestor { return _aGlobals.gridSpacing; }

#pragma mark - AppStatusView Delegate Methods

-(UIScrollView*) statusScrollView:(AppStatusView*) requestor {return theScrollView;}

#pragma mark - AppStatusBarView Delegate Methods

-(UIScrollView*) statBarScrollView:(AppStatusBarView*) requestor {return theScrollView;}

#pragma mark - AppStatusBarView Delegate Methods

-(UIScrollView*) statItemScrollView:(AppStatusBarView*) requestor {return theScrollView;}
-(CGFloat) statItemProduce: (AppStatusBarView*) requestor {return 0;} //AppStatusItem
-(CGFloat) statItemConsume: (AppStatusBarView*) requestor {return 0;}
-(CGFloat) statItemNewProd: (AppStatusBarView*) requestor {return 0;}
-(CGPoint) statItemBarLoc: (AppStatusBarView*) requestor {return CGPointMake(0.0, 0.0);}
-(UIColor*) statItemMyColor: (AppStatusBarView*) requestor {return [UIColor magentaColor];}

#pragma mark - Screen Update Methods

-(void) startScreenUpdateTimer { self.screenUpdateTimer = [NSTimer
                            scheduledTimerWithTimeInterval:5.0
                            target:self
                            selector:@selector(screenUpdateTimer:)
                            userInfo:nil repeats:YES]; }
-(void) stopScreenUpdateTimer { if (self.screenUpdateTimer != nil) { [self.screenUpdateTimer invalidate]; } }
-(void) screenUpdateTimer: (NSTimer*) updateTimer { NSLog(@"@@@@@ another day (screen upda) has passed"); [self updateUI]; }

-(void) handleUpdateNotification:(NSNotification*) paramNotification { [self updateUI]; }

@end

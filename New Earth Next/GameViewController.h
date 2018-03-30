//
//  GameViewController.h
//  New Earth
//

//  Copyright (c) 2016 Big Dog Tools. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SceneKit/SceneKit.h>
#import "NewTech.h"
#import "MapView.h"
#import "MapScrollView.h"
#import "Grid View.h"
#import "UnitView.h"
#import "AvailTech.h"
//#import "ViewController.h"
#import "GameView.h"
#import "Envelope.h"
#import "Globals.h"
#import "AppStatusBarView.h"
#import "AppStatusView.h"
#import "AppStatusItem.h"


//@interface GameViewController : UIViewController <UIScrollViewDelegate, UnitViewDelegate, MapViewDelegate, MapScrollViewDelegate, GridViewDelegate, PlaceUnitPopupDelegate, AppStatusBarViewDelegate, AppStatusDelegate, GameViewDelegate, EnvelopeViewDelegate>
//@interface GameViewController : UIViewController <UIScrollViewDelegate, UnitViewDelegate, MapViewDelegate, GridViewDelegate, PlaceUnitPopupDelegate, AppStatusBarViewDelegate, AppStatusDelegate, GameViewDelegate, EnvelopeViewDelegate>
@interface GameViewController : UIViewController <UIScrollViewDelegate, UnitViewDelegate, MapViewDelegate, GridViewDelegate, GameViewDelegate, EnvelopeViewDelegate, AppStatusDelegate, AppStatusBarViewDelegate, AppStatusBarViewScrollDel>
{
//    IBOutlet UIScrollView* myScrollView;
    IBOutlet UIImageView*  imageView;
    IBOutlet UITapGestureRecognizer *theTapGR;
    IBOutlet MapView* myMapView;
    IBOutlet MapScrollView* theScrollView;
    IBOutlet Grid_View* myGridView;
    IBOutlet UnitView* myUnitView;
    IBOutlet GameView* myGameView;
    IBOutlet Envelope* myEnvView;
    
//    IBOutlet ViewController* myPopup;
    
    CGFloat myScale;
    CGPoint myTapLoc;
    
}

@property (retain) NSNotificationCenter* center;

@property (nonatomic, strong) UIImageView* imageView;
@property UITapGestureRecognizer* theTapGR;
@property CGFloat myScale;
@property CGPoint myTapLoc;
@property (retain) IBOutlet MapView* myMapView;
@property (retain) IBOutlet MapScrollView* theScrollView;
@property (retain) IBOutlet Grid_View* myGridView;
@property (retain) IBOutlet UnitView* myUnitView;
@property (retain) IBOutlet GameView* myGameView;
@property (retain) IBOutlet Envelope* myEnvView;
//@property (retain) IBOutlet ViewController* myPopup;
//@property (retain) IBOutlet NewEarthGlobals* myGlobals;
@property (retain) IBOutlet UIView* mySustain;

@property CGSize contentSize;
@property CGSize buttonSize;
@property CGPoint theTapLocation;

//@property UnitInventory* myWarehouse;

@property (readonly) UIGestureRecognizerState state;
@property (strong) UIButton* startNewGameButton;
@property (strong) UIButton* resumeGameButton;

- (IBAction)handleTap: (UITapGestureRecognizer*) recognizer;
- (IBAction)exitToHere:(UIStoryboardSegue*)sender;
-(IBAction)startNewGame;
-(IBAction)resumeGame;


-(void) updateUI;

@property (retain) IBOutlet AppStatusView* myStatusBar;

@property (retain) IBOutlet AppStatusItem* aStatusBarItem01;
@property (retain) IBOutlet AppStatusItem* aStatusBarItem02;
@property (retain) IBOutlet AppStatusItem* aStatusBarItem03;
@property (retain) IBOutlet AppStatusItem* aStatusBarItem04;
@property (retain) IBOutlet AppStatusItem* aStatusBarItem05;
@property (retain) IBOutlet AppStatusItem* aStatusBarItem06;
@property (retain) IBOutlet AppStatusItem* aStatusBarItem07;
@property (retain) IBOutlet AppStatusItem* aStatusBarItem08;
@property (retain) IBOutlet AppStatusItem* aStatusBarItem09;
@property (retain) IBOutlet AppStatusItem* aStatusBarItem10;
@property (retain) IBOutlet AppStatusItem* aStatusBarItem11;
@property (retain) IBOutlet AppStatusItem* aStatusBarItem12;

@property (retain) IBOutlet AppStatusBarView* aStatusBarScroll01;
@property (retain) IBOutlet AppStatusBarView* aStatusBarScroll02;
@property (retain) IBOutlet AppStatusBarView* aStatusBarScroll03;
@property (retain) IBOutlet AppStatusBarView* aStatusBarScroll04;
@property (retain) IBOutlet AppStatusBarView* aStatusBarScroll05;
@property (retain) IBOutlet AppStatusBarView* aStatusBarScroll06;
@property (retain) IBOutlet AppStatusBarView* aStatusBarScroll07;
@property (retain) IBOutlet AppStatusBarView* aStatusBarScroll08;
@property (retain) IBOutlet AppStatusBarView* aStatusBarScroll09;
@property (retain) IBOutlet AppStatusBarView* aStatusBarScroll10;
@property (retain) IBOutlet AppStatusBarView* aStatusBarScroll11;
@property (retain) IBOutlet AppStatusBarView* aStatusBarScroll12;

//@property AppStatusBarViewController* aAppVC01;


@property (weak, nonatomic) IBOutlet UIButton *exitButton;

//@property (nonatomic, assign) id <ScrollViewDel> myDelegate;
//@property (weak, nonatomic) id <ScrollViewDoneDel> delegate;

@property NewTech* unit;
//@property NSMutableDictionary* theUnits;
@property CGPoint rightHere;
@property float theScale;

//-(IBAction) scrollButtonPressed:       (UIButton*)sender;
//-(IBAction) done: (id)sender;

@property (nonatomic, strong) NSTimer* screenUpdateTimer;

-(void) startScreenUpdateTimer;
-(void) stopScreenUpdateTimer;
-(void) screenUpdateTimer: (NSTimer*) updateTimer;


@end

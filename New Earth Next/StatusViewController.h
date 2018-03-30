//
//  StatusViewController.h
//  New Earth
//
//  Created by Scott Alexander on 6/15/17.
//  Copyright © 2017 Big Dog Tools. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppStatusItem.h"
#import "AppStatusView.h"
#import "AppStatusBarView.h"
#import "StatusRoom.h"
//#import "Globals.h"

extern int const kHorizNarrow;
extern int const kHorizWide;
extern int const kVertical;

@interface StatusViewController : UIViewController <AppStatusBarViewDelegate, AppStatusDelegate, AppStatusBarViewScrollDel>

@property (retain) IBOutlet StatusRoom* myStatusRoom;

@property (retain) IBOutlet AppStatusView* myStatusBar;

@property (retain) AppStatusItem* aStatusBarItem01;
@property (retain) AppStatusItem* aStatusBarItem02;
@property (retain) AppStatusItem* aStatusBarItem03;
@property (retain) AppStatusItem* aStatusBarItem04;
@property (retain) AppStatusItem* aStatusBarItem05;
@property (retain) AppStatusItem* aStatusBarItem06;
@property (retain) AppStatusItem* aStatusBarItem07;
@property (retain) AppStatusItem* aStatusBarItem08;
@property (retain) AppStatusItem* aStatusBarItem09;
@property (retain) AppStatusItem* aStatusBarItem10;
@property (retain) AppStatusItem* aStatusBarItem11;
@property (retain) AppStatusItem* aStatusBarItem12;

@property (retain) IBOutlet AppStatusBarView* aStatusBar01;
@property (retain) IBOutlet AppStatusBarView* aStatusBar02;
@property (retain) IBOutlet AppStatusBarView* aStatusBar03;
@property (retain) IBOutlet AppStatusBarView* aStatusBar04;
@property (retain) IBOutlet AppStatusBarView* aStatusBar05;
@property (retain) IBOutlet AppStatusBarView* aStatusBar06;
@property (retain) IBOutlet AppStatusBarView* aStatusBar07;
@property (retain) IBOutlet AppStatusBarView* aStatusBar08;
@property (retain) IBOutlet AppStatusBarView* aStatusBar09;
@property (retain) IBOutlet AppStatusBarView* aStatusBar10;
@property (retain) IBOutlet AppStatusBarView* aStatusBar11;
@property (retain) IBOutlet AppStatusBarView* aStatusBar12;

-(IBAction) quitApp: (id) sender;

//@property UnitInventory* myWarehouse;
//@property NewEarthGlobals* myGlobals;
@property UIScrollView* theScrollView;
@property UIView* myView;
@property (retain) IBOutlet UIProgressView* gameProgress;

@property CGFloat barHeight;
@property CGFloat barWidth;
@property CGFloat margin;
@property CGFloat minMargin;
@property CGFloat minBarHeight;
@property int layout;

@property (nonatomic, strong) NSTimer* screenUpdateTimer;

-(void) startScreenUpdateTimer;
-(void) stopScreenUpdateTimer;
-(void) screenUpdateTimer: (NSTimer*) updateTimer;
//-(UIScrollView*) statusScrollView:(AppStatusView*) requestor;

@end

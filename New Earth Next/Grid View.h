//
//  Grid View.h
//  New Earth
//
//  Created by Scott Alexander on 11/21/16.
//  Copyright © 2016 Big Dog Tools. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "Globals.h"

@class Grid_View;

@protocol GridViewDelegate

-(float) scaleForDrawingGrid: (Grid_View*) requestor;
-(CGFloat) gridSpacingGlobal: (Grid_View*) requestor;
-(CGFloat) gridXOriginGlobal: (Grid_View*) requestor;
-(CGFloat) gridYOriginGlobal: (Grid_View*) requestor;
-(CGFloat) frameWidthGlobal: (Grid_View*) requestor;
-(CGFloat) frameHeightGlobal: (Grid_View*) requestor;

@end

@interface Grid_View : UIView

@property (assign, nonatomic) CGFloat gridSpacing;
@property (assign, nonatomic) CGFloat gridLineWidth;
@property (assign, nonatomic) CGFloat gridXOffset;
@property (assign, nonatomic) CGFloat gridYOffset;
@property (strong, nonatomic) UIColor* gridLineColor;
@property (assign, nonatomic) CGFloat gridXOrigin;
@property (assign, nonatomic) CGFloat gridYOrigin;

@property (strong, nonatomic) NewEarthGlobals* theGlobals;

@property (nonatomic, strong) id <GridViewDelegate> myGridDelegate;

-(void) setDefaults;


@end

//
//  AppStatusView.h
//  New Earth
//
//  Created by Scott Alexander on 1/15/17.
//  Copyright © 2017 Big Dog Tools. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppStatusBarView.h"

@class AppStatusView;


@protocol AppStatusDelegate

//-(CGPoint) statusBarLoc:(AppStatusView*) requestor;
//-(UIColor*) statusMyColor:(AppStatusView*) requestor;
-(UIScrollView*) statusScrollView:(AppStatusView*) requestor;

@end


@interface AppStatusView : UIView <AppStatusBarViewScrollDel>
{
    CGFloat myHeight;
    CGFloat myWidth;
    CGFloat myX;
    CGFloat myY;
    CGRect myRect; // rect to hold the status view bars
    CGPoint myLocOffset;
    CGFloat myLocZoomScale;
}

@property (nonatomic, strong) id <AppStatusDelegate> myAppStatusDel;
@property (nonatomic, strong) UIScrollView* myScroll;
@property (nonatomic, strong) id <AppStatusBarViewScrollDel> myAppStatusScrollDel;

//@property CGFloat newProduction; // either supply stockpile or new units under construction
//@property CGFloat barThickness; // thickness of the whole view
//@property CGFloat prodThickness; // thinner than barThickness ... half the width maybe
//@property CGFloat netSustain; // difference between consumption and production (positive good)

@property UIColor* unitTypeColor; // used to determine color and associated with unit type (NewTech)

@property CGPoint myPosition; // origin for the bar
@property CGRect myRect;
//@property CGRect barNew;
@property CGFloat myHeight;
@property CGFloat myWidth;
@property CGFloat myX;
@property CGFloat myY;

@end

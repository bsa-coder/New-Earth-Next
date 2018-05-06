//
//  AppStatusBarView.h
//  New Earth
//
//  Created by Scott Alexander on 1/15/17.
//  Copyright © 2017 Big Dog Tools. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "AppStatusItem.h"
#import "ItemEnums.h"

@class AppStatusBarView;

@protocol AppStatusBarViewDelegate

-(CGFloat) statItemProduce: (AppStatusBarView*) requestor; //AppStatusItem
-(CGFloat) statItemConsume: (AppStatusBarView*) requestor;
-(CGFloat) statItemNewProd: (AppStatusBarView*) requestor;
-(CGPoint) statItemBarLoc: (AppStatusBarView*) requestor;
-(UIColor*) statItemMyColor: (AppStatusBarView*) requestor;

@end

@protocol AppStatusBarViewScrollDel

-(UIScrollView*) statBarScrollView: (AppStatusBarView*) requestor;

@end

@interface AppStatusBarView : UIView
{
    CGFloat myHeight;
    CGFloat myWidth;
    CGFloat myX;
    CGFloat myY;
}

-(id) initAtPosition: (CGPoint) theLoc withSize: (CGRect) theRect withType: (UIColor*) myColor withLegend: (NSString*) myLegend layoutType: (int) theLayout;

//@property (nonatomic, strong) id <AppStatusItem> myDelegate;
@property (nonatomic, strong) id <AppStatusBarViewDelegate> myAppStatBarItemDel;
@property (nonatomic, strong) id <AppStatusBarViewScrollDel> myScrollDel;

@property CGFloat consumption; // from warehouse total use rate for resources
@property CGFloat production; // from warehouse total supply rate for resources
@property CGFloat newProduction; // either supply stockpile or new units under construction
// @property CGFloat barThickness; // thickness of the whole view
// @property CGFloat prodThickness; // thinner than barThickness ... half the width maybe
// @property CGFloat netSustain; // difference between consumption and production (positive good)
@property (copy) NSString* barLegend;

@property UIColor* itemTypeColor; // used to determine color and associated with unit type (NewTech)

@property CGPoint barPosition; // origin for the bar
@property CGRect myArea;
@property CGRect barNew;
@property CGRect barConsume;
@property CGRect barProduce;
    @property CGRect recLabel;
    
@property UILabel* yourLabel;
@property int layout;

@property UIView* barConsumeView;
@property UIView* barProduceView;
@property UIView* barNewView;
@property UIView* barLegendView;

@end

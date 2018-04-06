//
//  AppStatusBarView.m
//  New Earth
//
//  Created by Scott Alexander on 1/15/17.
//  Copyright © 2017 Big Dog Tools. All rights reserved.
//

#import "AppStatusBarView.h"

@implementation AppStatusBarView
// @synthesize barThickness, consumption, production, prodThickness, newProduction, netSustain, itemTypeColor, barPosition;
@synthesize consumption, production, newProduction, itemTypeColor, barPosition;
@synthesize barNew, barConsume, barProduce, myArea, barLegend, yourLabel, layout, myAppStatBarItemDel; //, myAppStatBarItemVCDel;
@synthesize barConsumeView, barNewView, barProduceView, barLegendView, myScrollDel;

-(id) initAtPosition: (CGPoint) theLoc withSize: (CGRect) theRect withType: (UIColor*) myColor withLegend: (NSString*) myLegend layoutType: (int) theLayout
{
    self = [super init];
    if (self)
    {
        consumption = 0.0f;
        production = 0.0f;
        newProduction = 0.0f;
        
        if (myAppStatBarItemDel) {
            consumption = [myAppStatBarItemDel statItemConsume:self];
            production = [myAppStatBarItemDel statItemProduce:self];
            newProduction = [myAppStatBarItemDel statItemNewProd:self];
        }
        
        barPosition = theLoc;
        myX = barPosition.x;
        myY = barPosition.y;
        
        myArea = theRect;
        myHeight = myArea.size.height;
        myWidth = myArea.size.width;
        
        itemTypeColor = myColor;
        self.backgroundColor = itemTypeColor;
        
        self.frame = CGRectMake(myX, myY, myWidth, myHeight);
        if (consumption == 0) { consumption = 0.1f; }
        layout = theLayout;
        
        barLegend = myLegend;
        
        switch (theLayout) {
            case 0: [self horizontalBarNarrowTake:consumption Make:production Bake:newProduction atScale:1]; break;
            case 1: [self horizontalBarWideTake:consumption Make:production Bake:newProduction atScale:1]; break;
            case 2: [self verticalBarTake:consumption Make:production Bake:newProduction atScale:1]; break;
            default: break;
        }
        
        if (!barConsumeView) { barConsumeView = [[UIView alloc] initWithFrame:barConsume]; }
        else { barConsumeView.frame = barConsume; }
        
        if (!barProduceView) { barProduceView = [[UIView alloc] initWithFrame:barProduce]; }
        else { barProduceView.frame = barProduce; }
        
        if (!barNewView) { barNewView = [[UIView alloc] initWithFrame:barNew]; }
        else { barNewView.frame = barNew; }

        [self addSubview:barConsumeView];
        [self addSubview:barProduceView];
        [self addSubview:barNewView];
//        [self addSubview:barLegendView];
        
    }
    
    return self;
}

-(void) horizontalBarWideTake: (CGFloat) takeRate Make: (CGFloat) makeRate Bake: (CGFloat) bakeRate atScale: (CGFloat) theScale
{
    CGFloat wideWidth = myWidth / 2.0f;
    
    barConsume = CGRectMake(myWidth / 2.0f, myHeight / 2.0f, wideWidth * 0.4f, myHeight / 2.0f);
    barProduce = CGRectMake(myWidth / 2.0f, 0.0f, wideWidth * 0.4f * (makeRate / takeRate > 2 ? 2 : makeRate / takeRate), myHeight / 2.0f);
    barNew = CGRectMake(myWidth / 2.0f + myWidth * 0.4f * (makeRate / takeRate > 2 ? 2 : makeRate / takeRate), 0.0, wideWidth * 0.2 * (bakeRate / takeRate > 1 ? 1 : bakeRate / takeRate), myHeight / 2.0f);

    UIFont* valueFont;
    CGFloat defaultFontSize = (int)(15.0 / theScale);
    if (defaultFontSize < 15.0) {
        valueFont = [UIFont systemFontOfSize: (int)(8.0 / (theScale / 2.0))];
    } else {
        valueFont = [UIFont systemFontOfSize: (int)(15.0 / theScale)];
    }
    [barLegend drawAtPoint:CGPointMake(2.0f, 0.0f)
            withAttributes:@{NSFontAttributeName: valueFont,
                             NSForegroundColorAttributeName: [UIColor blackColor]}];
    yourLabel.adjustsFontForContentSizeCategory = YES;
    yourLabel.text = barLegend;
}

-(void) horizontalBarNarrowTake: (CGFloat) takeRate Make: (CGFloat) makeRate Bake: (CGFloat) bakeRate atScale: (CGFloat) theScale
{
    barConsume = CGRectMake(0.0f, myHeight * 0.75f, myWidth * 0.4f, myHeight / 4.0f);
    barProduce = CGRectMake(0.0f, myHeight / 2.0f, myWidth * 0.4f * (makeRate / takeRate > 2 ? 2 : makeRate / takeRate), myHeight / 4.0f);
    barNew = CGRectMake(myWidth * 0.4f * (makeRate / takeRate > 2 ? 2 : makeRate / takeRate), myHeight / 2.0f, myWidth * 0.2 * (bakeRate / takeRate > 1 ? 1 : bakeRate / takeRate), myHeight / 4.0f);

// this text displayed on main screen and map (and so double vision on map, hmmm)
    if (myAppStatBarItemDel) {
        
        UIScrollView* myScroll;
        if (myScrollDel) {
            myScroll = [myScrollDel statBarScrollView:self];
        }
        
//        -(UIScrollView*) statusScrollView:(AppStatusView*) requestor {return theScrollView;}
        if (!myScroll) {
            UIFont* valueFont = [UIFont systemFontOfSize: 20];
            if (theScale > 2.5) {
                valueFont = [UIFont systemFontOfSize: 10];
            } else {
                valueFont = [UIFont systemFontOfSize: 20];
            }
            [barLegend drawAtPoint:CGPointMake(2.0f, 0.0f)
                    withAttributes:@{NSFontAttributeName: valueFont, NSForegroundColorAttributeName: [UIColor orangeColor]}];
        } else {
            if (myScroll.zoomScale == 1.0) {
                UIFont* valueFont = [UIFont systemFontOfSize: 20];
                [barLegend drawAtPoint:CGPointMake(2.0f, 0.0f)
                        withAttributes:@{NSFontAttributeName: valueFont, NSForegroundColorAttributeName: [UIColor blackColor]}];
            }
            else {
                UIFont* valueFont;
                CGFloat defaultFontSize = (int)(15.0 / myScroll.zoomScale);
                if (defaultFontSize < 15.0) {
                    valueFont = [UIFont systemFontOfSize: (int)(8.0 / (myScroll.zoomScale / 2.0))];
                } else {
                    valueFont = [UIFont systemFontOfSize: (int)(15.0 / myScroll.zoomScale)];
                }
//                NSLog(@"font size = %f", valueFont.pointSize);
                [barLegend drawAtPoint:CGPointMake(2.0f, 0.0f)
                        withAttributes:@{NSFontAttributeName: valueFont, NSForegroundColorAttributeName: [UIColor blackColor]}];
                
//                CGRect tempRect = [self scaleTheFixedFrame:self.frame usingView:myScroll.zoomScale];
//                self.frame = tempRect;
//                barConsume = [self scaleTheFixedFrame:barConsume usingView:myScroll.zoomScale];
//                barProduce = [self scaleTheFixedFrame:barProduce usingView:myScroll.zoomScale];
//                barNew = [self scaleTheFixedFrame:barNew usingView:myScroll.zoomScale];
            }
        }
    }
    else {
        UIFont* valueFont;
        CGFloat defaultFontSize = (int)(15.0 / theScale);
        if (defaultFontSize < 15.0) {
            valueFont = [UIFont systemFontOfSize: (int)(8.0 / (theScale / 2.0))];
        } else {
            valueFont = [UIFont systemFontOfSize: (int)(15.0 / theScale)];
        }
        [barLegend drawAtPoint:CGPointMake(2.0f, 0.0f)
                withAttributes:@{NSFontAttributeName: valueFont, NSForegroundColorAttributeName: [UIColor yellowColor]}];
    }
}

-(void) verticalBarTake: (CGFloat) takeRate Make: (CGFloat) makeRate Bake: (CGFloat) bakeRate atScale: (CGFloat) theScale
{
    barConsume = CGRectMake(0.0, myHeight * 0.4, myWidth, myHeight * 0.4);
    barConsume = [self scaleTheFixedFrame:barConsume usingView:theScale];
    barProduce = CGRectMake(myWidth / 4.0, myHeight / 4.0, myWidth * 0.5, myHeight * 0.4 * (makeRate / takeRate > 2 ? 2 : makeRate / takeRate));
    barProduce = [self scaleTheFixedFrame:barProduce usingView:theScale];
    barNew = CGRectMake(0.0, myHeight * 0.8, myWidth, myHeight * 0.2 * (bakeRate / takeRate > 1 ? 1 : bakeRate / takeRate));
    barNew = [self scaleTheFixedFrame:barNew usingView:theScale];
    UIFont* valueFont = [UIFont systemFontOfSize: 10];
    [barLegend drawAtPoint:barConsume.origin
            withAttributes:@{NSFontAttributeName: valueFont,
                             NSForegroundColorAttributeName: [UIColor blackColor]}];
}

-(void) updateLayoutAtScale: (CGFloat) theViewScale
{
    CGFloat locConsume = ([self.myAppStatBarItemDel statItemConsume:self] == 0.0f ? 0.01f : [self.myAppStatBarItemDel statItemConsume:self]);
    CGFloat locProduce = [self.myAppStatBarItemDel statItemProduce:self];
    CGFloat locNewProd = [self.myAppStatBarItemDel statItemNewProd:self];
    
    switch (layout) {
        case 0:
            [self horizontalBarNarrowTake:locConsume Make:locProduce Bake:locNewProd atScale:theViewScale];
            break;
            
        case 1:
            [self horizontalBarWideTake:locConsume Make:locProduce Bake:locNewProd atScale:theViewScale];
            break;
            
        case 2:
            [self verticalBarTake:locConsume Make:locProduce Bake:locNewProd atScale:theViewScale];
            break;
            
        default:
            break;
    }
}


- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    const CGFloat* aColorComp;
    
    if (myAppStatBarItemDel) {
        
        CGColorRef aColor = (__bridge CGColorRef)(itemTypeColor);
        aColorComp = CGColorGetComponents(aColor);
        
        UIScrollView* myScroll = [myScrollDel statBarScrollView:self];
        myHeight = self.frame.size.height;
        myWidth = self.frame.size.width;
        myX = self.frame.origin.x;
        myY = self.frame.origin.y;
        
        consumption = [myAppStatBarItemDel statItemConsume:self];
        if (consumption==0) { consumption = 0.01; }

        [self updateLayoutAtScale:myScroll.zoomScale];
//        myScroll.zoomScale = 1.0;
        if (!barConsumeView) { barConsumeView = [[UIView alloc] initWithFrame:barConsume]; }
        else { barConsumeView.frame = barConsume; }
        
        if (!barProduceView) { barProduceView = [[UIView alloc] initWithFrame:barProduce]; }
        else { barProduceView.frame = barProduce; }
        
        if (!barNewView) { barNewView = [[UIView alloc] initWithFrame:barNew]; }
        else { barNewView.frame = barNew; }
        
        UIFont* valueFont2 = [UIFont systemFontOfSize: 20 / myScroll.zoomScale];
//        [barLegend drawAtPoint:CGPointMake(2.0f, 0.0f)
//                withAttributes:@{NSFontAttributeName: valueFont2, NSForegroundColorAttributeName: [UIColor blueColor]}];

        /*
        UIFont* valueFont = [UIFont systemFontOfSize: 12 / myScroll.zoomScale];
        NSString* myString = barLegend;
        
        if(!yourLabel) {
            yourLabel = [[UILabel alloc] initWithFrame:barConsumeView.frame];
            
            [yourLabel setTextColor:[UIColor blackColor]];
            [yourLabel setBackgroundColor:[UIColor clearColor]];
            [yourLabel setFont: valueFont];
            [yourLabel setText:myString];
            [barConsumeView addSubview:yourLabel];
            [yourLabel setCenter:barConsumeView.center];
        }
        
        if (!barLegendView)
        {
            barLegendView = [[UIView alloc] initWithFrame:[self scaleTheFixedFrame:barConsume usingView:myScroll]];
            [myString drawAtPoint:CGPointMake(1 / myScroll.zoomScale, 1 / myScroll.zoomScale)
                   withAttributes:@{NSFontAttributeName: valueFont,
                                    NSForegroundColorAttributeName: [UIColor blackColor]}];
            
        }
        else {
            [myString drawAtPoint:CGPointMake(1 / myScroll.zoomScale, 1 / myScroll.zoomScale)
                   withAttributes:@{NSFontAttributeName: valueFont,
                                    NSForegroundColorAttributeName: [UIColor whiteColor]}];
        }
        
         
        [self addSubview:barConsumeView];
        [self addSubview:barProduceView];
        [self addSubview:barNewView];
        [self addSubview:barLegendView];
         */
        
//        UIColor* myColorBkgd = [UIColor colorWithRed:aColorComp[0] green:aColorComp[1] blue:aColorComp[2] alpha:0.5];
//        UIColor* myColorCons = [UIColor colorWithRed:aColorComp[0]/2.0 green:aColorComp[1]/2.0 blue:aColorComp[2]/2.0 alpha:1.0];
        
//        self.backgroundColor = myColorBkgd;

        //UIColor* myColorProd = [UIColor colorWithRed:aColorComp[0] green:aColorComp[1] blue:aColorComp[2] alpha:aColorComp[3]];
        UIColor* myColorNew = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.5];
        
        if ((consumption > [self.myAppStatBarItemDel statItemProduce:self]) && (consumption != 0.01)) {
            barConsumeView.backgroundColor = [UIColor redColor];
        } else {
            barConsumeView.backgroundColor = [UIColor greenColor];
        }
        
        barProduceView.backgroundColor = [UIColor whiteColor];
        barNewView.backgroundColor = myColorNew;
        
//        self.frame = [self scaleTheFixedFrame:self.frame usingView:myScroll.zoomScale];
//        [self updateLayoutAtScale:myScroll.zoomScale];
        
    }
    
//    self.alpha = 1.0;
    
}
/*
-(void) updateBarsAtScale: (CGFloat) theScale consume: (CGFloat)newTake produce: (CGFloat) newMake newProd: (CGFloat) newBuild layout: (int) orientation
{
    switch (orientation) {
        case 0:
            [self horizontalBarNarrowTake: consumption Make: production Bake: newProduction atScale: theScale];
            break;
        case 1:
            [self horizontalBarWideTake:consumption Make: production Bake: newProduction atScale: theScale];
            break;
        case 2:
            [self verticalBarTake: newTake Make: newMake Bake: newBuild atScale: theScale];
            break;
            
        default:
            break;
    }
    
    barConsumeView.frame = [self scaleTheFixedFrame:barConsume usingView:theScale];
    barProduceView.frame = [self scaleTheFixedFrame:barProduce usingView:theScale];
    barNewView.frame = [self scaleTheFixedFrame:barNew usingView:theScale];
    
    if (production < consumption) {
        barConsumeView.backgroundColor = [UIColor redColor];
    } else {
        barConsumeView.backgroundColor = [UIColor greenColor];
    }

}
*/

-(CGRect) scaleTheFixedFrame: (CGRect) aArea usingView: (CGFloat) theScale
{
    if (theScale == 0) { theScale = 1; }
    CGFloat locX = aArea.origin.x; // + scrollView.contentOffset.x;
    CGFloat locY = aArea.origin.y; // + scrollView.contentOffset.y;
    
    CGRect myRect = CGRectMake( locX / theScale, locY / theScale,
                               CGRectGetWidth(aArea) / theScale,
                               CGRectGetHeight(aArea) / theScale);
    
    return myRect; //fixedFrame;
}

-(CGRect) scaleTheFixedFrameOrig: (CGRect) aArea usingView: (UIScrollView*) scrollView
{
    CGFloat theScale = scrollView.zoomScale; // * scrollView.zoomScale;
    if (theScale == 0) { theScale = 1; }
    CGFloat locX = aArea.origin.x; // + scrollView.contentOffset.x;
    CGFloat locY = aArea.origin.y; // + scrollView.contentOffset.y;
    
    CGRect myRect = CGRectMake( locX / theScale, locY / theScale,
                               CGRectGetWidth(aArea) / theScale,
                               CGRectGetHeight(aArea) / theScale);
    
    return myRect; //fixedFrame;
}


@end

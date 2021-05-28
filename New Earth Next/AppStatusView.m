//
//  AppStatusView.m
//  New Earth
//
//  Created by Scott Alexander on 1/15/17.
//  Copyright © 2017 Big Dog Tools. All rights reserved.
//

#import "AppStatusView.h"

@implementation AppStatusView
@synthesize myAppStatusDel;
@synthesize myRect, myPosition, myX, myY, myWidth, myHeight, myScroll;


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
//    [self scaleTheFixedFrame:[myAppStatusDel statusScrollView:self]];
    myScroll = [myAppStatusDel statusScrollView:self];
    
    if (myScroll.isZooming) {
        myLocOffset = myScroll.contentOffset;
        myLocZoomScale = myScroll.zoomScale;
    }
    else {
        myLocOffset = CGPointMake(0, 0);
        myLocZoomScale = 1.0;
    }
    if (myScroll) {
        [self placeMeUsingRect:myRect atPoint:myPosition atScale:myScroll];
    }
}

-(void) scaleTheFixedFrame:(UIScrollView*)scrollView
{
    CGPoint myOrigin = CGPointMake(10.0, [self window].frame.size.height-50.0-10.0);
    CGFloat myX2 = (myOrigin.x + scrollView.contentOffset.x);
    CGFloat myY2 = (myOrigin.y + scrollView.contentOffset.y);
    CGPoint myPoint = CGPointMake(myX2, myY2);
    
    CGRect myRectLoc = CGRectMake( myPoint.x / scrollView.zoomScale, myPoint.y / scrollView.zoomScale,
                               ([self window].frame.size.width - 20.0) / scrollView.zoomScale, 50 / scrollView.zoomScale );
    
    self.frame = myRectLoc;
    
    for (int i = 0; i < [self.subviews count]; i++) { [self.subviews[i] setNeedsDisplay]; }
}

-(void) placeMeUsingRectNew:(CGRect) theRect atPoint: (CGPoint) theLoc atScale: (CGFloat) theScale atOffset: (CGPoint) theOffset
{
    if (theScale != 1.0) {
        CGPoint myOrigin = theLoc; // CGPointMake(10.0, [self window].frame.size.height-50.0-10.0);
        CGFloat myX2 = (myOrigin.x + theOffset.x);
        CGFloat myY2 = (myOrigin.y + theOffset.y);
        CGPoint myPoint = CGPointMake(myX2, myY2);
        
        CGRect scaleRect = CGRectMake( myPoint.x / theScale, myPoint.y / theScale,
                                      ([self window].frame.size.width - 20.0) / theScale, 50 / theScale );
        
        self.frame = scaleRect;
        
    }
    
    __unused int tempCount = (int)[self.subviews count];
    
    for (int i = 0; i < [self.subviews count]; i++) { [self.subviews[i] setNeedsDisplay]; }
    
}

-(UIScrollView*) statBarScrollView:(AppStatusBarView*) requestor {return myScroll;}

-(void) placeMeUsingRect:(CGRect) theRect atPoint: (CGPoint) theLoc atScale: (UIScrollView*)scrollView
{
    CGRect scaleRect;
    
    if (scrollView) {
        CGPoint myOrigin = theLoc; // CGPointMake(10.0, [self window].frame.size.height-50.0-10.0);
        CGFloat myX2 = (myOrigin.x + scrollView.contentOffset.x);
        CGFloat myY2 = (myOrigin.y + scrollView.contentOffset.y);
        CGPoint myPoint = CGPointMake(myX2, myY2);
        
        scaleRect = CGRectMake( myPoint.x / scrollView.zoomScale, myPoint.y / scrollView.zoomScale,
                                      ([self window].frame.size.width - 20.0) / scrollView.zoomScale, 50 / scrollView.zoomScale );
        
        self.frame = scaleRect;
        
    }
    
    __unused int tempCount = (int)[self.subviews count];
    
    CGFloat rawViewWidth = [self window].frame.size.width - 20.0;
    CGFloat rawViewHeight = 50.0;
    CGFloat rawViewOffset = 5.0;
    
    CGFloat statViewHeight = (rawViewHeight - 10.0) / scrollView.zoomScale;
    CGFloat statViewOffsetX = rawViewOffset / scrollView.zoomScale;
    CGFloat statViewOffsetY = rawViewOffset / scrollView.zoomScale;
    CGFloat statViewWidth = (rawViewWidth - (tempCount + 1 ) * rawViewOffset) / tempCount / scrollView.zoomScale;
    
    for (int i = 0; i < [self.subviews count]; i++) {
        self.subviews[i].frame = CGRectMake(statViewOffsetX + (statViewOffsetX + statViewWidth) * i, statViewOffsetY, statViewWidth, statViewHeight);
        [self.subviews[i] setNeedsDisplay];
    }
    
//    if (!scrollView.isZooming) { scrollView.zoomScale = 1.0; }
}

-(id)init
{
    self = [super init];
    if (self) {

        const CGFloat* aColorComp;
        CGColorRef aColor = (__bridge CGColorRef)([UIColor brownColor]);// [itemTypeColor CGColor];
        aColorComp = CGColorGetComponents(aColor);
        UIColor* myBkgdColor = [UIColor colorWithRed:aColorComp[0] green:aColorComp[1] blue:aColorComp[2] alpha:0.5];
        
        self.alpha = 1.0;
        self.backgroundColor = myBkgdColor;
        self.myRect = CGRectMake(0.0, 0.0, 40.0, self.superview.frame.size.height);
        self.myPosition = CGPointMake(10.0, self.superview.frame.size.width / 2.0f);
        self.myY = self.myPosition.y;
        self.myX = self.myPosition.x;
        self.myHeight = myRect.size.height;
        self.myWidth = myRect.size.width;
        [self setCenter:self.superview.center];
    }
    return self;
}


@end

//
//  TileItem.m
//  New Earth
//
//  Created by Scott Alexander on 5/22/17.
//  Copyright © 2017 Big Dog Tools. All rights reserved.
//
/*
 this is a base object used to show a resource or toxin on the map
 */

#import "TileItem.h"

@implementation TileItem
@synthesize itemIcon, itemValue, itemLocation, description, imageIcon, itemLabel, itemOutline;

-(id) init
{
    return [self initAtLocation:CGPointMake(0, 0) ofType:nil withStartingValue:0];
}

-(instancetype) initAtLocation: (CGPoint) aPoint ofType: (UIImage*) aIcon withStartingValue: (NSInteger) aValue
{
    itemLocation = aPoint;
    itemValue = aValue;
    imageIcon = aIcon;
    //    CGSize tempSize = imageIcon.size;
    
    //    CGFloat theDrawScale = 1.0;
    
    // **** position of item
    
    CGRect theOutline = CGRectMake(aPoint.x - 25 / 2.0, aPoint.y - 25 / 2.0, 25.0, 25.0);
    itemOutline = [[UIView alloc] initWithFrame: theOutline];
    
    // **** position of icon
    itemIcon = [[UIImageView alloc] initWithImage: imageIcon];
    itemIcon.frame = theOutline;
    //    itemIcon.center = aPoint;
    //    CGPoint theCenter = itemOutline.center;
    //    CGPoint theOrigin = itemOutline.frame.origin;
    
    // **** position of label
    UIFont* valueFont = [UIFont systemFontOfSize: 10];
    NSString* myString = [NSString stringWithFormat:@"%0.0ld", (long)itemValue];
    
    if (!itemLabel) {itemLabel = [[UILabel alloc] initWithFrame:theOutline];}
    
    [itemLabel setTextColor: [UIColor greenColor]];
    [itemLabel setBackgroundColor: [UIColor clearColor]];
//[itemLabel setBackgroundColor: [UIColor whiteColor]];
    [itemLabel setFont: valueFont];
    [itemLabel setText: myString];
    [itemLabel setTextAlignment:NSTextAlignmentCenter];
    [itemLabel setCenter: CGPointMake(itemOutline.frame.origin.x + itemIcon.frame.size.width, itemOutline.frame.origin.y + itemIcon.frame.size.height)];
    
    __unused CGPoint labelOrigin = itemLabel.frame.origin;
    
    [itemOutline addSubview: itemIcon];
    [itemOutline addSubview:itemLabel];
    //    itemIcon.center = theCenter;
    itemIcon.center = CGPointMake(itemIcon.frame.size.width / 2.0, itemIcon.frame.size.height / 2.0);
    itemLabel.center = CGPointMake(itemIcon.frame.size.width, itemIcon.frame.size.height);
    
    return self;
}

-(instancetype) initSmallAtLocation: (CGPoint) aPoint ofType: (UIImage*) aIcon withStartingValue: (NSInteger) aValue
{
    itemLocation = aPoint;
    itemValue = aValue;
    imageIcon = aIcon;
    
    // **** position of item    
    CGRect theOutline = CGRectMake(aPoint.x - 25 / 4.0, aPoint.y - 25 / 4.0, 12.5, 12.5);
    itemOutline = [[UIView alloc] initWithFrame: theOutline];
    
    // **** position of icon
    itemIcon = [[UIImageView alloc] initWithImage: imageIcon];
    itemIcon.frame = theOutline;
    
    // **** position of label
    UIFont* valueFont = [UIFont systemFontOfSize: 7];
    NSString* myString = [NSString stringWithFormat:@"%0.0ld", (long)itemValue];
    
    if (!itemLabel) {itemLabel = [[UILabel alloc] initWithFrame:theOutline];}

    [itemLabel setTextColor: [UIColor blackColor]];
    [itemLabel setBackgroundColor: [UIColor clearColor]];
    [itemLabel setFont: valueFont];
    [itemLabel setText: myString];
    [itemLabel setTextAlignment:NSTextAlignmentCenter];
    [itemLabel setCenter: CGPointMake(itemOutline.frame.origin.x, itemOutline.frame.origin.y)];
    
    __unused CGPoint labelOrigin = itemLabel.frame.origin;
    
    [itemOutline addSubview: itemIcon];
    [itemOutline addSubview:itemLabel];
    //    itemIcon.center = theCenter;
    itemIcon.center = CGPointMake(itemIcon.frame.size.width / 4.0, itemIcon.frame.size.height / 4.0);
    itemLabel.center = CGPointMake(itemIcon.center.x + 4.0, itemIcon.center.y + 4.0);
    
    return self;
}

-(void) changeMyIcon: (UIImage*) newIcon { [itemIcon setImage:newIcon]; }

-(void) showMeAtLoc:(CGPoint) theLoc atScale:(CGFloat) theDrawScale inContext: (CGContextRef) context
{
    __unused CGFloat tempX = theLoc.x;
    __unused CGFloat tempY = theLoc.y;
    
//    CGRect theRectToShow = CGRectMake(tempX, tempY, itemOutline.frame.size.width/theDrawScale, itemOutline.frame.size.height/theDrawScale);
//    CGRect theRectToShow = CGRectMake(
//                                      tempX - 25 / 2.0f,
//                                      tempY - 25 / 2.0f,
//                                      (25 + 25 / 2.0f)*theDrawScale,
//                                      (25 + 25 / 2.0f)*theDrawScale
//                                      );
    
//    CGRect bigRect = CGRectMake(0, 0, 25, 25);
//    CGRect theRectToShow = CGRectMake(tempX-(bigRect.size.width/2.0f)*theDrawScale, tempY-(bigRect.size.height/2.0f)*theDrawScale, (bigRect.size.width)*theDrawScale, (bigRect.size.height)*theDrawScale);

//    UIFont* valueFont = [UIFont systemFontOfSize: 30 / theDrawScale];
    NSString* myString = [NSString stringWithFormat:@"%0.0ld", (long)itemValue];

/*
    if(!itemLabel) {
        CGRect tempThing = CGRectMake(
                                      itemOutline.frame.size.width,
                                      itemOutline.frame.size.height,
                                      itemOutline.frame.size.width,
                                      itemOutline.frame.size.height);
        
        itemLabel = [[UILabel alloc] initWithFrame:tempThing];
        
        [itemLabel setTextColor: [UIColor greenColor]];
        [itemLabel setBackgroundColor: [UIColor clearColor]];
        [itemLabel setBackgroundColor: [UIColor whiteColor]];
        [itemLabel setFont: valueFont];
        [itemLabel setText: myString];
        [itemLabel setCenter:CGPointMake(itemOutline.center.x + itemOutline.frame.size.width, itemOutline.center.y)];
//        [itemLabel setCenter: itemOutline.center];
        
        [itemOutline addSubview: itemLabel];
    }
    else
    {
 */
    itemOutline.contentMode = UIViewContentModeScaleAspectFit;
    [itemLabel setText: myString];
}

-(void) showMyItemsAtScale:(CGFloat) theDrawScale inContext:(CGContextRef) context
{

    UIFont* valueFont = [UIFont systemFontOfSize: 10 / theDrawScale];
    NSString* myString = @"99";
    myString = [NSString stringWithFormat:@"%0.0ld", (long)itemValue];
    
    if(!itemLabel) {
        CGRect tempThing = CGRectMake(itemOutline.center.x, itemOutline.center.y, itemOutline.frame.size.width, itemOutline.frame.size.height);
        itemLabel = [[UILabel alloc] initWithFrame:tempThing];
        
        [itemLabel setTextColor:[UIColor blackColor]];
        [itemLabel setBackgroundColor:[UIColor clearColor]];
        [itemLabel setBackgroundColor:[UIColor whiteColor]];
        [itemLabel setFont: valueFont];
        [itemLabel setText:myString];
        [itemLabel setCenter:itemOutline.center];
        
        [itemOutline addSubview:itemLabel];
    }
    else
    {
        [itemLabel setText:myString];
        [itemLabel setCenter:itemOutline.center];
    }
}

-(void) printMe
{
    NSLog(@"print status of tile");
}

@end

//
//  TileItem.h
//  New Earth
//
//  Created by Scott Alexander on 5/22/17.
//  Copyright © 2017 Big Dog Tools. All rights reserved.
//
// this class represents resources, etc. present in each tile

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface TileItem : NSObject
{
    CGPoint itemLocation; // not sure if top left or center
    UIImageView* itemIcon; // icon image
    NSInteger itemValue; // unit of resource that each icon equals (max value) may be linked to how visible
}

@property NSInteger itemValue;
//@property CGImageRef itemIcon;
@property CGPoint itemLocation;
@property UILabel* itemLabel;
@property UIImage* imageIcon;
@property UIImageView* itemIcon;
@property UIView* itemOutline;


-(instancetype) initAtLocation: (CGPoint) aPoint ofType: (UIImage*) aType withStartingValue: (NSInteger) aValue;
-(instancetype) initSmallAtLocation: (CGPoint) aPoint ofType: (UIImage*) aIcon withStartingValue: (NSInteger) aValue;
//-(void) showMeAtScale:(CGFloat) theDrawScale inContext: (CGContextRef) context;
-(void) showMeAtLoc:(CGPoint) theLoc atScale:(CGFloat) theDrawScale inContext: (CGContextRef) context;
-(void) showMyItemsAtScale:(CGFloat) theDrawScale inContext:(CGContextRef) context;
-(void) printMe;
-(void) changeMyIcon: (UIImage*) newIcon;
//-(void) showMe: (UIImage*) myIcon atScale:(CGFloat) theDrawScale inContext: (CGContextRef) context;


@end

//
//  StatusRoom.h
//  New Earth
//
//  Created by Scott Alexander on 6/15/17.
//  Copyright © 2017 Big Dog Tools. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SceneKit/SceneKit.h>
#import "AppStatusView.h"

@class UnitInventory;

@interface StatusRoom : UIView
{
    AppStatusView* myStatusView;
}

@property AppStatusView* myStatusView;
@property (strong, nonatomic) UnitInventory* unitInventory;

@end

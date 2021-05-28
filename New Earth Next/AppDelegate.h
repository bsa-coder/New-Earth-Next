//
//  AppDelegate.h
//  New Earth Next
//
//  Created by Scott Alexander on 3/18/18.
//  Copyright © 2018 Big Dog Tools. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GameInit.h"

// message to update GUI
//extern NSString* const kSetUpdateNotification;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (retain) GameInit* gi;

@end


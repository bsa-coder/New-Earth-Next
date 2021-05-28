//
//  ModelController.h
//  New Earth Next
//
//  Created by Scott Alexander on 3/18/18.
//  Copyright © 2018 Big Dog Tools. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DataViewController;

@interface ModelController : NSObject <UIPageViewControllerDataSource>

- (DataViewController *)viewControllerAtIndex:(NSUInteger)index storyboard:(UIStoryboard *)storyboard;
- (NSUInteger)indexOfViewController:(DataViewController *)viewController;

@end


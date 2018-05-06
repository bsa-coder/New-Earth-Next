//
//  GameView.m
//  New Earth
//
//  Created by Scott Alexander on 12/12/16.
//  Copyright © 2016 Big Dog Tools. All rights reserved.
//

#import "GameView.h"

@implementation GameView
@synthesize myGameViewDelegate;
//@synthesize theGameScale, startNewGameButton, resumeGameButton;
@synthesize theGameScale;

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    
    self.contentMode = UIViewContentModeRedraw;
    self.opaque = NO;
    self.backgroundColor = [UIColor clearColor];
    
    
}

@end

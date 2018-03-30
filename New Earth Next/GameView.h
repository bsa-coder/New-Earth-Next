//
//  GameView.h
//  New Earth
//
//  Created by Scott Alexander on 12/12/16.
//  Copyright © 2016 Big Dog Tools. All rights reserved.
//
//  File used to hold subviews (so they all scale together using the scroll view

#import <UIKit/UIKit.h>

@class GameView;

@protocol GameViewDelegate

-(float) scaleForDrawingGame: (GameView*) requestor;
//-(CGPoint) placeForDrawing: (GameView*) requestor;

@end

@interface GameView : UIView
{
    CGPoint theUnitLocation;
    CGFloat theGameScale;
}

@property (nonatomic, strong) id <GameViewDelegate> myGameViewDelegate;
@property CGFloat theGameScale;

//@property UIButton* startNewGameButton;
//@property UIButton* resumeGameButton;

@end

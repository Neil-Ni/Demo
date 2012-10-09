//
//  ViewControllerWithFlip.h
//  Demo
//
//  Created by Tzu-Yang Ni on 10/10/12.
//  Copyright (c) 2012 Tzu-Yang Ni. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"

@class FlipView;
@class AnimationDelegate;

@interface ViewControllerWithFlip : ViewController <UIGestureRecognizerDelegate>{
    AnimationDelegate *animationDelegate;
    FlipView *flipView;
    UIPanGestureRecognizer *panRecognizer;
    int k;
}

@end

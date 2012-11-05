//
//  AnimationHelper.m
//  Demo
//
//  Created by Tzu-Yang Ni on 10/21/12.
//  Copyright (c) 2012 Tzu-Yang Ni. All rights reserved.
//

#import "AnimationHelper.h"
#import "UIView+Animation.h"

@implementation AnimationHelper

static int barHeight = 20;


+ (void)addLayerOn: (UIView *)view{
    UIView *LayerView = [[UIView alloc] initWithFrame:view.frame];
    LayerView.frame = view.frame;
    CGPoint point = CGPointMake(view.center.x, view.center.y-barHeight);
    LayerView.center = point;
    LayerView.backgroundColor = [UIColor blackColor];
    LayerView.tag = LAYER_TAG;
    [view sendSubviewToBack:LayerView];
    [view addSubviewWithFadeAnimation:LayerView duration:1.0 option:UIViewAnimationCurveEaseIn];
}


+ (void)removeLayerOn: (UIView *)view{
    UIView *LayerView = [view viewWithTag:LAYER_TAG];
    [view removeSubviewWithFadeAnimation:LayerView duration:1.0 option:UIViewAnimationCurveEaseOut];
}

+ (void)removeGradient: (UIView *)view{
    [UIView animateWithDuration:0.5 animations:^{
                view.alpha = 0.5;
                }
                completion:^(BOOL finished){
                    [[view.layer.sublayers objectAtIndex:0] removeFromSuperlayer];
                    view.alpha = 1;

    }];
//    [UIView animateWithDuration:0.5 animations:^{
//        view.alpha = 1.0;
//    }];

}

+ (void)addGradient: (UIView *)view{
    CAGradientLayer *bgLayer = [AnimationHelper blueGradient];
    bgLayer.name = @"gradient";
    CGRect frame = view.frame;
    frame.origin.y -= barHeight;
    bgLayer.frame = frame;
    [view.layer insertSublayer:bgLayer atIndex:0];
//
//    view.alpha = 1.0;
//    [UIView animateWithDuration:1.25 animations:^{
//        view.alpha = 0.7;
//    }];

}

+ (CAGradientLayer*) greyGradient {
    
    UIColor *colorOne = [UIColor colorWithWhite:0.9 alpha:1.0];
    UIColor *colorTwo = [UIColor colorWithHue:0.625 saturation:0.0 brightness:0.85 alpha:1.0];
    UIColor *colorThree     = [UIColor colorWithHue:0.625 saturation:0.0 brightness:0.7 alpha:1.0];
    UIColor *colorFour = [UIColor colorWithHue:0.625 saturation:0.0 brightness:0.4 alpha:1.0];
    
    NSArray *colors =  [NSArray arrayWithObjects:(id)colorOne.CGColor, colorTwo.CGColor, colorThree.CGColor, colorFour.CGColor, nil];
    
    NSNumber *stopOne = [NSNumber numberWithFloat:0.0];
    NSNumber *stopTwo = [NSNumber numberWithFloat:0.02];
    NSNumber *stopThree     = [NSNumber numberWithFloat:0.99];
    NSNumber *stopFour = [NSNumber numberWithFloat:1.0];
    
    NSArray *locations = [NSArray arrayWithObjects:stopOne, stopTwo, stopThree, stopFour, nil];
    CAGradientLayer *headerLayer = [CAGradientLayer layer];
    headerLayer.colors = colors;
    headerLayer.locations = locations;
    
    return headerLayer;
    
}

+ (CAGradientLayer*) blueGradient {
    
    UIColor *colorOne = [UIColor colorWithRed:(120/255.0) green:(135/255.0) blue:(150/255.0) alpha:1.0];
    UIColor *colorTwo = [UIColor colorWithRed:(57/255.0)  green:(79/255.0)  blue:(96/255.0)  alpha:1.0];
    
    NSArray *colors = [NSArray arrayWithObjects:(id)colorOne.CGColor, colorTwo.CGColor, nil];
    NSNumber *stopOne = [NSNumber numberWithFloat:0.0];
    NSNumber *stopTwo = [NSNumber numberWithFloat:1.0];
    
    NSArray *locations = [NSArray arrayWithObjects:stopOne, stopTwo, nil];
    
    CAGradientLayer *headerLayer = [CAGradientLayer layer];
    headerLayer.colors = colors;
    headerLayer.locations = locations;
    
    return headerLayer;
    
}

+(void)MoveLeft:(UIView *)view duration:(float) dur{
    CGPoint point = CGPointMake(view.center.x-250, view.center.y);
    [UIView animateWithDuration:dur delay:0.0 options:UIViewAnimationCurveLinear
                     animations:^{
                         view.center = point;
                     }
                     completion:nil];
}

+(void)MoveRight:(UIView *)view duration:(float) dur{
    CGPoint point = CGPointMake(view.center.x+250, view.center.y);
    [UIView animateWithDuration:dur delay:0.0 options:UIViewAnimationCurveLinear
                     animations:^{
                         view.center = point;
                     }
                     completion:nil];
}

+(void)MoveUp:(UIView *)view duration:(float) dur{
    CGPoint point = CGPointMake(view.center.x, view.center.y-200);
    [UIView animateWithDuration:dur delay:0.0 options:UIViewAnimationCurveLinear
                     animations:^{
                         view.center = point;
                     }
                     completion:nil];
}

+(void)MoveDown:(UIView *)view duration:(float) dur{
    CGPoint point = CGPointMake(view.center.x, view.center.y+200);
    [UIView animateWithDuration:dur delay:0.0 options:UIViewAnimationCurveLinear
                     animations:^{
                         view.center = point;
                     }
                     completion:nil];
}
+(void)transitLabel:(UILabel *)label withMessage:(NSString *)message{
    [UIView animateWithDuration:0.5 animations:^{label.alpha = 0;} completion:^(BOOL finished){
        label.text = message;
    }];
    [UIView animateWithDuration:0.5 animations:^{label.alpha = 1;}];

}

@end

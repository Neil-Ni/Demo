//
//  AnimationHelper.h
//  Demo
//
//  Created by Tzu-Yang Ni on 10/21/12.
//  Copyright (c) 2012 Tzu-Yang Ni. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h> 

#define LAYER_TAG 1
#define POPVIEW_TAG 1

@interface AnimationHelper : NSObject


+(CAGradientLayer*) greyGradient;
+(CAGradientLayer*) blueGradient;


+ (void)addGradient: (UIView *)view;
+ (void)removeGradient: (UIView *)view;

+ (void)addLayerOn: (UIView *)view;
+ (void)removeLayerOn: (UIView *)view;


+(void)MoveLeft:(UIView *)view duration:(float) dur;
+(void)MoveRight:(UIView *)view duration:(float) dur;
+(void)MoveUp:(UIView *)view duration:(float) dur;
+(void)MoveDown:(UIView *)view duration:(float) dur;


+(void)transitLabel:(UILabel *)label withMessage:(NSString *)message;

@end

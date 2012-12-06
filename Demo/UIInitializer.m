//
//  UIInitializer.m
//  Demo
//
//  Created by Tzu-Yang Ni on 11/26/12.
//  Copyright (c) 2012 Tzu-Yang Ni. All rights reserved.
//

#import "UIInitializer.h"

@implementation UIInitializer

+ (void)initializeContainView: (UIView *) ContainerView{
    if (([[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationLandscapeLeft) || ([[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationLandscapeRight)) {
        ContainerView.frame = CGRectMake(129, 18, 310, 284);
    } else {
        ContainerView.frame = CGRectMake(5, 142, 310, 284);
    }
    ContainerView.layer.borderWidth = 5.0;
    ContainerView.layer.masksToBounds = NO;
    ContainerView.layer.shadowColor = [UIColor whiteColor].CGColor;
    ContainerView.layer.cornerRadius = 10;
    ContainerView.layer.shadowOffset = CGSizeMake(1, 1);
    ContainerView.layer.shadowRadius = 5;
    ContainerView.layer.shadowOpacity = 0.8;
}


@end

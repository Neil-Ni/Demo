//
//  UIImage+scale.h
//  Demo
//
//  Created by Tzu-Yang Ni on 10/6/12.
//  Copyright (c) 2012 Tzu-Yang Ni. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (scale)

- (UIImage*)scaleToSize:(CGSize)size;
- (UIImage *)imageAtRect:(CGRect)rect;
- (UIImage *)imageByScalingProportionallyToMinimumSize:(CGSize)targetSize;
- (UIImage *)imageByScalingProportionallyToSize:(CGSize)targetSize;
- (UIImage *)imageByScalingToSize:(CGSize)targetSize;
- (UIImage *)imageRotatedByRadians:(CGFloat)radians;
- (UIImage *)imageRotatedByDegrees:(CGFloat)degrees;

@end

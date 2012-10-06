//
//  draggableImageView.h
//  Demo
//
//  Created by Tzu-Yang Ni on 9/29/12.
//  Copyright (c) 2012 Tzu-Yang Ni. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface draggableImageView : UIImageView <UIGestureRecognizerDelegate> {
    CGPoint startLocation;
}
@property CGFloat angle;
@end

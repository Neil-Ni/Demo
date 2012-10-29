//
//  draggableView.h
//  Demo
//
//  Created by Tzu-Yang Ni on 10/28/12.
//  Copyright (c) 2012 Tzu-Yang Ni. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface draggableView : UIView <UIGestureRecognizerDelegate> {
    CGPoint startLocation;
    NSDate *currentTime;
    float originalY;
}

@property CGFloat angle;
@property float velocity;
@property bool movingUP;

-(void)MoveWholeViewUpduration:(float) dur;
-(void)MoveWholeViewDownduration:(float) dur;

@end

//
//  draggableView.m
//  Demo
//
//  Created by Tzu-Yang Ni on 10/28/12.
//  Copyright (c) 2012 Tzu-Yang Ni. All rights reserved.
//

#import "draggableView.h"

@implementation draggableView
@synthesize angle, velocity;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        angle = 0;
        self.backgroundColor = [UIColor whiteColor];
        self.userInteractionEnabled = TRUE;
        self.movingUP = FALSE;
    }
    return self;
}


-(void)MoveWholeViewUpduration:(float) dur{
    CGRect frame = [self frame];
    float dY =  frame.size.height;
    
    CGPoint point = CGPointMake(self.center.x, self.center.y-dY);
    [UIView animateWithDuration:dur delay:0.0 options:UIViewAnimationCurveEaseInOut
                     animations:^{
                         self.center = point;
                     }
                     completion:nil];

}
-(void)MoveWholeViewDownduration:(float) dur{
    CGRect frame = [self frame];
    float dY =  frame.size.height;
    
    CGPoint point = CGPointMake(self.center.x, self.center.y+dY);
    [UIView animateWithDuration:dur delay:0.0 options:UIViewAnimationCurveEaseInOut
                     animations:^{
                         self.center = point;
                     }
                     completion:nil];
}


-(void)MoveUp:(UIView *)view duration:(float) dur{
    self.movingUP = TRUE;
    CGRect frame = [self frame];
    float dY =  -300 -(frame.origin.y - originalY);
    dur = 0.4;
    NSLog(@"%f, %@",dY, NSStringFromCGRect(frame));
    CGPoint point = CGPointMake(view.center.x, view.center.y+dY);
    [UIView animateWithDuration:dur delay:0.0 options:UIViewAnimationCurveEaseInOut
                     animations:^{
                        view.center = point;
//                         view.frame.size.height = -dY;
//                         CGRect frame = CGRectMake(0, dY, 320, 548-dY);
//                         view.frame = frame;
                     }
                     completion:^(BOOL finished){
                     }];
}

-(void)MoveDown:(UIView *)view duration:(float) dur{
    self.movingUP = FALSE;
    CGRect frame = [self frame];
    float dY =  frame.origin.y - originalY;

    CGPoint point = CGPointMake(view.center.x, view.center.y-dY);
    [UIView animateWithDuration:dur delay:0.0 options:UIViewAnimationCurveEaseInOut
                     animations:^{
                         view.center = point;
//                         CGRect frame = CGRectMake(0, 0, 320, 548);
//                         view.frame = frame;
                     }
                     completion:nil];
}

- (void) touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event {
    // Retrieve the touch point
    CGPoint pt = [[touches anyObject] locationInView:self];
    originalY = self.frame.origin.y;
    startLocation = pt;
    currentTime = [NSDate date];
    [[self superview] bringSubviewToFront:self];
}
- (void) touchesMoved:(NSSet*)touches withEvent:(UIEvent*)event {
    // Move relative to the original touch point
    
    CGPoint pt = [[touches anyObject] locationInView:self];
    CGRect frame = [self frame];
//    frame.origin.x += pt.x - startLocation.x;
    frame.origin.y += pt.y - startLocation.y;
    [self setFrame:frame];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    
    CGRect frame = [self frame];
    float dY = frame.origin.y - originalY;
    
    NSDate *secondDate = [NSDate date];
    NSTimeInterval secondsElapsed = [secondDate timeIntervalSinceDate:currentTime];
    
//    NSLog(@"%f %f",dY, secondsElapsed);
    
    if(secondsElapsed > 0.03){
        velocity = dY/(secondsElapsed);
        
        if(velocity < 0){
            if(dY < -60){
                [self MoveUp:self duration:secondsElapsed*2/3.];
            }else{
                [self MoveDown:self duration:secondsElapsed*2/3.];
            }
//            NSLog(@"%f %f",originalY, frame.origin.y);
        }else{
            originalY = 0;
            [self MoveDown:self duration:0.3];
        }

    }
}




@end

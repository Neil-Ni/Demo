//
//  draggableImageView.m
//  Demo
//
//  Created by Tzu-Yang Ni on 9/29/12.
//  Copyright (c) 2012 Tzu-Yang Ni. All rights reserved.
//

#import "draggableImageView.h"

#define MINWidth 50.0
#define MINHeight 75.0

@implementation draggableImageView
@synthesize angle;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        angle = 0;
        // Initialization code
    }
    
//    UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panDetected:)];
//    [self addGestureRecognizer:panRecognizer];
    UIPinchGestureRecognizer *pinchRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchDetected:)];
    [self addGestureRecognizer:pinchRecognizer];
    UIRotationGestureRecognizer *rotationRecognizer = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(rotationDetected:)];
    [self addGestureRecognizer:rotationRecognizer];
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDetected:)];
    tapRecognizer.numberOfTapsRequired = 2;
    [self addGestureRecognizer:tapRecognizer];
    
//    panRecognizer.delegate = self;
    pinchRecognizer.delegate = self;
    rotationRecognizer.delegate = self;
    
    return self;
}
//- (void)panDetected:(UIPanGestureRecognizer *)panRecognizer
//{
//    CGPoint translation = [panRecognizer translationInView:[self superview]];
//    CGPoint imageViewPosition = self.center;
//    imageViewPosition.x += translation.x;
//    imageViewPosition.y += translation.y;
//    
//    self.center = imageViewPosition;
//    [panRecognizer setTranslation:CGPointZero inView:[self superview]];
//}

- (void)pinchDetected:(UIPinchGestureRecognizer *)pinchRecognizer
{
    CGFloat scale = pinchRecognizer.scale;
    if(self.frame.size.height > MINHeight && self.frame.size.width > MINWidth)
        self.transform = CGAffineTransformScale(self.transform, scale, scale);
    
    pinchRecognizer.scale = 1.0;
}

- (void)rotationDetected:(UIRotationGestureRecognizer *)rotationRecognizer
{
    CGFloat ANGLE = rotationRecognizer.rotation;
    if(self.frame.size.height > MINHeight && self.frame.size.width > MINWidth){
        self.transform = CGAffineTransformRotate(self.transform, ANGLE);
        angle += ANGLE;
    }
    rotationRecognizer.rotation = 0.0;
}

- (void)tapDetected:(UITapGestureRecognizer *)tapRecognizer
{
    self.transform = CGAffineTransformScale(self.transform, 1.3, 1.3);
//    [self removeFromSuperview];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

- (void) touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event {
    // Retrieve the touch point
    CGPoint pt = [[touches anyObject] locationInView:self];
    startLocation = pt;
    [[self superview] bringSubviewToFront:self];
}
- (void) touchesMoved:(NSSet*)touches withEvent:(UIEvent*)event {
    // Move relative to the original touch point
    CGPoint pt = [[touches anyObject] locationInView:self];
    CGRect frame = [self frame];
    frame.origin.x += pt.x - startLocation.x;
    frame.origin.y += pt.y - startLocation.y;
    [self setFrame:frame];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end

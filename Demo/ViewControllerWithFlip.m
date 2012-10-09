//
//  ViewControllerWithFlip.m
//  Demo
//
//  Created by Tzu-Yang Ni on 10/10/12.
//  Copyright (c) 2012 Tzu-Yang Ni. All rights reserved.
//

#import "ViewControllerWithFlip.h"
#import "FlipView.h"
#import "AnimationDelegate.h"

@interface ViewControllerWithFlip ()

@end

@implementation ViewControllerWithFlip

- (id)init
{
    self = [super init];
    if (self) {
        UIButton *backButton_ = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [backButton_ setFrame:CGRectMake(226, 84, 74, 44)];
        [backButton_ setTitle:@"Back" forState:UIControlStateNormal];
        [backButton_ addTarget:self action:@selector(handlebackButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        self.view.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:backButton_];
        animationDelegate = [[AnimationDelegate alloc] initWithSequenceType:kSequenceAuto
                                                              directionType:kDirectionForward];
        animationDelegate.controller = self;
        animationDelegate.perspectiveDepth = 200;
        flipView = [[FlipView alloc] initWithAnimationType:kAnimationFlipVertical
                                                     frame:self.view.frame];
        
        animationDelegate.transformView = flipView;
        flipView.tag = 1;
        [self.view addSubview:flipView];
        [self.view sendSubviewToBack:flipView];
        
        flipView.fontSize = 36;
        //    for (UIFont *font in [UIFont familyNames]) {
        //        NSLog(@"font %@", font);
        //    }
//        flipView.font = @"Helvetica Neue Bold";
        flipView.fontAlignment = @"center";
        flipView.textOffset = CGPointMake(0.0, 2.0);
        flipView.textTruncationMode = kCATruncationEnd;
        
        flipView.sublayerCornerRadius = 6.0f;
        
        panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panned:)];
        panRecognizer.delegate = self;
        panRecognizer.maximumNumberOfTouches = 1;
        panRecognizer.minimumNumberOfTouches = 1;
        
        [self.view addGestureRecognizer:panRecognizer];

        
    }
    return self;
}


- (void)handleshowAnimationButtonTapped:(id *)sender{
    NSLog(@"handleshowAnimationButtonTapped");
    if(flipView){
        [self.view bringSubviewToFront:flipView];

        UIGraphicsBeginImageContext(self.view.bounds.size);
        [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        animationDelegate.shadow = NO;
        [flipView printText:@"" usingImage:nil backgroundColor:[UIColor clearColor] textColor:[UIColor clearColor]];
        [flipView printText:@"" usingImage:image backgroundColor:[UIColor clearColor] textColor:[UIColor blackColor]];
        
        [NSObject cancelPreviousPerformRequestsWithTarget:self];
        animationDelegate.sequenceType = kSequenceControlled;
        animationDelegate.animationLock = YES;
        
        [NSTimer scheduledTimerWithTimeInterval: 0.01
                                         target: self
                                       selector: @selector(handleTimer:)
                                       userInfo: nil
                                        repeats: YES];
        
    }
}

- (void) handleTimer:(NSTimer *)timer{
    if (k< 200) {
        [animationDelegate setTransformValue:k delegating:NO];
        k ++;
    }else{
        [animationDelegate endStateWithSpeed:0.01];
        [self.view sendSubviewToBack:flipView];
        [flipView removeFromSuperview];
    }
}

- (void)handlebackButtonTapped:(id *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

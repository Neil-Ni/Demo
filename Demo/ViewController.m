//
//  ViewController.m
//  Demo
//
//  Created by Tzu-Yang Ni on 9/28/12.
//  Copyright (c) 2012 Tzu-Yang Ni. All rights reserved.
//

#import "ViewController.h"
#import "draggableImageView.h"
#import "SecondViewController.h"
#import "UIImage+scale.h"
#import "AnimationViewController.h"
#import "ViewControllerWithFlip.h"
#import "UIView+Animation.h"
#import "AnimationHelper.h"
#import "draggableView.h"

#import "SingUp1ViewController.h"
#import "SignUp1InfoViewController.h"
#import "SignUp2GrandMaViewController.h"
#import "SignUp2GrandSonViewController.h"
#import "SignUp2GSInfoViewController.h"

@interface ViewController () <UITextFieldDelegate, SingUp1ViewControllerDelegate, LoginControllerDelegate, SignUp2GrandSonViewControllerDelegate, SignUp2GrandMaViewControllerDelegate, SignUp2GSInfoViewControllerDelegate>{
    NSMutableArray *imageReferenceURLs;
    BOOL deleteMode;
}

- (void) setupInitial;
- (void) setUpDemoButtons;
- (void) setUpRegisterController;
- (void) setUpInviteController;
- (void) setUpWaitController;

@end

@implementation ViewController
@synthesize isIdle;

static bool IPHONE;
static bool TESTING;


- (void) handleshowImageButtonTapped:(id)sender{
    NSLog(@"handleshowImageButtonTapped");
    
    if(IPHONE){
        [self presentViewController:imagePicker_ animated:YES completion:nil];
    }else{
        if(![popoverController_ isPopoverVisible]){
            [popoverController_ presentPopoverFromRect:self.view.frame inView:self.view permittedArrowDirections:0 animated:YES];
        }else {
            [popoverController_ dismissPopoverAnimated:YES];
        }
    }
}

//- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{

/*    NSNumber *old = [change objectForKey: NSKeyValueChangeOldKey];
    
    if ([old isKindOfClass: [NSNull class]])
        return;
    
    NSLog(@"isIdle old value: %d", [old boolValue]);
    NSLog(@"isIdle changed, %d", [self.isIdle boolValue]);
    
    if ([self.isIdle boolValue]) {
        if (progressUpdateTimer_)
            [progressUpdateTimer_ invalidate];
        
//        self.statusLabel.text = @"Stopped";
//        [self cancelledBtn].enabled = NO;
//        [self submitBtn].enabled = YES;
        progressBar.hidden = YES;
//        self.statusLabel.hidden = YES;
        
    } else {
        if (progressUpdateTimer_)
            [progressUpdateTimer_ invalidate];
        
        progressUpdateTimer_ = [NSTimer timerWithTimeInterval: 0.1 target:self selector:@selector(updateProgressBar:) userInfo:nil repeats:YES];
        
//        self.statusLabel.text = @"Uploading..."; 
//        [self submitBtn].enabled = NO;
//        [self cancelledBtn].enabled = YES;
        progressBar.hidden = NO;
//        self.statusLabel.hidden = NO;
    }*/
//}

- (void)updateProgressBar:(NSTimer*)theTimer{
    NSLog(@"update... %f", progressBar.progress);
    
    if (progressBar.progress <= maxProgressValue) {
        float incr = 0.0025f;
        float curr = progressBar.progress;
        
        // iOS 5 supports animation. Use it if it's available
        if ([progressBar respondsToSelector:@selector(setProgress:animated:)])
            [progressBar setProgress:curr+incr animated:YES];
        else
            progressBar.progress += 0.0025f;
    }

}

- (void)viewWillAppear:(BOOL)animated{
}


- (void) initPopUpView {
}

- (void)setupLoginView{
    self.ContainerView.hidden = NO;
    [AnimationHelper addGradient:self.view];
}

- (void)handleShowProfileViewTapped: (id)sender{
    UserProfileViewController *aUserProfileViewController = [[UserProfileViewController alloc] init];
    draggableView *view = (draggableView *)self.view;
    [view MoveWholeViewUpduration:0.4];
    aUserProfileViewController.modalPresentationStyle = UIModalPresentationFullScreen;
    [self.navigationController presentViewController:aUserProfileViewController animated:YES completion:^{
            
    }];
}


//- (void)ExitFromProfileView:(UserProfileViewController *)controller{
//    NSLog(@"called");
//    draggableView *view = (draggableView *)self.view;
//    [view MoveWholeViewDownduration:0.4];
//}


- (void)setupButtomController{
    
    UIView *LayoverView = [[UIView alloc] initWithFrame:CGRectMake(0, 488, 320, 80)];
    LayoverView.backgroundColor = [UIColor blackColor];
    LayoverView.alpha = 0.2;
    [self.view addSubview:LayoverView];
    [self.view sendSubviewToBack:LayoverView];

}


- (void)hi:(LoginController *)controller{
    NSLog(@"hi");
}

- (void)setUpSlider{
    [AnimationHelper transitLabel:self.TESTIND withMessage:[NSString stringWithFormat:@"Welcome back %@", userInfoManager_.userName]];
    self.ShowProfileButton.hidden = NO;

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.ContainerView.hidden = YES;
    self.ShowProfileButton.hidden = YES;
    
    userInfoManager_ = [UserInfoManager sharedInstance];
    [userInfoManager_ fetchUserDefault];
    [userInfoManager_ printUserDefault];
    
    
    if(userInfoManager_.userName){
        [self.view removeSubviewWithFadeAnimation:self.ContainerView duration:0 option:UIViewAnimationOptionTransitionCrossDissolve];
        [self setUpSlider];
    }else{
        [self setupLoginView];
    }
//    [self setupInitial];
}
- (void)quitViewController: (UIViewController *)c{
    [AnimationHelper removeGradient:self.view];
    if([c isViewLoaded] ){
        [UIView
         transitionFromView:c.view
         toView:self.ContainerView
         duration:0.25f
         options:UIViewAnimationOptionTransitionCrossDissolve
         completion:^(BOOL finished) {
             [c removeFromParentViewController];
             [AnimationHelper removeGradient:self.view];
         }];
    }
    
}


- (void) touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event {
    
//    [AnimationHelper removeGradient:self.view];
////    LoginController * l = [[LoginController alloc] init];
//    for(UIViewController *c in self.childViewControllers){
//        if([c isViewLoaded] ){
//            [UIView
//                 transitionFromView:c.view
//                 toView:self.ContainerView
//                 duration:0.25f
//                 options:UIViewAnimationOptionTransitionCrossDissolve
//                 completion:^(BOOL finished) {
//                     [c removeFromParentViewController];
//                     [AnimationHelper removeGradient:self.view];
//            }];
//        }
//    }
//
//    [UIView
//         transitionFromView:LoginViewViewController_.view
//         toView:self.ContainerView
//         duration:0.25f
//         options:UIViewAnimationOptionTransitionCrossDissolve
//         completion:^(BOOL finished) {
//             [LoginViewViewController_ removeFromParentViewController];
//             [AnimationHelper removeGradient:self.view];
//         }];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


#pragma mark UIpopoverControllerDelegate

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController {
    NSLog(@"%d choosen images", [imageReferenceURLs count]);
    [self displayChoosenImages];
    imageReferenceURLs = [[NSMutableArray alloc] init];
}

#pragma mark UIImagePickerControllerDelegate

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    NSLog(@"%d choosen images", [imageReferenceURLs count]);
    [self displayChoosenImages];
    [self dismissViewControllerAnimated:YES completion:nil];
    imageReferenceURLs = [[NSMutableArray alloc] init];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{    
    [imageReferenceURLs addObject:info];
}


#pragma mark Demo interface setup

- (void)setUpDemoButtons{
    IPHONE = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)? TRUE : FALSE;
    CGRect frame;
    showImageButton_ = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    frame = IPHONE? CGRectMake(20, 20, 74, 44): CGRectMake(244, 50, 74, 44);
    [showImageButton_ setFrame:frame];
    [showImageButton_ setTitle:@"Show" forState:UIControlStateNormal];
    [showImageButton_ addTarget:self action:@selector(handleshowImageButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    sendImageButton_ = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    frame = IPHONE? CGRectMake(124, 20, 74, 44): CGRectMake(348, 50, 74, 44);
    [sendImageButton_ setFrame:frame];
    [sendImageButton_ setTitle:@"Send" forState:UIControlStateNormal];
    [sendImageButton_ addTarget:self action:@selector(handlesendImageButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    deleteImageButton_ = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    
    frame = IPHONE? CGRectMake(226, 20, 74, 44): CGRectMake(450, 50, 74, 44);
    [deleteImageButton_ setFrame:frame];
    [deleteImageButton_ setTitle:@"Delete" forState:UIControlStateNormal];
    [deleteImageButton_ addTarget:self action:@selector(handledeleteImageButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:showImageButton_];
    [self.view addSubview:sendImageButton_];
    [self.view addSubview:deleteImageButton_];
    
    /*Buttons for demo functionalities*/
    
    showDrawingButton_ = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    frame = IPHONE? CGRectMake(20, 84, 74, 44): CGRectMake(244, 50, 74, 44);
    [showDrawingButton_ setFrame:frame];
    [showDrawingButton_ setTitle:@"Draw" forState:UIControlStateNormal];
    [showDrawingButton_ addTarget:self action:@selector(handleshowSrawingButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    showAnimationButton_ = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    frame = IPHONE? CGRectMake(124, 84, 74, 44): CGRectMake(348, 50, 74, 44);
    [showAnimationButton_ setFrame:frame];
    [showAnimationButton_ setTitle:@"Flip" forState:UIControlStateNormal];
    [showAnimationButton_ addTarget:self action:@selector(handleshowAnimationButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:showDrawingButton_];
    [self.view addSubview:showAnimationButton_];
    
    UIButton *UserDemoButton_ = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    frame = IPHONE? CGRectMake(226, 84, 74, 44): CGRectMake(450, 50, 74, 44);
    [UserDemoButton_ setFrame:frame];
    [UserDemoButton_ setTitle:@"User" forState:UIControlStateNormal];
    [UserDemoButton_ addTarget:self action:@selector(handleUserDemoButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:UserDemoButton_];
    
}


- (void) setupInitial{
    TESTING = TRUE;
    
    NSLog(@"setUpInitial");
    [self setUpDemoButtons];
    imageViewCount = 0;
    imageViewArray_ = [[NSMutableArray alloc] init];
    imageReferenceURLs = [[NSMutableArray alloc] init];
    
    imagePicker_ = [[UIImagePickerController alloc] init];
    imagePicker_.delegate = self;
    imagePicker_.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    if(!IPHONE){
        popoverController_ = [[UIPopoverController alloc] initWithContentViewController:imagePicker_];
        popoverController_.delegate = self;
    }
    deleteMode = FALSE;
    client_ = [RKClient clientWithBaseURL:[NSURL URLWithString:ServerURL]];
    
    progressBar = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleBar];
    [progressBar setFrame:CGRectMake(20, 367, 280, 11)];
    progressBar.progress = 0.00999999;
    
    [self.view addSubview:progressBar];
    
    self.isIdle = [NSNumber numberWithBool:YES];
    [self addObserver:self forKeyPath:@"isIdle" options:NSKeyValueObservingOptionOld context:nil];
    self.isIdle = [NSNumber numberWithBool:YES];
    
    
    //on registering new user    
    
}




- (void) handlesendImageButtonTapped:(id *)sender{
    NSLog(@"handleshowImageButtonTapped");
//    draggableImageView *view = (draggableImageView *)[self.view viewWithTag:1];
//    [uploadListener_ upload: view.image];
    progressBar.progress = InitialProgress;
    progressBar.hidden = NO;
}

- (void) handledeleteImageButtonTapped:(id *)sender{
    NSLog(@"handledeleteImageButtonTapped");
    switch (deleteMode) {
        case TRUE:
            deleteMode = FALSE;
            break;
        case FALSE:
            deleteMode = TRUE;
            break;
        default:
            break;
    }
    
    deleteMode? NSLog(@"deleteMode TRUE"): NSLog(@"deleteMode FALSE");
}

- (void)handleshowSrawingButtonTapped:(id *)sender{
    NSLog(@"handleshowSrawingButtonTapped");
    NSLog(@"%d", imageViewCount);
    draggableImageView *view;
    
    for(int i = 1; i< imageViewCount+1; i++){
        view = (draggableImageView *)[self.view viewWithTag:i];
        UIImage *image = view.image;
        CGSize size = view.image.size;
        float ratio = view.frame.size.width/self.view.frame.size.width;
        UIImage *scaledImage = [image scaleToSize:CGSizeMake(size.width*ratio,size.height*ratio)];
        
        //pass in three parameters right now, the imageview, the center and the degree of rotation;
        
        view.image = scaledImage;
        
        [imageViewArray_ addObject:view];
    }
    NSLog(@"%d", [imageViewArray_ count]);
    
    
    SecondViewController *aSecondViewController = [[SecondViewController alloc] init];
    aSecondViewController.imageViewArray_ = imageViewArray_;
    
    [self.navigationController pushViewController:aSecondViewController animated:YES];
    
    
}

- (void)handleshowAnimationButtonTapped:(id *)sender{
    NSLog(@"handleshowAnimationButtonTapped");
    
    //    AnimationViewController *aAnimationViewController = [[AnimationViewController alloc] init];
    ViewControllerWithFlip *aViewControllerWithFlip = [[ViewControllerWithFlip alloc] init];
    [self.navigationController pushViewController:aViewControllerWithFlip animated:YES];
    //    [self.navigationController pushViewController:aAnimationViewController animated:YES];
    
}

- (void) displayChoosenImages {
    
    int imageHeight = IPHONE? 120: 240;
    int imageWidth = IPHONE? 80: 160;
    int viewHeight = (int) self.view.frame.size.height - imageHeight;
    int viewWidth = (int) self.view.frame.size.width - imageWidth;
    
    for(int i= imageViewCount; i< imageViewCount+[imageReferenceURLs count]; i++){
        NSDictionary *info = [imageReferenceURLs objectAtIndex:(i-imageViewCount)];
        UIImage *aImage = [info objectForKey:UIImagePickerControllerOriginalImage];
        
        int imageX = arc4random() %(viewWidth);
        int imageY = arc4random() %(viewHeight);
        CGRect frame = CGRectMake(imageX, imageY, imageWidth, imageHeight);
        UIImageView *adraggableImageView = [[draggableImageView alloc] initWithFrame:frame];
        [adraggableImageView setImage:aImage];
        [adraggableImageView setUserInteractionEnabled:YES];
        adraggableImageView.tag = i+1;
        
        UIGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handletappingImage:)];
        [adraggableImageView addGestureRecognizer:tap];
        
        [self.view addSubview:adraggableImageView];
    }
    imageViewCount += [imageReferenceURLs count];
}


-(void)handletappingImage:(UITapGestureRecognizer *)recognizer{
    if(deleteMode){
        UIImageView *view = (UIImageView *)recognizer.view;
        NSLog(@"removing subview of tag %d", view.tag);
        [view removeFromSuperview];
        NSLog(@"subviews count %d", [[self.view subviews] count]);
    }
}





- (void)transitionFromViewController:(UIViewController *)fromViewController toViewController:(UIViewController *)toViewController
{
	if (fromViewController == toViewController)
	{
		return;
	}
	toViewController.view.frame = self.ContainerView.bounds;
	toViewController.view.autoresizingMask = self.ContainerView.autoresizingMask;
    
	[fromViewController willMoveToParentViewController:nil];
	[self addChildViewController:toViewController];
    
	[self transitionFromViewController:fromViewController
					  toViewController:toViewController
							  duration:0.4
							   options:UIViewAnimationOptionTransitionCrossDissolve
							animations:^{
							}
							completion:^(BOOL finished) {
								[toViewController didMoveToParentViewController:self];
								[fromViewController removeFromParentViewController];
							}];
}


#pragma mark SignUp2GSInfoViewControllerDelegate
- (void)LeaveSignUp2GSInfoView:(SignUp2GSInfoViewController *)controller{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:
                                @"MainStoryboard_iPhone" bundle:[NSBundle mainBundle]];
    
    SignUp2GrandSonViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"SignUp2GrandSonViewController"];
    vc.delegate = self;
    [self transitionFromViewController:controller toViewController:vc];
}


#pragma mark SignUp2GrandMaViewControllerDelegate
- (void)LeaveSignUp2GrandMaView:(SignUp2GrandMaViewController *)controller{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:
                                @"MainStoryboard_iPhone" bundle:[NSBundle mainBundle]];
    
    SingUp1ViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"SingUp1ViewController"];
    vc.delegate = self;
    [self transitionFromViewController:controller toViewController:vc];    
}


#pragma mark SignUp2GrandSonViewControllerDelegate
- (void)LeaveSignUp2GrandSonView:(SignUp2GrandSonViewController *)controller{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:
                                @"MainStoryboard_iPhone" bundle:[NSBundle mainBundle]];
    
    SingUp1ViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"SingUp1ViewController"];
    vc.delegate = self;
    [self transitionFromViewController:controller toViewController:vc];
}
- (void)ShowSignUp2GrandSonViewInfo:(SignUp2GrandSonViewController *)controller{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:
                                @"MainStoryboard_iPhone" bundle:[NSBundle mainBundle]];
    
    SignUp2GSInfoViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"SignUp2GSInfoViewController"];
    vc.delegate = self;
    [self transitionFromViewController:controller toViewController:vc];
}



#pragma mark SignUp1InfoViewControllerDelegate
- (void)LeaveSignUp1InfoView:(SignUp1InfoViewController *)controller{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:
                                @"MainStoryboard_iPhone" bundle:[NSBundle mainBundle]];
    
    SingUp1ViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"SingUp1ViewController"];
    vc.delegate = self;
    [self transitionFromViewController:controller toViewController:vc];
}


#pragma mark SingUp1ViewControllerDelegate

- (void)LeaveSingUp1View:(SingUp1ViewController *)controller{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:
                                @"MainStoryboard_iPhone" bundle:[NSBundle mainBundle]];
    
    LoginController *vc = [storyboard instantiateViewControllerWithIdentifier:@"LoginController"];
    vc.delegate = self;
    [self transitionFromViewController:controller toViewController:vc];

}
- (void)WaitForInvitation:(SingUp1ViewController *)controller{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:
                                @"MainStoryboard_iPhone" bundle:[NSBundle mainBundle]];
    
    SignUp2GrandMaViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"SignUp2GrandMaViewController"];
    vc.delegate = self;
    [self transitionFromViewController:controller toViewController:vc];
    
}
- (void)StartAChannel:(SingUp1ViewController *)controller{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:
                                @"MainStoryboard_iPhone" bundle:[NSBundle mainBundle]];
    
    SignUp2GrandSonViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"SignUp2GrandSonViewController"];
    vc.delegate = self;
    [self transitionFromViewController:controller toViewController:vc];
    
}
- (void)ShowInfo:(SingUp1ViewController *)controller{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:
                                @"MainStoryboard_iPhone" bundle:[NSBundle mainBundle]];
    
    SignUp1InfoViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"SignUp1InfoViewController"];
    vc.delegate = self;
    [self transitionFromViewController:controller toViewController:vc];

}



-(void)EnterSignUp1View:(LoginController *)controller{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:
                                @"MainStoryboard_iPhone" bundle:[NSBundle mainBundle]];
    
    SingUp1ViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"SingUp1ViewController"];
    vc.delegate = self;
    [self transitionFromViewController:controller toViewController:vc];
}
-(void)ExitFromLoginView:(LoginController *)controller{
    [AnimationHelper removeGradient:self.view];
    [self.view removeSubviewWithFadeAnimation:self.ContainerView duration:0.5 option:UIViewAnimationOptionTransitionCrossDissolve];
    
	[controller willMoveToParentViewController:nil];
    [controller removeFromParentViewController];
    [userInfoManager_ fetchUserDefault];
    [self setUpSlider];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"Login"])
    {
        LoginController *vc = [segue destinationViewController];
        vc.delegate =self;
    }
}

@end

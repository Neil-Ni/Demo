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
//#import "UserDefault.h"

@interface ViewController () <UITextFieldDelegate>{
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

#pragma mark private methods

- (void)setUpRegisterController{
    CGRect frame;
    waitButton_ = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    frame = IPHONE? CGRectMake(124, 400, 74, 44): CGRectMake(348, 50, 74, 44);
    [waitButton_ setFrame:frame];
    [waitButton_ setTitle:@"Wait" forState:UIControlStateNormal];
    [waitButton_ addTarget:self action:@selector(handlewaitButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    inviteButton_ = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    frame = IPHONE? CGRectMake(124, 360, 74, 44): CGRectMake(348, 50, 74, 44);
    [inviteButton_ setFrame:frame];
    [inviteButton_ setTitle:@"Invite" forState:UIControlStateNormal];
    [inviteButton_ addTarget:self action:@selector(handleinviteButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    waitButton_.alpha = 0;
    inviteButton_.alpha = 0;
    
    [self.view addSubview:waitButton_];
    [self.view addSubview:inviteButton_];
}
- (void)showRegisterController{
    [UIView animateWithDuration:0.25 animations:^{inviteButton_.alpha = 1.0;}];
    [UIView animateWithDuration:0.25 animations:^{waitButton_.alpha = 1.0;}];
}
- (void)removeRegisterController{
    [UIView animateWithDuration:0.25 animations:^{inviteButton_.alpha = 0.0;}];
    [UIView animateWithDuration:0.25 animations:^{waitButton_.alpha = 0.0;}];
    [inviteButton_ removeFromSuperview];
    [waitButton_ removeFromSuperview];
}
- (void) setUpInviteController{
    CGRect passwordTextFieldFrame = CGRectMake(20, 250, 280.0, 31.0);
    UITextField *passwordTextField = [[UITextField alloc] initWithFrame:passwordTextFieldFrame];
    passwordTextField.placeholder = @"GrandMa's invitation Code";
    passwordTextField.backgroundColor = [UIColor whiteColor];
    passwordTextField.textColor = [UIColor blackColor];
    passwordTextField.font = [UIFont systemFontOfSize:14.0f];
    passwordTextField.borderStyle = UITextBorderStyleRoundedRect;
    passwordTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    passwordTextField.returnKeyType = UIReturnKeyDone;
    passwordTextField.textAlignment = 1;
    passwordTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    passwordTextField.tag = 2;
    passwordTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    passwordTextField.delegate = self;
    [self.view addSubview:passwordTextField];
    
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    NSLog(@"textFieldShouldBeginEditing");
    textField.backgroundColor = [UIColor colorWithRed:220.0f/255.0f green:220.0f/255.0f blue:220.0f/255.0f alpha:1.0f];
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    NSLog(@"textFieldShouldReturn:");
    NSString *code = textField.text;
    [self inviteGrandMa: code];
    [textField resignFirstResponder];
    return YES;
}

- (void) showLable:(NSString *)message{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 185, 280, 66)];
    NSString *string = [[NSString alloc] initWithFormat:@"%@",message];
    label.text = string;
    label.textAlignment = 1;
    label.font = [UIFont systemFontOfSize:30];
    label.tag = 10; //temporary
    label.alpha = 0;
    [self.view addSubview:label];
    [UIView animateWithDuration:0.25 animations:^{label.alpha = 1.0;}];

}
- (void) setUpWaitController{
    NSLog(@"grandma's invitation code is %@", userInfoManager_.invitationCode);
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 185, 280, 66)];
    NSString *string = [[NSString alloc] initWithFormat:@"%@",userInfoManager_.invitationCode];
    label.text = string;
    label.textAlignment = 1;
    label.font = [UIFont systemFontOfSize:30];
    label.tag = 10; //temporary
    label.alpha = 0;
    [self.view addSubview:label];
    [UIView animateWithDuration:0.25 animations:^{label.alpha = 1.0;}];

}

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
    RKClient *client = [RKClient clientWithBaseURL:[NSURL URLWithString:ServerURL]];
    
//    detectListener_ = [[ClientController alloc] init];
//    detectListener_.delegate = self;
//    detectListener_.ListenterType = DETECT;
//    uploadListener_ = [[ClientController alloc] init];
//    uploadListener_.delegate = self;
//    uploadListener_.ListenterType = UPLOAD;
//    recogListener_ = [[ClientController alloc] init];
//    recogListener_.delegate = self;
//    recogListener_.ListenterType = RECOG;
//    detectListener_.client = uploadListener_.client = recogListener_.client = client;
    
    progressBar = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleBar];
    [progressBar setFrame:CGRectMake(20, 367, 280, 11)];
    progressBar.progress = 0.00999999;

    [self.view addSubview:progressBar];
    
    self.isIdle = [NSNumber numberWithBool:YES];
    [self addObserver:self forKeyPath:@"isIdle" options:NSKeyValueObservingOptionOld context:nil];
    self.isIdle = [NSNumber numberWithBool:YES];
    
    
    
    //on registering new user
    registerListener_ = [[ClientController alloc] init];
    registerListener_.delegate = self;
    registerListener_.client = client;
    
    userInfoManager_ = [UserInfoManager sharedInstance];
    [userInfoManager_ fetchUserDefault];
    [userInfoManager_ printUserDefault];
    
}
- (void)handleUserDemoButtonTapped:(id)sender{
    
    if([userInfoManager_ isFirstTime]){
        registerListener_.ListenterType = REGISTER;
        [self setUpRegisterController];
        [registerListener_ reqisterNewUser];
        
    }else{
        registerListener_.ListenterType = CHECKUPDATE;
        [registerListener_ checkUpdateOfUser:userInfoManager_.privateId];
    }
}

- (void)checkUpdateFinished:(ClientController *)controller{
    
    if(![userInfoManager_ isInvited]){
        NSString *response = [[NSString alloc] initWithFormat:@"%@",[controller.userInfo objectForKey: @"success_message"]];
        if(response){
            userInfoManager_.invitationCode = nil;
            [userInfoManager_ setInvited];
        }
    }
    [userInfoManager_ isInvited]? NSLog(@"invited"): NSLog(@"not invited");
    
    if([userInfoManager_ isGrandSon]){
        [self showLable:@"next view (GS)"];
    }else{
        if([userInfoManager_ isInvited]){
            [self showLable:@"You'r invited!"];
        }else{
            NSString *res = [[NSString alloc] initWithFormat:@"%@", userInfoManager_.invitationCode];
            [self showLable:res];
        }
    }

}


#pragma mark REGISTER

- (void)registerFinished:(ClientController *)controller{
    userInfoManager_.invitationCode = [controller.userInfo objectForKey: @"inviation_code"];
    userInfoManager_.privateId = [controller.userInfo objectForKey: @"private_id"];
    
    NSLog(@"privateId: %@", userInfoManager_.privateId);
    NSLog(@"invitationCode: %@", userInfoManager_.invitationCode);
    
    [self showRegisterController];

    
}
- (void) inviteGrandMa: (NSString *)code{
    //pop up a screen
    NSLog(@"Grandson typed in the invitation code: %@", code);
    registerListener_.ListenterType = INVITE;
    [registerListener_ inviteWithCode:code];

}

- (void)inviteFinished:(ClientController *)controller{
    [self showLable:@"NextView"];
}


- (void) showInvitationCode{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 185, 280, 66)];
    label.text = userInfoManager_.invitationCode;
    label.tag = 10; //temporary
    label.alpha = 0;
    [self.view addSubview:label];
    [UIView animateWithDuration:0.25 animations:^{label.alpha = 1.0;}];

}

- (void)handleinviteButtonTapped:(id)sender{
    NSLog(@"handleinviteButtonTapped");
    
    [userInfoManager_ setUserType: userTypeGrandSon];
    [userInfoManager_ setInvited];
    [userInfoManager_ saveUserDefault];

    [self removeRegisterController];
    [self setUpInviteController];
}

- (void)handlewaitButtonTapped:(id)sender{
    NSLog(@"handlewaitButtonTapped");
    
    [userInfoManager_ setUserType: userTypeGrandMa];
    [userInfoManager_ setUnInvited];
    [userInfoManager_ saveUserDefault];

    [self removeRegisterController];
    [self setUpWaitController];
}




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

- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    
    NSNumber *old = [change objectForKey: NSKeyValueChangeOldKey];
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
    }
}

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

- (void) handlesendImageButtonTapped:(id *)sender{
    NSLog(@"handleshowImageButtonTapped");    
    draggableImageView *view = (draggableImageView *)[self.view viewWithTag:1];
    [uploadListener_ upload: view.image];
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

- (void)viewWillAppear:(BOOL)animated{
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupInitial];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

#pragma mark ClientControllerDelegate

- (void)notifyError:(NSString *)title message:(NSString *)message{
//    NSDictionary *userInfo = [[NSDictionary alloc] initWithObjectsAndKeys: title, @"title", message, @"error", nil];
//    [[NSNotificationCenter defaultCenter] postNotificationName: SnapRequestFailedEvent object: nil userInfo: userInfo];
}
- (void)notifyWarning:(NSString *)title message:(NSString *)message{
    // if the user is not operating on this view;
    // the error message will be deferred to display
    // when the user goes back to this view
//    [self.windowMessageQueue addOperationWithBlock:^{
//        // show alert window in the main thread
//        [[NSOperationQueue mainQueue] addOperationWithBlock: ^{
//            [DogsnapAppDelegate alertWindow: title message: message];
//        }];
//    }];

}
- (void)setMaxProgressValue:(float)value{
    maxProgressValue = value;
}

- (void)updateProgressBar{
    [[NSRunLoop currentRunLoop] addTimer:progressUpdateTimer_ forMode:NSDefaultRunLoopMode];
    progressBar.progress = UploadFinishProgress;
}
- (void)updateProgressBarWith:(float)value{
    if(value == 1.0){
        self.isIdle = [NSNumber numberWithBool:YES];
    }
    progressBar.progress = UploadFinishProgress*value;
}

- (void)requestDetectionResult:(NSString *)client_id{
    [detectListener_ requestDetectionResult:client_id];
}

- (void)requestCancelled:(ClientController *)controller{
    NSLog(@"cancelled");
    progressBar.progress = InitialProgress;
    self.isIdle = [NSNumber numberWithBool:YES];
    uploadListener_.request = nil;
    
    // after cancel, we ask the user to re-pick the image.
//    [self _presentImagePicker];
}
- (void)requestStarted:(ClientController *)controller{
    self.isIdle = [NSNumber numberWithBool: NO];
    NSLog(@"started");
}

- (void)requestTimeouted:(ClientController *)controller{
    NSLog(@"time out");
}

- (void)requestFailed:(ClientController *)controller{
    NSLog(@"%@ requestFailed: get invoked.", self.class);
    NSDictionary *userInfo = controller.userInfo;
    progressBar.progress = InitialProgress;
    
    self.isIdle = [NSNumber numberWithBool:YES];
    if (!userInfo)
        return;
    NSString *title = [userInfo objectForKey:@"title"];
    NSString *error = [userInfo objectForKey:@"error"];

    NSLog(@"TITLE: %@ ERROR: %@", title, error);
    // Pop up the error message window only when the user is operating on
    // this view.
//    if (self.tabBarController.selectedIndex == SnapItViewTabSelectedIndex) {
//        [DogsnapAppDelegate alertWindow: title message: error];
//    }

}

- (void)detectionFinished:(ClientController *)controller{
    progressBar.progress = DetectFinishProgress;
    NSString *client_id = [controller.userInfo objectForKey: RecognitionClientIdKey];
    recogListener_.userInfo = controller.userInfo;
    [recogListener_ requestRecognitionResult:client_id];
}

- (void)recognitionFinished:(ClientController *)controller{
    progressBar.progress = 1.0f;
    self.isIdle = [NSNumber numberWithBool:YES];
    NSArray *breeds = [controller.userInfo objectForKey: RecognitionResultBreedNameKey];
    NSArray *sample_ids = [controller.userInfo objectForKey: RecognitionResultSampleIdKey];
    NSString *client_id = [controller.userInfo objectForKey: RecognitionClientIdKey];
    NSLog(@"breeds: %@", breeds);
    NSLog(@"sample_idS: %@", sample_ids);
    NSLog(@"client_id: %@", client_id);
}


@end

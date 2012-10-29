//
//  LoginViewController.m
//  Demo
//
//  Created by Tzu-Yang Ni on 10/29/12.
//  Copyright (c) 2012 Tzu-Yang Ni. All rights reserved.
//

//
//  LoginViewController.m
//  Demo
//
//  Created by Tzu-Yang Ni on 10/21/12.
//  Copyright (c) 2012 Tzu-Yang Ni. All rights reserved.
//

#import "LoginViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "AnimationHelper.h"


//TextField tags
#define UsernameTextFieldTYPE 0
#define PasswordTextFieldTYPE 1
#define InvitationCodeTextFieldTYPE 2
#define LoginUserNameTYPE 3
#define LoginPasswordTYPE 4

@interface LoginViewController ()

@end

@implementation LoginViewController
@synthesize delegate, client, request;

static bool firsttime;

-(id) init{
    self = [super init];
    if(self){
        self.view.frame = CGRectMake(20, 168, 280, 231);
        [[self.view layer] setCornerRadius:10];
        [self.view setClipsToBounds:YES];
        self.InvitationCodeTextField.delegate = self;
        self.InvitationCodeTextField.tag = InvitationCodeTextFieldTYPE;
        self.UsernameTextField.delegate = self;
        self.UsernameTextField.tag = UsernameTextFieldTYPE;
        self.PasswordTextField.delegate = self;
        self.PasswordTextField.tag = PasswordTextFieldTYPE;
        self.LoginUserName.delegate = self;
        self.LoginUserName.tag = LoginUserNameTYPE;
        self.LoginPassword.delegate = self;
        self.LoginPassword.tag = LoginPasswordTYPE;
        self.LoginViewHeader.text = @"Choose your mode";
    }
    return self;
}

- (void)hideFirstTimebuttons{
    self.GrandMaButton.hidden = YES;
    self.GrandSonButton.hidden = YES;
    self.LoginButton.hidden = YES;
}
- (void)showLoginView{
    //    [AnimationHelper MoveRight:self.InviteButton duration:2.0];
    //    [AnimationHelper MoveRight:self.WaitButton duration:2.0];
    
    
    self.LoginPassword.hidden = NO;
    self.LoginUserName.hidden = NO;
    
    [AnimationHelper transitLabel:self.LoginViewHeader withMessage:@"Welcome back"];
}


#pragma mark REGISTER

- (void)registerFinished:(ClientController *)controller{
    if(userInfoManager_.invitationCode){
        if([controller.userInfo objectForKey:@"success_message"]){
            [AnimationHelper transitLabel:self.LoginViewHeader withMessage:[controller.userInfo objectForKey:@"success_message"]];
        }
    }else{
        userInfoManager_.invitationCode = [controller.userInfo objectForKey: @"inviation_code"];
        userInfoManager_.privateId = [controller.userInfo objectForKey: @"private_id"];
        
        NSLog(@"privateId: %@", userInfoManager_.privateId);
        NSLog(@"invitationCode: %@", userInfoManager_.invitationCode);
        [userInfoManager_ saveUserDefault];
        [AnimationHelper transitLabel:self.LoginViewHeader withMessage:userInfoManager_.invitationCode];
    }
}

- (void)viewWillAppear:(BOOL)animated{
    NSLog(@"viewWillAppear");
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if(!self.client){
        self.client = [RKClient clientWithBaseURL:[NSURL URLWithString:ServerURL]];
    }
    registerListener_ = [[ClientController alloc] init];
    registerListener_.delegate = self;
    registerListener_.client = client;
    
    userInfoManager_ = [UserInfoManager sharedInstance];
    [userInfoManager_ fetchUserDefault];
    [userInfoManager_ printUserDefault];
    NSLog(@"viewDidLoad");
    
    NSLog(@"%@", userInfoManager_.userName);
    
    
    if(userInfoManager_.userName){
        firsttime = FALSE;
        [self showLoginView];
        [self hideFirstTimebuttons];
    }else{
        firsttime = TRUE;
        self.LoginPassword.hidden = YES;
        self.LoginUserName.hidden = YES;
    }
    
    if(userInfoManager_.invitationCode){
        firsttime = FALSE;
        
        self.LoginButton.hidden = YES;
        self.GrandMaButton.hidden = YES;
        self.GrandSonButton.hidden = YES;
        
        registerListener_.ListenterType = REGISTER;
        [registerListener_ reqisterNewUser: userInfoManager_.privateId];
        //        [registerListener_ reqisterNewUser: @"2"];
        
        [AnimationHelper transitLabel:self.LoginViewHeader withMessage:userInfoManager_.invitationCode];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)login{
    if(username.length == 0|| password.length == 0){
        [AnimationHelper transitLabel:self.LoginViewHeader withMessage:@"Field Empty"];
    }
    registerListener_.ListenterType = LOGIN;
    [registerListener_ logingWithUser:username andPassword:password];
    
}

- (void)loginfinished:(BOOL)success{
    if(success){
        [AnimationHelper transitLabel:self.LoginViewHeader withMessage:@"Logged in"];
        
        
        userInfoManager_.userName = username;
        [userInfoManager_ saveUserDefault];
        
        [AnimationHelper MoveUp:self.InviteButton duration:1.0];
        [AnimationHelper MoveUp:self.WaitButton duration:1.0];
        
        [AnimationHelper MoveUp:self.LoginUserName duration:1.0];
        [AnimationHelper MoveUp:self.LoginPassword duration:1.0];
        
        //        [self.delegate ExitFromLoginView:self];
        
    }else{
        [AnimationHelper transitLabel:self.LoginViewHeader withMessage:@"Failed to logged in"];
    }
    
}


- (void)showInvitationCodeView{
    [AnimationHelper transitLabel:self.LoginViewHeader withMessage:@"Type in Code"];
    if(firsttime){
        [AnimationHelper MoveUp:self.UsernameTextField duration:1.0];
        [AnimationHelper MoveUp:self.PasswordTextField duration:1.0];
        
    }else{
        [AnimationHelper MoveUp:self.InviteButton duration:1.0];
        [AnimationHelper MoveUp:self.WaitButton duration:1.0];
    }
    [AnimationHelper MoveUp:self.InvitationCodeTextField duration:1.0];
}

- (void) createAccount{
    if(username.length == 0|| password.length == 0){
        [AnimationHelper transitLabel:self.LoginViewHeader withMessage:@"Field Empty"];
    }
    registerListener_.ListenterType = CREATEACCOUNT;
    [registerListener_ createAccount:username andPassword:password];
}

- (void)createAccountfinished:(BOOL)success{
    if(success){
        [AnimationHelper transitLabel:self.LoginViewHeader withMessage:@"Account Created"];
        
        userInfoManager_.userName = username;
        [userInfoManager_ saveUserDefault];
        
        [AnimationHelper MoveUp:self.UsernameTextField duration:1.0];
        [AnimationHelper MoveUp:self.PasswordTextField duration:1.0];
        
        [AnimationHelper MoveUp:self.InviteButton duration:1.0];
        [AnimationHelper MoveUp:self.WaitButton duration:1.0];
        
    }else{
        [AnimationHelper transitLabel:self.LoginViewHeader withMessage:@"Account Failed to Create"];
    }
    
}

- (void)inviteWithCode: (NSString *)code{
    
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    NSLog(@"textFieldShouldBeginEditing");
    textField.backgroundColor = [UIColor colorWithRed:220.0f/255.0f green:220.0f/255.0f blue:220.0f/255.0f alpha:1.0f];
    return YES;
}


- (void)checkAccountUniquenessfinished:(BOOL)success{
    if(success){
        [AnimationHelper transitLabel:self.LoginViewHeader withMessage:@"Username works"];
    }else{
        [AnimationHelper transitLabel:self.LoginViewHeader withMessage:@"Username used"];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    NSLog(@"textFieldShouldReturn:");
    switch (textField.tag) {
        case InvitationCodeTextFieldTYPE:{
            NSString *code = self.InvitationCodeTextField.text;
            [self inviteWithCode: code];
        }
            break;
        case PasswordTextFieldTYPE:{
            username =  self.UsernameTextField.text;
            password = self.PasswordTextField.text;
            [self createAccount];
        }
            break;
        case UsernameTextFieldTYPE:{
            registerListener_.ListenterType = CHECKUIQUEACCOUNT;
            [registerListener_ checkAccountUniqueness:self.UsernameTextField.text];
        }
            break;
        case LoginUserNameTYPE:
            break;
        case LoginPasswordTYPE:{
            username =  self.LoginUserName.text;
            password = self.LoginPassword.text;
            [self login];
        }
            break;
        default:
            break;
    }
    //    NSString *code = textField.text;
    //    [self inviteGrandMa: code];
    [textField resignFirstResponder];
    return YES;
}


- (IBAction)Invite:(id)sender {
    NSLog(@"handleinviteButtonTapped");
    [self.delegate hi:self];
    
    [AnimationHelper MoveUp:self.InviteButton duration:1.0];
    [AnimationHelper MoveUp:self.WaitButton duration:1.0];
    
    [self showInvitationCodeView];
    //
    //    [self removeRegisterController];
    //    [self setUpInviteController];
    
}

- (IBAction)Wait:(id)sender {
    
    [AnimationHelper MoveUp:self.InviteButton duration:1.0];
    [AnimationHelper MoveUp:self.WaitButton duration:1.0];
    
}
- (IBAction)ExitThisView:(id)sender {
    [self.delegate ExitFromLoginView:self];
}



- (IBAction)ChooseGrandSonMode:(id)sender {
    NSLog(@"ChooseGrandSonMode");
    
    [AnimationHelper transitLabel:self.LoginViewHeader withMessage:@"Create An Account"];
    
    [AnimationHelper MoveUp:self.GrandMaButton duration:1.0];
    [AnimationHelper MoveUp:self.GrandSonButton duration:1.0];
    [AnimationHelper MoveUp:self.LoginButton duration:1.0];
    
    //    [AnimationHelper MoveDown:self.InvitationCodeTextField duration:1.0];
    
    [AnimationHelper MoveUp:self.UsernameTextField duration:1.0];
    [AnimationHelper MoveUp:self.PasswordTextField duration:1.0];
    
    
    [userInfoManager_ setUserType: userTypeGrandSon];
    [userInfoManager_ setInvited];
    [userInfoManager_ saveUserDefault];
    
}

- (IBAction)ChooseGrandMaMode:(id)sender {
    NSLog(@"ChooseGrandMaMode");
    
    [AnimationHelper transitLabel:self.LoginViewHeader withMessage:@""];
    
    
    registerListener_.ListenterType = REGISTER;
    [registerListener_ reqisterNewUser: @"-1"];
    
    
    [AnimationHelper MoveUp:self.GrandMaButton duration:1.0];
    [AnimationHelper MoveUp:self.GrandSonButton duration:1.0];
    [AnimationHelper MoveUp:self.LoginButton duration:1.0];
    
    [userInfoManager_ setUserType: userTypeGrandMa];
    [userInfoManager_ setUnInvited];
    [userInfoManager_ saveUserDefault];
    //
    //    [self removeRegisterController];
    //    [self setUpWaitController];
    
}

- (IBAction)Login:(id)sender {
    
    
    [AnimationHelper transitLabel:self.LoginViewHeader withMessage:@"Welcome back"];
    
    [AnimationHelper MoveUp:self.GrandMaButton duration:1.0];
    [AnimationHelper MoveUp:self.GrandSonButton duration:1.0];
    [AnimationHelper MoveUp:self.LoginButton duration:1.0];
    
    [AnimationHelper MoveDown:self.LoginPassword duration:0];
    [AnimationHelper MoveDown:self.LoginUserName duration:0];
    
    self.LoginPassword.hidden = NO;
    self.LoginUserName.hidden = NO;
    
    [AnimationHelper MoveUp:self.LoginPassword duration:1.0];
    [AnimationHelper MoveUp:self.LoginUserName duration:1.0];
    
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
    //    maxProgressValue = value;
}

- (void)updateProgressBar{
    //    [[NSRunLoop currentRunLoop] addTimer:progressUpdateTimer_ forMode:NSDefaultRunLoopMode];
    //    progressBar.progress = UploadFinishProgress;
}
- (void)updateProgressBarWith:(float)value{
    //    if(value == 1.0){
    //        self.isIdle = [NSNumber numberWithBool:YES];
    //    }
    //    progressBar.progress = UploadFinishProgress*value;
}

- (void)requestDetectionResult:(NSString *)client_id{
    //    [detectListener_ requestDetectionResult:client_id];
}

- (void)requestCancelled:(ClientController *)controller{
    //    NSLog(@"cancelled");
    //    progressBar.progress = InitialProgress;
    //    self.isIdle = [NSNumber numberWithBool:YES];
    //    uploadListener_.request = nil;
    //
    //    // after cancel, we ask the user to re-pick the image.
    //    //    [self _presentImagePicker];
}
- (void)requestStarted:(ClientController *)controller{
    //    self.isIdle = [NSNumber numberWithBool: NO];
    //    NSLog(@"started");
}

- (void)requestTimeouted:(ClientController *)controller{
    //    NSLog(@"time out");
}

- (void)requestFailed:(ClientController *)controller{
    //    NSLog(@"%@ requestFailed: get invoked.", self.class);
    //    NSDictionary *userInfo = controller.userInfo;
    //    progressBar.progress = InitialProgress;
    //
    //    self.isIdle = [NSNumber numberWithBool:YES];
    //    if (!userInfo)
    //        return;
    //    NSString *title = [userInfo objectForKey:@"title"];
    //    NSString *error = [userInfo objectForKey:@"error"];
    //
    //    NSLog(@"TITLE: %@ ERROR: %@", title, error);
    //    // Pop up the error message window only when the user is operating on
    //    // this view.
    //    //    if (self.tabBarController.selectedIndex == SnapItViewTabSelectedIndex) {
    //    //        [DogsnapAppDelegate alertWindow: title message: error];
    //    //    }
    
}

- (void)detectionFinished:(ClientController *)controller{
    //    progressBar.progress = DetectFinishProgress;
    //    NSString *client_id = [controller.userInfo objectForKey: RecognitionClientIdKey];
    //    recogListener_.userInfo = controller.userInfo;
    //    [recogListener_ requestRecognitionResult:client_id];
}

- (void)recognitionFinished:(ClientController *)controller{
    //    progressBar.progress = 1.0f;
    //    self.isIdle = [NSNumber numberWithBool:YES];
    //    NSArray *breeds = [controller.userInfo objectForKey: RecognitionResultBreedNameKey];
    //    NSArray *sample_ids = [controller.userInfo objectForKey: RecognitionResultSampleIdKey];
    //    NSString *client_id = [controller.userInfo objectForKey: RecognitionClientIdKey];
    //    NSLog(@"breeds: %@", breeds);
    //    NSLog(@"sample_idS: %@", sample_ids);
    //    NSLog(@"client_id: %@", client_id);
}

@end
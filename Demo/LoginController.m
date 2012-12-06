//
//  LoginController.m
//  Demo
//
//  Created by Tzu-Yang Ni on 10/29/12.
//  Copyright (c) 2012 Tzu-Yang Ni. All rights reserved.
//

#import "LoginController.h"
#import "UserInfoManager.h"
#import "AnimationHelper.h"

#define LoginUserNameTYPE 0
#define LoginPasswordTYPE 1

@interface LoginController (){
    NSString *username_string;
    NSString *password_string;
    UserInfoManager *userInfoManager_;
    
}

@end

@implementation LoginController
@synthesize delegate, isQuitting;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (!self.client)
        self.client = [RKClient clientWithBaseURL:[NSURL URLWithString:ServerURL]];
    self.username.tag = LoginUserNameTYPE;
    self.username.delegate = self;
    self.password.tag = LoginPasswordTYPE;
    self.password.delegate = self;
    userInfoManager_ = [UserInfoManager sharedInstance];
    self.isQuitting = [NSNumber numberWithInt:0];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)logingWithUser: (NSString *)un andPassword: (NSString *)pw{
    RKParams *params = [RKParams params];
    [params setValue:un forParam:@"user_name"];
    [params setValue:pw forParam:@"pass_word"];
    
    self.request = [self.client post:ServerLogin params:params delegate:self];
    self.request.backgroundPolicy = RKRequestBackgroundPolicyRequeue;
}


- (void)login{
    if(username_string.length == 0|| password_string.length == 0){
        [AnimationHelper transitLabel:self.header withMessage:@"Field Empty"];
    }else{
        [self logingWithUser:username_string andPassword:password_string];
    }
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    NSLog(@"textFieldShouldBeginEditing");
    textField.backgroundColor = [UIColor colorWithRed:220.0f/255.0f green:220.0f/255.0f blue:220.0f/255.0f alpha:1.0f];
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    NSLog(@"textFieldShouldReturn:");
    switch (textField.tag) {
        case LoginUserNameTYPE:{
            
        }
            break;
        case LoginPasswordTYPE:{
            username_string =  self.username.text;
            password_string = self.password.text;
            [self login];
        }
            break;
        default:
            break;
        }
    [textField resignFirstResponder];
    return YES;
}

- (IBAction)hi:(id)sender {
//    UIViewController *c = [super parentViewController];
    self.view = nil;
//    [self removeFromParentViewController];
//    [UIView
//     transitionFromView:self.view
//     toView:c.view
//     duration:0.25f
//     options:UIViewAnimationOptionTransitionCrossDissolve
//     completion:^(BOOL finished) {
//         [LoginController_ removeFromParentViewController];
//         [AnimationHelper removeGradient:self.view];
//     }];
}

- (IBAction)SignUp:(id)sender {
    [self.delegate EnterSignUp1View:self];
}

- (IBAction)LogIn:(id)sender {
    [self login];
}

-(void)loginfinished: (BOOL)success{
    if(success){
        userInfoManager_.userName = username_string;
        [userInfoManager_ setUserType:userTypeGrandSon];
        [userInfoManager_ saveUserDefault];
        [AnimationHelper transitLabel:self.header withMessage:@"Login successful"];
        [self.delegate ExitFromLoginView:self];
    }else{
        [AnimationHelper transitLabel:self.header withMessage:@"Login Unsuccessful"];
    }
}

- (void)request:(RKRequest *)request didFailLoadWithError:(NSError *)error{
    NSLog(@"didFailLoadWithError: %@", error.localizedDescription);
}

- (void)request:(RKRequest *)request didLoadResponse:(RKResponse *)response{
    
    NSLog(@"didLoadResponse: %@", response.bodyAsString);
    
    if (![response isJSON]) {
        NSLog(@"response wrong format");
        return;
    }
    NSDictionary *d = [response parsedBody:nil];
    if (!d) {
        NSLog(@"response wrong format");
        return;
    }
    BOOL success = FALSE;
    if([d objectForKey:@"successful_message"]){
        success = TRUE;
        int f_id = [[d objectForKey:@"family_id"] intValue];;
        [userInfoManager_ setFamilyid:f_id];
        userInfoManager_.invitationCode = [d objectForKey:@"invitation_code"];
        userInfoManager_.displayName = [d objectForKey:@"display_name"];
    }
    [self loginfinished: success];
}

- (void)request:(RKRequest *)request didReceivedData:(NSInteger)bytesReceived totalBytesReceived:(NSInteger)totalBytesReceived totalBytesExectedToReceive:(NSInteger)totalBytesExpectedToReceive
{
    NSLog(@"didReceivedData");
}

- (void)request:(RKRequest *)request didSendBodyData:(NSInteger)bytesWritten totalBytesWritten:(NSInteger)totalBytesWritten totalBytesExpectedToWrite:(NSInteger)totalBytesExpectedToWrite
{
    NSLog(@"didSendBodyData");
}

- (void)requestDidCancelLoad:(RKRequest *)request
{
}

- (void)requestDidStartLoad:(RKRequest *)request
{
    NSLog(@"requestDidStartLoad");
}

- (void)requestDidTimeout:(RKRequest *)request
{
    NSLog(@"requestDidTimeout");
}
@end

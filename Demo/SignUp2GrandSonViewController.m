//
//  SignUp2GrandSonViewController.m
//  Demo
//
//  Created by Tzu-Yang Ni on 10/29/12.
//  Copyright (c) 2012 Tzu-Yang Ni. All rights reserved.
//

#import "SignUp2GrandSonViewController.h"


#define LoginUserNameTYPE 0
#define LoginPasswordTYPE1 1
#define LoginPasswordTYPE2 2
#define LoginDisplayName 3

#define CHECKUIQUEACCOUNT 1
#define CREATEACCOUNT 2

@interface SignUp2GrandSonViewController (){
    NSString *username_string;
    NSString *password_string;
    NSString *password_confirm_string;
    NSString *displayName_string;
    int ListenerType;
    UserInfoManager *userInfoManager_;
    NSMutableDictionary *userinfo;
}

@end

@implementation SignUp2GrandSonViewController
@synthesize delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
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
    self.password.tag = LoginPasswordTYPE1;
    self.password.delegate = self;
    self.password_confirm.tag = LoginPasswordTYPE2;
    self.password_confirm.delegate = self;
    self.displayName.tag = LoginDisplayName;
    self.displayName.delegate = self;
    userInfoManager_ = [UserInfoManager sharedInstance];
    userinfo = [[NSMutableDictionary alloc] init];

}


- (void) createAccount{
    RKParams *params = [RKParams params];
    [params setValue:username_string forParam:@"user_name"];
    [params setValue:password_string forParam:@"pass_word"];
    [params setValue:displayName_string forParam:@"display_name"];
    self.request = [self.client post:ServerCreateAccount params:params delegate:self];
    self.request.backgroundPolicy = RKRequestBackgroundPolicyRequeue;
    ListenerType = CREATEACCOUNT;
}

- (void)createAccountfinished:(BOOL)success{
    if(success){
        [AnimationHelper transitLabel:self.header withMessage:@"Account Created"];
        
        userInfoManager_.userName = username_string;
        userInfoManager_.invitationCode = [userinfo objectForKey:@"invitation_code"];
        [userInfoManager_ setFamilyid:[[userinfo objectForKey:@"family_id"] intValue]];
        [userInfoManager_ setUserType:userTypeGrandSon];        
        [userInfoManager_ saveUserDefault];
        
        [self.delegate ExitSignUp2GrandSonViewInfo:self];
    }else{
        [AnimationHelper transitLabel:self.header withMessage:@"Account Failed to Create"];
    }
    
}


- (void)checkAccountUniqueness{
    RKParams *params = [RKParams params];
    [params setValue:username_string forParam:@"user_name"];
    self.request = [self.client post:ServerCheckUserUniqueness params:params delegate:self];
    self.request.backgroundPolicy = RKRequestBackgroundPolicyRequeue;

}
- (void)checkAccountUniquenessfinished:(BOOL)success{
    if(success){
        [AnimationHelper transitLabel:self.header withMessage:@"UserID not used"];
        [self createAccount];
    }else{
        [AnimationHelper transitLabel:self.header withMessage:@"UserID used"];
    }
}


- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    NSLog(@"textFieldShouldBeginEditing");
    textField.backgroundColor = [UIColor colorWithRed:220.0f/255.0f green:220.0f/255.0f blue:220.0f/255.0f alpha:1.0f];
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    NSLog(@"textFieldShouldReturn:");
    username_string =  self.username.text;
    password_string = self.password.text;
    password_confirm_string = self.password_confirm.text;
    displayName_string = self.displayName.text;
    
    if(username_string.length < 6){
        [AnimationHelper transitLabel:self.header withMessage:@"UserID too short"];
    }
    
    if(password_string.length < 6){
        [AnimationHelper transitLabel:self.header withMessage:@"Password too short"];
    }
    
    if(username_string.length>5
       && password_string.length>6
       && password_confirm_string.length>6
       && displayName_string.length!=0){
        
        if([password_string isEqualToString:password_confirm_string]){
            ListenerType = CHECKUIQUEACCOUNT;
            [self checkAccountUniqueness];
        }else{
            [AnimationHelper transitLabel:self.header withMessage:@"Passwords don't match"];
        }
    
    }else{
        [AnimationHelper transitLabel:self.header withMessage:@"Fields incomplete"];
    }
    [textField resignFirstResponder];
    return YES;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)Back:(id)sender {
    [self.delegate LeaveSignUp2GrandSonView:self];
}

- (IBAction)SignUp:(id)sender {
    username_string =  self.username.text;
    password_string = self.password.text;
    password_confirm_string = self.password_confirm.text;
    displayName_string = self.displayName.text;
    if(username_string.length!=0
       && password_string.length!=0
       && password_confirm_string.length!=0
       && displayName_string.length!=0){
        
        if([password_string isEqualToString:password_confirm_string]){
            
            if(username_string.length < 6){
                [AnimationHelper transitLabel:self.header withMessage:@"UserID too short"];
            }else{
                ListenerType = CHECKUIQUEACCOUNT;
                [self checkAccountUniqueness];
            }
        }else{
            [AnimationHelper transitLabel:self.header withMessage:@"Passwords don't match"];
        }
        
    }else{
        [AnimationHelper transitLabel:self.header withMessage:@"Fields incomplete"];
    }

}

- (IBAction)ShowInfo:(id)sender {
    [self.delegate ShowSignUp2GrandSonViewInfo:self];
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
    }
    
    switch (ListenerType) {
        case CHECKUIQUEACCOUNT:{
            BOOL success = FALSE;
            
            if([d objectForKey:@"successful_message"]){
                success = TRUE;
            }
            [self checkAccountUniquenessfinished: success];

        }
            break;
        case CREATEACCOUNT:{
            BOOL success = FALSE;
            if([d objectForKey:@"successful_message"]){
                success = TRUE;
                [userinfo addEntriesFromDictionary:d];
            }
            [self createAccountfinished: success];

        }
            break;
        default:
            break;
    }
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


//
//  SignUp2GrandMaViewController.m
//  Demo
//
//  Created by Tzu-Yang Ni on 10/29/12.
//  Copyright (c) 2012 Tzu-Yang Ni. All rights reserved.
//

#import "SignUp2GrandMaViewController.h"
#import "UserInfoManager.h"
#import "AnimationHelper.h"

@interface SignUp2GrandMaViewController (){
    NSMutableDictionary *userInfo;
    UserInfoManager *userInfoManager_;
    NSTimer *timer_;
}
@end

@implementation SignUp2GrandMaViewController
@synthesize delegate;


- (void)fetchResult:(NSTimer*)theTimer{
    RKParams *params = [RKParams params];
    [params setValue:userInfoManager_.privateId forParam:@"private_id"];
    self.request = [self.client post: ServerGrandma params:params delegate:self];
    NSLog(@"requested: %@, nil? %d", ServerGrandma, self.request == nil);
    self.request.backgroundPolicy = RKRequestBackgroundPolicyRequeue;
}

- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    NSNumber *old = [change objectForKey: NSKeyValueChangeOldKey];
     if ([old isKindOfClass: [NSNull class]])
     return;
     
     NSLog(@"isIdle old value: %d", [old boolValue]);
     NSLog(@"isIdle changed, %d", [self.isIdle boolValue]);
    
     if ([self.isIdle boolValue]) {
         if (timer_) [timer_ invalidate];
     }else{
         timer_ = [NSTimer scheduledTimerWithTimeInterval: 2.0 target:self selector:@selector(fetchResult:) userInfo:nil repeats: YES];
     }
}



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
    
    self.isIdle = [NSNumber numberWithBool:YES];
    [self addObserver:self forKeyPath:@"isIdle" options:NSKeyValueObservingOptionOld context:nil];

    
    userInfoManager_ = [UserInfoManager sharedInstance];
    userInfo = [[NSMutableDictionary alloc] init];
    if(userInfoManager_.invitationCode){
        [AnimationHelper transitLabel:self.header withMessage:userInfoManager_.invitationCode];
        self.BackButton.hidden = YES;
        self.GetInvitationCodeButton.hidden = YES;
        self.isIdle = [NSNumber numberWithBool:NO];
    }
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


- (void)reqisterNewUser{
    if (!self.client)
        self.client = [RKClient clientWithBaseURL:[NSURL URLWithString:ServerURL]];
    
    RKParams *params = [RKParams params];
    [params setValue:@"-1" forParam:@"private_id"];
    self.request = [self.client post: ServerGrandma params:params delegate:self];
    NSLog(@"requested: %@, nil? %d", ServerGrandma, self.request == nil);
    
    self.request.backgroundPolicy = RKRequestBackgroundPolicyRequeue;
}

- (void)registerfinished{
    userInfoManager_.invitationCode = [userInfo objectForKey: @"inviation_code"];
    userInfoManager_.privateId = [userInfo objectForKey: @"private_id"];
    
    NSLog(@"privateId: %@", userInfoManager_.privateId);
    NSLog(@"invitationCode: %@", userInfoManager_.invitationCode);
    [userInfoManager_ setUserType:userTypeGrandMa];
    self.isIdle = [NSNumber numberWithBool:NO];
    [userInfoManager_ saveUserDefault];
    [AnimationHelper transitLabel:self.header withMessage:userInfoManager_.invitationCode];
    [AnimationHelper hideView:self.BackButton];
    [AnimationHelper hideView:self.GetInvitationCodeButton];
    
}
-(void)checkInvitationStatus{
    if(![userInfo objectForKey:@"success_message"]) return;
    userInfoManager_.userName = [userInfo objectForKey: @"user_name"];
    userInfoManager_.displayName = [userInfo objectForKey:@"display_name"];
    [userInfoManager_ saveUserDefault];
    //invited!
    self.isIdle = [NSNumber numberWithBool:YES];
    [self.delegate InvitedAndExitFromSignUp2GrandMaView:self];
}


- (IBAction)Back:(id)sender {
    [self.delegate LeaveSignUp2GrandMaView:self];
}

- (IBAction)getinvitationCode:(id)sender {
    [self reqisterNewUser];
}

- (IBAction)NVM:(id)sender {
    self.isIdle = [NSNumber numberWithBool:YES];
    [self.delegate ExitFromSignUp2GrandMaView:self];
}

- (void)request:(RKRequest *)request didFailLoadWithError:(NSError *)error{
    NSLog(@"didFailLoadWithError: %@", error.localizedDescription);
}

- (void)request:(RKRequest *)request didLoadResponse:(RKResponse *)response{
    if([self.isIdle boolValue]){
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
        [userInfo addEntriesFromDictionary:d];
        [self registerfinished];
    }else{
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
        [userInfo addEntriesFromDictionary:d];
        [self checkInvitationStatus];
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

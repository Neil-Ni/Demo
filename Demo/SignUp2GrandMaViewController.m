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
}

@end

@implementation SignUp2GrandMaViewController
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
    userInfoManager_ = [UserInfoManager sharedInstance];
    userInfo = [[NSMutableDictionary alloc] init];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

    [userInfoManager_ saveUserDefault];
    [AnimationHelper transitLabel:self.header withMessage:userInfoManager_.invitationCode];
}

- (IBAction)Back:(id)sender {
    [self.delegate LeaveSignUp2GrandMaView:self];
}

- (IBAction)getinvitationCode:(id)sender {
    [self reqisterNewUser];
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
    [userInfo addEntriesFromDictionary:d];
    [self registerfinished];
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

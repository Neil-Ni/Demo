//
//  GrandSonInviteController.m
//  Demo
//
//  Created by Tzu-Yang Ni on 11/17/12.
//  Copyright (c) 2012 Tzu-Yang Ni. All rights reserved.
//

#import "GrandSonInviteController.h"
#import "UserInfoManager.h"
#import "AnimationHelper.h"

@interface GrandSonInviteController (){
    UserInfoManager *userInfoManager_;
    NSString *rel;
}

@end

@implementation GrandSonInviteController

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
    
    userInfoManager_ = [UserInfoManager sharedInstance];
    self.InvitationCodeTextField.delegate = self;
    self.RelationTextField.delegate = self;
    self.PersonDisplayName.delegate = self;
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)done:(id)sender {
    [self.delegate ExitFromGrandSonInviteView:self];
}

- (IBAction)Back:(id)sender {
    [self.delegate LeaveGrandSonInviteView:self];
}

-(void)invitefinished{
//s    [self.delegate ExitFromGrandSonInviteView:self];
}


- (void)invite:(NSString *)invitationCode andRelation:(NSString*)relation andDisplayName:(NSString*) DisplayName{
    if (!self.client)
        self.client = [RKClient clientWithBaseURL:[NSURL URLWithString:ServerURL]];
    
    RKParams *params = [RKParams params];
    [params setValue:invitationCode forParam:@"invitation_code"];
    [params setValue:userInfoManager_.getFamilyid forParam:@"family_id"];
    [params setValue:userInfoManager_.userName forParam:@"user_name"];
    [params setValue:relation forParam:@"relation"];
    [params setValue:DisplayName forParam:@"invited_person"];
    
    rel = relation;
    self.request = [self.client post: ServerInvite params:params delegate:self];
    NSLog(@"requested: %@, nil? %d", ServerInvite, self.request == nil);
    
    self.request.backgroundPolicy = RKRequestBackgroundPolicyRequeue;
    
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    NSLog(@"textFieldShouldBeginEditing");
    textField.backgroundColor = [UIColor colorWithRed:220.0f/255.0f green:220.0f/255.0f blue:220.0f/255.0f alpha:1.0f];
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    NSLog(@"textFieldShouldReturn:");
    NSString *invitationCode = self.InvitationCodeTextField.text;
    NSString *relation = self.RelationTextField.text;
    NSString *displayName = self.PersonDisplayName.text;
    if(invitationCode.length>0 && relation.length >0 && displayName.length > 0){
        [self invite:invitationCode andRelation:relation andDisplayName:displayName];
    }
    [textField resignFirstResponder];
    return YES;
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
    if([d objectForKey:@"successful_mesage"]){
        NSString *message = [NSString stringWithFormat:@"%@ is invited.", rel];
        [AnimationHelper transitLabel:self.Status withMessage:message];
    }else{
        NSString *message = [NSString stringWithFormat:@"Something went wrong. Invitation failed.. "];
        [AnimationHelper transitLabel:self.Status withMessage:message];
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

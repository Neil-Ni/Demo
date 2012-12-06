//
//  UserProfileViewController.m
//  Demo
//
//  Created by Tzu-Yang Ni on 10/29/12.
//  Copyright (c) 2012 Tzu-Yang Ni. All rights reserved.
//

#import "UserProfileViewController.h"
#import "draggableView.h"
#import "UserInfoManager.h"
#import "AnimationHelper.h"

@interface UserProfileViewController ()<UITableViewDataSource, UITableViewDelegate>{
    NSMutableDictionary *userInfo;
    UserInfoManager *userInfoManager_;
    NSMutableArray *familyMembers;
}

@end

@implementation UserProfileViewController
@synthesize delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)handlebackButtonTapped:(id *)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)fetchMember{
    if (!self.client)
        self.client = [RKClient clientWithBaseURL:[NSURL URLWithString:ServerURL]];
    
    RKParams *params = [RKParams params];
    [params setValue:userInfoManager_.getFamilyid forParam:@"family_id"];    
    self.request = [self.client post: ServerFamilyMember params:params delegate:self];
    NSLog(@"requested: %@, nil? %d", ServerFamilyMember, self.request == nil);
    self.request.backgroundPolicy = RKRequestBackgroundPolicyRequeue;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    userInfoManager_ = [UserInfoManager sharedInstance];
    if([userInfoManager_ isGrandMa]) self.InviteButton.hidden = YES;
    familyMembers = [[NSMutableArray alloc] init];
//    NSString *message = [NSString stringWithFormat:@"Your code is %@", userInfoManager_.invitationCode];
//    [AnimationHelper transitLabel:self.InvitationCodeLabel withMessage:message];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated{
    [self fetchMember];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)Done:(id)sender {
    [self.delegate ExitFromProfileView:self];   
}
- (IBAction)Invite:(id)sender {
    [self.delegate LeaveUserProfileView:self];
}
- (IBAction)Logout:(id)sender {
    familyMembers = [[NSMutableArray alloc] init];
    userInfoManager_.userName = nil;
    userInfoManager_.invitationCode = nil;
    [userInfoManager_ saveUserDefault];
    [self.delegate ExitFromProfileView:self];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 2;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	NSString *title = nil;
	switch (section) {
		case 0:{
            title = @"Your Invitation Code";
        }
			break;
		case 1:{
			title = @"Your Family Members";
        }
			break;
		case 2:
			title = @"ccc";
			break;
		default:
			break;
	}
	return title;
}
- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section{
	NSString *title = nil;
	switch (section) {
		case 0:{
            title = @"Provide your invitation code to get invited to a family channel.";
        }
			break;
		case 1:{
            if([familyMembers count] == 0) title = @"No other family members";
        }
			break;
		case 2:
			title = @"ccc";
			break;
		default:
			break;
	}
	return title;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if (section == 0) return 1;
	if (section == 1) return [familyMembers count];
	else return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    if(indexPath.section==0){
        cell.textLabel.textAlignment = 1;
        cell.textLabel.text = userInfoManager_.invitationCode;
    }else{
        cell.textLabel.textAlignment = 1;
        cell.textLabel.text = [familyMembers objectAtIndex:indexPath.row];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    return cell;
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
    if([d objectForKey:@"family_members"]){
//        [AnimationHelper transitLabel:self.FamilyMember withMessage:[d objectForKey:@"family_members"]];
        familyMembers = [[NSMutableArray alloc] init];
        NSArray *array = [[d objectForKey:@"family_members"] componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        for(NSString *name in array){
            if(![name isEqualToString:userInfoManager_.displayName] && name.length>1){
                [familyMembers addObject:name];
            }
        }
        [self.ProfileTableView reloadData];
    }else{
//        [AnimationHelper transitLabel:self.FamilyMember withMessage:@"No members"];
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

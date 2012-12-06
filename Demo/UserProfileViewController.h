//
//  UserProfileViewController.h
//  Demo
//
//  Created by Tzu-Yang Ni on 10/29/12.
//  Copyright (c) 2012 Tzu-Yang Ni. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RestKit/RestKit.h>

@class UserProfileViewController;

@protocol UserProfileViewControllerDelegate <NSObject>
- (void)LeaveUserProfileView:(UserProfileViewController *)controller;
- (void)ExitFromProfileView:(UserProfileViewController *)controller;

@end

@interface UserProfileViewController : UIViewController <RKRequestDelegate>
@property (nonatomic, weak) id <UserProfileViewControllerDelegate> delegate;


@property (strong, nonatomic) IBOutlet UITableView *ProfileTableView;
@property (nonatomic, strong) RKClient *client;
@property (nonatomic, strong) RKRequest *request;
- (IBAction)Done:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *InviteButton;
- (IBAction)Invite:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *InvitationCodeLabel;
- (IBAction)Logout:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *FamilyMember;

@end

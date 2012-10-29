//
//  LoginViewController.h
//  Demo
//
//  Created by Tzu-Yang Ni on 10/29/12.
//  Copyright (c) 2012 Tzu-Yang Ni. All rights reserved.
//


#import <UIKit/UIKit.h>
#import <RestKit/RestKit.h>
#import "ClientController.h"
#import "UserInfoManager.h"

@class LoginViewController;

@protocol LoginViewControllerDelegate <NSObject>
- (void)hi:(LoginViewController *)controller;
- (void)ExitFromLoginView:(LoginViewController *)controller;


@end

@interface LoginViewController : UIViewController <UITextFieldDelegate, ClientControllerDelegate>{
    ClientController *registerListener_;
    UserInfoManager *userInfoManager_;
    
    NSString *username;
    NSString *password;
}


@property (nonatomic, weak) id <LoginViewControllerDelegate> delegate;

@property (nonatomic, strong) RKClient *client;
@property (nonatomic, strong) RKRequest *request;


@property (strong, nonatomic) IBOutlet UIView *view;
@property (strong, nonatomic) IBOutlet UIButton *InviteButton;
@property (strong, nonatomic) IBOutlet UIButton *WaitButton;
- (IBAction)Invite:(id)sender;
- (IBAction)Wait:(id)sender;
@property (strong, nonatomic) IBOutlet UITextField *InvitationCodeTextField;
@property (strong, nonatomic) IBOutlet UILabel *LoginViewHeader;
@property (strong, nonatomic) IBOutlet UIButton *ExitButton;
- (IBAction)ExitThisView:(id)sender;
@property (strong, nonatomic) IBOutlet UITextField *PasswordTextField;
@property (strong, nonatomic) IBOutlet UITextField *UsernameTextField;
@property (strong, nonatomic) IBOutlet UITextField *LoginUserName;
@property (strong, nonatomic) IBOutlet UITextField *LoginPassword;

@property (strong, nonatomic) IBOutlet UIButton *GrandMaButton;
@property (strong, nonatomic) IBOutlet UIButton *GrandSonButton;
@property (strong, nonatomic) IBOutlet UIButton *LoginButton;

- (IBAction)ChooseGrandSonMode:(id)sender;
- (IBAction)ChooseGrandMaMode:(id)sender;
- (IBAction)Login:(id)sender;

@end


//
//  LoginController.h
//  Demo
//
//  Created by Tzu-Yang Ni on 10/29/12.
//  Copyright (c) 2012 Tzu-Yang Ni. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RestKit/RestKit.h>
#import "UserInfoManager.h"


@class LoginController;

@protocol LoginControllerDelegate <NSObject>
- (void)hi:(LoginController *)controller;
- (void)ExitFromLoginView:(LoginController *)controller;

@end

@interface LoginController : UIViewController  <RKRequestDelegate, UITextFieldDelegate> 


@property (nonatomic, weak) id <LoginControllerDelegate> delegate;

@property (nonatomic, strong) RKClient *client;
@property (nonatomic, strong) RKRequest *request;

@property (strong, nonatomic) IBOutlet UILabel *header;

@property (strong, nonatomic) IBOutlet UITextField *username;
@property (strong, nonatomic) IBOutlet UITextField *password;

- (IBAction)hi:(id)sender;

- (IBAction)SignUp:(id)sender;
- (IBAction)LogIn:(id)sender;

@property NSNumber *isQuitting;

@end

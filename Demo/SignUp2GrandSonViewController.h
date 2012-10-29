//
//  SignUp2GrandSonViewController.h
//  Demo
//
//  Created by Tzu-Yang Ni on 10/29/12.
//  Copyright (c) 2012 Tzu-Yang Ni. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RestKit/RestKit.h>
#import "UserInfoManager.h"
#import "AnimationHelper.h"

@interface SignUp2GrandSonViewController : UIViewController  <RKRequestDelegate, UITextFieldDelegate>

@property (nonatomic, strong) RKClient *client;
@property (nonatomic, strong) RKRequest *request;

@property (strong, nonatomic) IBOutlet UILabel *header;
@property (strong, nonatomic) IBOutlet UITextField *username;
@property (strong, nonatomic) IBOutlet UITextField *password;
@property (strong, nonatomic) IBOutlet UITextField *password_confirm;
@property (strong, nonatomic) IBOutlet UITextField *displayName;

- (IBAction)Back:(id)sender;
- (IBAction)SignUp:(id)sender;

@end

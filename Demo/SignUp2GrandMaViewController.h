//
//  SignUp2GrandMaViewController.h
//  Demo
//
//  Created by Tzu-Yang Ni on 10/29/12.
//  Copyright (c) 2012 Tzu-Yang Ni. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RestKit/RestKit.h>
#import "UserInfoManager.h"

@interface SignUp2GrandMaViewController : UIViewController <RKRequestDelegate, UITextFieldDelegate>

@property (nonatomic, strong) RKClient *client;
@property (nonatomic, strong) RKRequest *request;

@property (strong, nonatomic) IBOutlet UILabel *header;

- (IBAction)Back:(id)sender;
- (IBAction)getinvitationCode:(id)sender;

@end

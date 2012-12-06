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

@class SignUp2GrandMaViewController;

@protocol SignUp2GrandMaViewControllerDelegate <NSObject>
- (void)LeaveSignUp2GrandMaView:(SignUp2GrandMaViewController *)controller; //leave to go back to the previous controller
- (void)ExitFromSignUp2GrandMaView:(SignUp2GrandMaViewController *)controller; //exit and go back to main controller
- (void)InvitedAndExitFromSignUp2GrandMaView:(SignUp2GrandMaViewController *)controller; 

@end

@interface SignUp2GrandMaViewController : UIViewController <RKRequestDelegate, UITextFieldDelegate>

@property (nonatomic, weak) id <SignUp2GrandMaViewControllerDelegate> delegate;

@property (nonatomic, strong) RKClient *client;
@property (nonatomic, strong) RKRequest *request;
@property (strong, nonatomic) NSNumber *isIdle;

@property (strong, nonatomic) IBOutlet UILabel *header;
@property (strong, nonatomic) IBOutlet UIButton *BackButton;
@property (strong, nonatomic) IBOutlet UIButton *GetInvitationCodeButton;

- (IBAction)Back:(id)sender;
- (IBAction)getinvitationCode:(id)sender;
- (IBAction)NVM:(id)sender;

@end

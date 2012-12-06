//
//  GrandSonInviteController.h
//  Demo
//
//  Created by Tzu-Yang Ni on 11/17/12.
//  Copyright (c) 2012 Tzu-Yang Ni. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RestKit/RestKit.h>



@class GrandSonInviteController;

@protocol GrandSonInviteControllerDelegate <NSObject>
- (void)LeaveGrandSonInviteView:(GrandSonInviteController *)controller; //leave to go back to the previous controller
- (void)ExitFromGrandSonInviteView:(GrandSonInviteController *)controller; //exit and go back to main controller

@end

@interface GrandSonInviteController : UIViewController <RKRequestDelegate, UITextFieldDelegate>

@property (nonatomic, weak) id <GrandSonInviteControllerDelegate> delegate;

@property (strong, nonatomic) IBOutlet UITextField *PersonDisplayName;
@property (nonatomic, strong) RKClient *client;
@property (nonatomic, strong) RKRequest *request;
@property (strong, nonatomic) IBOutlet UITextField *RelationTextField;
@property (strong, nonatomic) IBOutlet UITextField *InvitationCodeTextField;
- (IBAction)done:(id)sender;
- (IBAction)Back:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *Status;

@end

//
//  SignUp2GSInfoViewController.h
//  Demo
//
//  Created by Tzu-Yang Ni on 10/29/12.
//  Copyright (c) 2012 Tzu-Yang Ni. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SignUp2GSInfoViewController;

@protocol SignUp2GSInfoViewControllerDelegate <NSObject>
- (void)LeaveSignUp2GSInfoView:(SignUp2GSInfoViewController *)controller;

@end


@interface SignUp2GSInfoViewController : UIViewController

@property (nonatomic, weak) id <SignUp2GSInfoViewControllerDelegate> delegate;

- (IBAction)Back:(id)sender;

@end

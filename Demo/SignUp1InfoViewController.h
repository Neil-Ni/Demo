//
//  SignUp1InfoViewController.h
//  Demo
//
//  Created by Tzu-Yang Ni on 10/29/12.
//  Copyright (c) 2012 Tzu-Yang Ni. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SignUp1InfoViewController;

@protocol SignUp1InfoViewControllerDelegate <NSObject>
- (void)LeaveSignUp1InfoView:(SignUp1InfoViewController *)controller;

@end

@interface SignUp1InfoViewController : UIViewController

@property (nonatomic, weak) id <SignUp1InfoViewControllerDelegate> delegate;

- (IBAction)Back:(id)sender;

@end

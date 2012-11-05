//
//  SingUp1ViewController.h
//  Demo
//
//  Created by Tzu-Yang Ni on 10/29/12.
//  Copyright (c) 2012 Tzu-Yang Ni. All rights reserved.
//

#import <UIKit/UIKit.h>



@class SingUp1ViewController;

@protocol SingUp1ViewControllerDelegate <NSObject>
- (void)LeaveSingUp1View:(SingUp1ViewController *)controller;
- (void)WaitForInvitation:(SingUp1ViewController *)controller;
- (void)StartAChannel:(SingUp1ViewController *)controller;
- (void)ShowInfo:(SingUp1ViewController *)controller;

@end

@interface SingUp1ViewController : UIViewController

@property (nonatomic, weak) id <SingUp1ViewControllerDelegate> delegate;

- (IBAction)Back:(id)sender;
- (IBAction)WaitForInvitation:(id)sender;
- (IBAction)StartAChannel:(id)sender;
- (IBAction)ShowInfo:(id)sender;

@end

//
//  UserProfileViewController.h
//  Demo
//
//  Created by Tzu-Yang Ni on 10/29/12.
//  Copyright (c) 2012 Tzu-Yang Ni. All rights reserved.
//

#import <UIKit/UIKit.h>


@class UserProfileViewController;

@protocol UserProfileViewControllerDelegate <NSObject>
- (void)ExitFromProfileView:(UserProfileViewController *)controller;

@end

@interface UserProfileViewController : UIViewController
@property (nonatomic, weak) id <UserProfileViewControllerDelegate> delegate;




- (IBAction)Done:(id)sender;

@end

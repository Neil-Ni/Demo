//
//  ViewController.h
//  Demo
//
//  Created by Tzu-Yang Ni on 9/28/12.
//  Copyright (c) 2012 Tzu-Yang Ni. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RestKit/RestKit.h>
#import "UserInfoManager.h"
#import "LoginViewController.h"

@interface ViewController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIPopoverControllerDelegate, LoginViewControllerDelegate> {
    UIButton *showImageButton_;
    UIButton *sendImageButton_;
    UIButton *deleteImageButton_;
    
    UIImagePickerController *imagePicker_;
    UIPopoverController *popoverController_;
    NSTimer *progressUpdateTimer_;
    UIProgressView *progressBar;
    float maxProgressValue;
    
    //Demo
    UIButton *showDrawingButton_;
    UIButton *showAnimationButton_;
    
    NSMutableArray *imageViewArray_;
    int imageViewCount;
    
    UserInfoManager *userInfoManager_;
    
    LoginViewController *LoginViewViewController_;
}
@property (nonatomic, strong) NSNumber *isIdle;
@property (strong, nonatomic) IBOutlet UIView *ContainerView;

@property (strong, nonatomic) IBOutlet UILabel *TESTIND;

@end
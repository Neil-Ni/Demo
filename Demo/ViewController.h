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
#import "UserProfileViewController.h"
#import "LoginController.h"

@interface ViewController : UIViewController <UIGestureRecognizerDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIPopoverControllerDelegate, UserProfileViewControllerDelegate> {
    UIButton *showImageButton_;
    UIButton *sendImageButton_;
    UIButton *deleteImageButton_;
    
    UIImagePickerController *imagePicker_;
    UIPopoverController *popoverController_;
    NSTimer *progressUpdateTimer_;
    UIProgressView *progressBar;
    float maxProgressValue;
    
    UIButton *showDrawingButton_;
    UIButton *showAnimationButton_;
    
    NSMutableArray *imageViewArray_;
    int imageViewCount;
    
    UserInfoManager *userInfoManager_;
    RKClient *client_;
}


@property (nonatomic, strong) NSNumber *isIdle;
@property (weak, nonatomic) IBOutlet UIView *ContainerView;
@property (strong, nonatomic) IBOutlet UILabel *TESTIND;
@property (strong, nonatomic) IBOutlet UIButton *ShowProfileButton;
- (void)quitViewController: (UIViewController *)c;

@end
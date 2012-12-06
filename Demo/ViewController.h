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
#import <QuartzCore/QuartzCore.h>

@interface ViewController : UIViewController <UIPageViewControllerDelegate, UIPageViewControllerDataSource, UIGestureRecognizerDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIPopoverControllerDelegate, RKObjectLoaderDelegate, UserProfileViewControllerDelegate> {
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
    
    UIPageViewController *pageController;
    NSMutableArray *imageContentArray;
    
    RKObjectManager* objectManager;
}
@property (strong, nonatomic) UIPageViewController *pageController;
@property (strong, nonatomic) NSMutableArray *imageContentArray;
@property (strong, nonatomic) NSNumber *isIdle;
@property (strong, nonatomic) IBOutlet UIView *ContainerView;
@property (strong, nonatomic) IBOutlet UILabel *TESTIND;
@property (strong, nonatomic) IBOutlet UIButton *ShowProfileButton;
@property (strong, nonatomic) IBOutlet UIButton *PickImageButton;
@property (strong, nonatomic) IBOutlet UIButton *TakeImageButton;
- (IBAction)PickImage:(id)sender;
- (IBAction)TakeImage:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *UploadImageButton;
- (IBAction)UploadImage:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *LoadImagebutton;
- (IBAction)LoadImage:(id)sender;


- (void)quitViewController: (UIViewController *)c;
- (IBAction)ShowProfile:(id)sender;

@end
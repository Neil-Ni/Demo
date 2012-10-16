//
//  ViewController.h
//  Demo
//
//  Created by Tzu-Yang Ni on 9/28/12.
//  Copyright (c) 2012 Tzu-Yang Ni. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RestKit/RestKit.h>
#import "ClientController.h"
#import "UserInfoManager.h"

@interface ViewController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIPopoverControllerDelegate,  ClientControllerDelegate> {
    UIButton *showImageButton_;
    UIButton *sendImageButton_;
    UIButton *deleteImageButton_;
    UIImagePickerController *imagePicker_;
    UIPopoverController *popoverController_;
    ClientController *uploadListener_, *detectListener_, *recogListener_;
    NSTimer *progressUpdateTimer_;
    UIProgressView *progressBar;
    float maxProgressValue;
    
    //Demo
    UIButton *showDrawingButton_;
    UIButton *showAnimationButton_;
    
    NSMutableArray *imageViewArray_;
    int imageViewCount;
    
    ClientController *registerListener_;
    
    UIButton *waitButton_;
    UIButton *inviteButton_;
    
    UserInfoManager *userInfoManager_;
    
}
@property (nonatomic, strong) NSNumber *isIdle;

@end
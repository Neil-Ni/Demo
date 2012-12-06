//
//  ViewController.m
//  Demo
//
//  Created by Tzu-Yang Ni on 9/28/12.
//  Copyright (c) 2012 Tzu-Yang Ni. All rights reserved.
//

#import "ViewController.h"
#import "draggableImageView.h"
#import "SecondViewController.h"
#import "UIImage+scale.h"
#import "AnimationViewController.h"
#import "ViewControllerWithFlip.h"
#import "UIView+Animation.h"
#import "AnimationHelper.h"
#import "draggableView.h"
#import "UIInitializer.h"


#import "SingUp1ViewController.h"
#import "SignUp1InfoViewController.h"
#import "SignUp2GrandMaViewController.h"
#import "SignUp2GrandSonViewController.h"
#import "SignUp2GSInfoViewController.h"

#import "UserProfileViewController.h"
#import "GrandSonInviteController.h"

#import "PhotoViewController.h"
#import "Image.h"

#import <MBProgressHUD/MBProgressHUD.h>

#import <AssetsLibrary/AssetsLibrary.h>

#define PrintFrame(frame) NSLog(@"%@", NSStringFromCGRect(frame));

@interface ViewController () <UITextFieldDelegate, SingUp1ViewControllerDelegate, LoginControllerDelegate, SignUp2GrandSonViewControllerDelegate, SignUp2GrandMaViewControllerDelegate, SignUp2GSInfoViewControllerDelegate,
    SignUp1InfoViewControllerDelegate, UserProfileViewControllerDelegate, GrandSonInviteControllerDelegate,PhotoViewControllerDelegate>{
        
    NSMutableArray *imageReferenceURLs;
    BOOL deleteMode;
    UIViewController *currentChildController;
    BOOL inSession;
    UIStoryboard *storyboard;
    NSMutableArray *tmpImageContent;
    int currentIndex;
    int prevIndex;
    MBProgressHUD *hud;
    PhotoViewController *curPhotoViewController;
}

- (void) setupInitial;
- (void) setUpDemoButtons;
- (void) setUpRegisterController;
- (void) setUpInviteController;
- (void) setUpWaitController;

@end

@implementation ViewController
@synthesize isIdle, pageController, imageContentArray;

static bool IPHONE;
static bool TESTING;
static bool UPLOADIMAGE;

- (void) handleshowImageButtonTapped:(id)sender{
    NSLog(@"handleshowImageButtonTapped");
    
    if(IPHONE){
        [self presentViewController:imagePicker_ animated:YES completion:nil];
    }else{
        if(![popoverController_ isPopoverVisible]){
            [popoverController_ presentPopoverFromRect:self.view.frame inView:self.view permittedArrowDirections:0 animated:YES];
        }else {
            [popoverController_ dismissPopoverAnimated:YES];
        }
    }
}

//- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{

/*    NSNumber *old = [change objectForKey: NSKeyValueChangeOldKey];
    
    if ([old isKindOfClass: [NSNull class]])
        return;
    
    NSLog(@"isIdle old value: %d", [old boolValue]);
    NSLog(@"isIdle changed, %d", [self.isIdle boolValue]);
    
    if ([self.isIdle boolValue]) {
        if (progressUpdateTimer_)
            [progressUpdateTimer_ invalidate];
        
//        self.statusLabel.text = @"Stopped";
//        [self cancelledBtn].enabled = NO;
//        [self submitBtn].enabled = YES;
        progressBar.hidden = YES;
//        self.statusLabel.hidden = YES;
        
    } else {
        if (progressUpdateTimer_)
            [progressUpdateTimer_ invalidate];
        
        progressUpdateTimer_ = [NSTimer timerWithTimeInterval: 0.1 target:self selector:@selector(updateProgressBar:) userInfo:nil repeats:YES];
        
//        self.statusLabel.text = @"Uploading..."; 
//        [self submitBtn].enabled = NO;
//        [self cancelledBtn].enabled = YES;
        progressBar.hidden = NO;
//        self.statusLabel.hidden = NO;
    }*/
//}

- (void)updateProgressBar:(NSTimer*)theTimer{
    NSLog(@"update... %f", progressBar.progress);
    
    if (progressBar.progress <= maxProgressValue) {
        float incr = 0.0025f;
        float curr = progressBar.progress;
        // iOS 5 supports animation. Use it if it's available
        if ([progressBar respondsToSelector:@selector(setProgress:animated:)])
            [progressBar setProgress:curr+incr animated:YES];
        else
            progressBar.progress += 0.0025f;
    }

}

- (void)viewWillAppear:(BOOL)animated{
}
- (void) initPopUpView {
}

- (void)setupLoginView{
    self.ContainerView.hidden = NO;
    inSession = YES;
    [AnimationHelper addGradient:self.view];
}

- (void)setupButtomController{
    UIView *LayoverView = [[UIView alloc] initWithFrame:CGRectMake(0, 488, 320, 80)];
    LayoverView.backgroundColor = [UIColor blackColor];
    LayoverView.alpha = 0.2;
    [self.view addSubview:LayoverView];
    [self.view sendSubviewToBack:LayoverView];
}


- (void)hi:(LoginController *)controller{
    NSLog(@"hi");
}
- (void)pushDownContainerAndSwitchToProfile{
    UserProfileViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"UserProfileViewController"];
    [self transitionFromViewController:currentChildController toViewController:vc];
    vc.delegate = self;
    currentChildController = vc;
    [self setUpSlider];
}
- (void)setUpSlider{
//    [AnimationHelper transitLabel:self.TESTIND withMessage:[NSString stringWithFormat:@"Welcome back %@", userInfoManager_.displayName]];
    [self unHideMainInterface];
    [self setupmainController];
}

- (void)setUpInvitationView{
    self.ContainerView.hidden = NO;
    inSession = YES;
    SignUp2GrandMaViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"SignUp2GrandMaViewController"];
    vc.client = client_;
    [self transitionFromViewController:currentChildController toViewController:vc];
    vc.delegate = self;
    currentChildController = vc;
}

- (void)checkIfImageUploadable{
    if([[self.imageContentArray objectAtIndex:curPhotoViewController.pageIndex] isKindOfClass:[UIImage class]]){
        self.UploadImageButton.hidden = NO;
        return;
    }
    if([[self.imageContentArray objectAtIndex:curPhotoViewController.pageIndex] isKindOfClass:[NSDictionary class]]){
        self.UploadImageButton.hidden = NO;
        return;
    }
    if([[self.imageContentArray objectAtIndex:curPhotoViewController.pageIndex] isKindOfClass:[Image class]]){
        self.UploadImageButton.hidden = YES;
    }
}

#pragma mark PhotoViewControllerdelegate

- (void)touchReceived:(PhotoViewController *)controller{
    NSLog(@"touchReceived");
    
}
- (void)doubleTapped:(PhotoViewController *)controller{
    NSLog(@"doubleTapped");
}

#pragma mark pageViewController


- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed {
    PhotoViewController* before = (PhotoViewController *)[previousViewControllers objectAtIndex:0];
    if( before.pageIndex - currentIndex)
    NSLog(@"%d  %d", before.pageIndex,currentIndex);
    if (!completed){
        NSLog(@"not completed %d  %d", before.pageIndex,currentIndex);
    }
}

- (UIViewController *)pageViewController:(UIPageViewController *)pvc viewControllerBeforeViewController:(PhotoViewController *)vc
{
    NSUInteger index = vc.pageIndex;
    currentIndex = index;
    curPhotoViewController = vc;
    [self checkIfImageUploadable];
    if(index != 0){
        PhotoViewController *tmp = [PhotoViewController photoViewControllerForPageIndex:(index - 1) andImageArray:self.imageContentArray];
        tmp.delegate = self;
        return tmp;
    }else{
        return nil;
    }
}

- (UIViewController *)pageViewController:(UIPageViewController *)pvc viewControllerAfterViewController:(PhotoViewController *)vc
{

    NSUInteger index = vc.pageIndex;
    currentIndex = index;
    curPhotoViewController = vc;
    [self checkIfImageUploadable];
    if(index < [self.imageContentArray count]){
        PhotoViewController *tmp = [PhotoViewController photoViewControllerForPageIndex:(index + 1) andImageArray:self.imageContentArray];
        tmp.delegate = self;
        return tmp;
    }else{
        return nil;
    }
}

- (void)initializePageController{
    NSDictionary *options =
    [NSDictionary dictionaryWithObject:
     [NSNumber numberWithInteger:UIPageViewControllerSpineLocationMin]
                                forKey: UIPageViewControllerOptionSpineLocationKey];
    
    self.pageController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:options];
    self.pageController.view.backgroundColor = [UIColor blackColor];
    
    self.pageController.delegate = self;
    self.pageController.dataSource = self;
    [self.pageController.view setFrame:self.view.bounds];
}


- (void)setupPageControlleratIndex:(NSInteger) index{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    if([self.imageContentArray count] > 0){
        NSLog(@"self.imageContentArray count %d", [self.imageContentArray count]);
        PhotoViewController *pageZero = [PhotoViewController photoViewControllerForPageIndex:index andImageArray:self.imageContentArray];
        pageZero.delegate = self;
        [self.pageController setViewControllers:@[pageZero]
                                      direction:UIPageViewControllerNavigationDirectionForward
                                       animated:YES
                                     completion:^(BOOL finished){
                                     }];
        [self checkIfImageUploadable];

    }else{
        if([self.imageContentArray count] > 0){
        }else{
            hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            [self.view sendSubviewToBack:hud];
            hud.mode = MBProgressHUDModeText;
            hud.labelText = @"No Images";
        }
        return;
    }
    [self addChildViewController:self.pageController];
    [self.view addSubview:self.pageController.view];
    [self.pageController didMoveToParentViewController:self];
    [self.view sendSubviewToBack:self.pageController.view];

}
- (void)setupPageController{
    [MBProgressHUD hideHUDForView:self.view animated:YES];    
    if([self.imageContentArray count] > 0){
        NSLog(@"self.imageContentArray count %d", [self.imageContentArray count]);
        PhotoViewController *pageZero = [PhotoViewController photoViewControllerForPageIndex:0 andImageArray:self.imageContentArray];
        pageZero.delegate = self;
        [self.pageController setViewControllers:@[pageZero]
                                 direction:UIPageViewControllerNavigationDirectionForward
                                  animated:YES
                                completion:nil];
    }else{
        if([self.imageContentArray count] > 0){
        }else{
            hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            [self.view sendSubviewToBack:hud];
            hud.mode = MBProgressHUDModeText;
            hud.labelText = @"No Images";
        }
        return;
    }
    [self addChildViewController:self.pageController];
    [self.view addSubview:self.pageController.view];
    [self.pageController didMoveToParentViewController:self];
    [self.view sendSubviewToBack:self.pageController.view];
}
- (void)fetchImageFromDataBase {
    NSLog(@"fetch image from database");
    NSFetchRequest* fetchRequest = [Image fetchRequest];
    NSSortDescriptor* sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"id" ascending:NO];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    NSArray *_imageArray = [Image objectsWithFetchRequest:fetchRequest];
    if(!self.imageContentArray){
        self.imageContentArray = [NSMutableArray arrayWithArray:_imageArray];
    }
    else{
        for (Image *image in _imageArray) {
            [self.imageContentArray addObject:image];
            NSLog(@"id: %@", image.id);
            NSLog(@"url: %@", image.imageURL);
            NSLog(@"path: %@", image.imagePath);
            NSLog(@"cordinateX: %@", image.cordinateX);
            NSLog(@"cordinateY: %@", image.cordinateY);
        }
    }

    NSLog(@"%d", [self.imageContentArray count]);
}


#pragma mark RKObjectLoaderDelegate

- (void)initializeRKObject{
    if(!objectManager) {
        objectManager = [RKObjectManager objectManagerWithBaseURLString:ServerURL];
        RKManagedObjectStore *objectStore = [RKManagedObjectStore objectStoreWithStoreFilename:RKDefaultSeedDatabaseFileName];
        objectManager.objectStore = objectStore;
        objectManager.serializationMIMEType = RKMIMETypeJSON;
        RKManagedObjectMapping* imageMapping = [RKManagedObjectMapping mappingForClass:[Image class] inManagedObjectStore:objectStore];
        [imageMapping mapKeyPath:@"url" toAttribute:@"imageURL"];
        [imageMapping mapKeyPath:@"X" toAttribute:@"cordinateX"];
        [imageMapping mapKeyPath:@"Y" toAttribute:@"cordinateY"];
        [imageMapping mapKeyPath:@"time" toAttribute:@"uploadTime"];
        [imageMapping mapKeyPath:@"id" toAttribute:@"id"];
        imageMapping.primaryKeyAttribute = @"id";
        [objectManager.mappingProvider setMapping:imageMapping forKeyPath:@"images"];
    }
    int lastindex = [userInfoManager_ getLastImageIndex];
    if(!lastindex) lastindex = -1;
    NSLog(@"lastindex : %d", lastindex);
    NSString *url = [NSString stringWithFormat:@"/get_photos.py?last_view=%d&family_id=%@",lastindex,userInfoManager_.getFamilyid];
    [objectManager loadObjectsAtResourcePath:url delegate:self];
}

- (void)objectLoader:(RKObjectLoader*)objectLoader didLoadObjects:(NSArray*)objects {
    RKLogInfo(@"Load collection of Images: %@", objects);
    int lastindex = 0;
    if(objects.count > 0) {
        Image *firstImage = objects[0];
        lastindex = [firstImage.id intValue];
        [[NSUserDefaults standardUserDefaults] setInteger:lastindex forKey:@"lastIndex" ];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    for (Image *image in objects) {
        NSLog(@"id: %@", image.id);
        
        NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString *filePath = [NSString stringWithFormat:@"%@/%@_imagedata",docDir, image.id];
        image.imagePath = filePath;
        NSError *error;
        [image.managedObjectContext save:&error];
        if(error) NSLog(@"%@",[error description]);
        BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:filePath];
        if (fileExists) {
            NSLog(@"fileExists");
        }
        if (!fileExists) {
            NSData *data =  [NSData dataWithContentsOfURL:[NSURL URLWithString: image.imageURL]];
            [data writeToFile:filePath atomically:YES];
        }
        
        
        // potentially this should be the better choice if we have to wait for tons of flies at first
        
        //put into different thread
        /*
         
         dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
         NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
         
         NSString *filePath = [NSString stringWithFormat:@"%@/%@_imagedata",docDir, image.id];
         NSLog(@"path: %@", filePath);
         image.imagePath = filePath;
         BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:filePath];
         if (!fileExists) {
         NSData *data =  [NSData dataWithContentsOfURL:[NSURL URLWithString: image.imageURL]];
         [data writeToFile:filePath atomically:YES];
         
         }
         dispatch_async(dispatch_get_main_queue(), ^{
         // Update the UI
         });
         });
         
         */
    }
    if(lastindex!=0){
        [userInfoManager_ setlastImageIndex:lastindex];
        [userInfoManager_ saveUserDefault];
    }
    [NSTimer scheduledTimerWithTimeInterval:0 target:self selector:@selector(goToSecondButton:) userInfo:nil repeats:NO];
}

- (void)goToSecondButton:(id)sender {
    [self fetchImageFromDataBase];
    [self setupPageController];
}
- (void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error {
    NSString *msg = [NSString stringWithFormat:@"Error: %@", [error localizedDescription]];
    hud.labelText = @"Internal Server Error";
    NSLog(@"log : %@",msg);
}

- (void)setupmainController{
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"Loading";
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
    
    self.imageContentArray = [[NSMutableArray alloc] init];
    
    [self initializePageController];
    [self initializeRKObject];
}


- (void)viewDidLoad
{
    //ANN: before continuing everything it should make sure that client is first connected.
    [super viewDidLoad];
    UPLOADIMAGE = 0;
    prevIndex = 0;
    currentIndex = 0; 
    userInfoManager_ = [UserInfoManager sharedInstance];
    [userInfoManager_ fetchUserDefault];
    [userInfoManager_ printUserDefault];

    self.view.backgroundColor = [UIColor blackColor];

    
//    [self fetchImageFromDataBase];
//    [self setupPageController];
  
    
    storyboard = [UIStoryboard storyboardWithName:
                  @"MainStoryboard_iPhone" bundle:[NSBundle mainBundle]];
    
    [self.view bringSubviewToFront:self.UploadImageButton];
    [self.view bringSubviewToFront:self.ShowProfileButton];
    [self.view bringSubviewToFront:self.PickImageButton];
    [self.view bringSubviewToFront:self.TakeImageButton];
    [self.view bringSubviewToFront:self.LoadImagebutton];
    [self hideMainInterface];
//    self.ContainerView.backgroundColor = [UIColor clearColor];
    self.ContainerView.hidden = YES;
    self.ShowProfileButton.hidden = YES;
    self.PickImageButton.hidden = YES;
    self.TakeImageButton.hidden = YES;
    self.UploadImageButton.hidden = YES;
    self.LoadImagebutton.hidden = YES;
    inSession = NO; //not in login session
    
    userInfoManager_ = [UserInfoManager sharedInstance];
    [userInfoManager_ fetchUserDefault];
    [userInfoManager_ printUserDefault];
    
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:NO];

    [UIInitializer initializeContainView: self.ContainerView];
    self.view.backgroundColor = [UIColor blackColor];
    //Initialized the position for the frame, for somereason it will never be at the center
    
    if(userInfoManager_.userName){
        [self pushDownContainerAndSwitchToProfile];
    }else{
        if(userInfoManager_.invitationCode){
            [self setUpInvitationView];
        }else{
            [self setupLoginView];
        }
    }
//    [self setupInitial];
}

- (IBAction)LoadImage:(id)sender {
    self.ContainerView.hidden = YES;
    [self setUpSlider];
}

- (void)quitViewController: (UIViewController *)c{
    [AnimationHelper removeGradient:self.view];
    if([c isViewLoaded] ){
        [UIView
         transitionFromView:c.view
         toView:self.ContainerView
         duration:0.25f
         options:UIViewAnimationOptionTransitionCrossDissolve
         completion:^(BOOL finished) {
             [c removeFromParentViewController];
             [AnimationHelper removeGradient:self.view];
         }];
    }
    
}
- (void)adjustContainViewFrame{
    if(self.ContainerView.frame.origin.y==710 || self.ContainerView.frame.origin.y==338 ){
    }else{
        float distance = self.view.bounds.size.height - self.ContainerView.bounds.origin.y;
        CGPoint point = CGPointMake(self.ContainerView.center.x, self.ContainerView.center.y+distance);
        self.ContainerView.center = point;
        PrintFrame(self.ContainerView.frame);
    }
}
#pragma mark buttons
- (IBAction)ShowProfile:(id)sender {
    self.ShowProfileButton.hidden = YES;
    [self adjustContainViewFrame];
    inSession = YES;
    self.ContainerView.hidden = NO;
    float distance = self.view.bounds.size.height - self.ContainerView.bounds.origin.y;
    NSLog(@"height %f %f", distance, self.ContainerView.bounds.origin.y);
    CGPoint point = CGPointMake(self.ContainerView.center.x, self.ContainerView.center.y-distance);
    [UIView animateWithDuration:1.0 delay:0.0 options:UIViewAnimationCurveLinear
                     animations:^{
                         self.ContainerView.center = point;
                     }
                     completion:^(BOOL finished){
                         if([self.ShowProfileButton.titleLabel.text isEqual:@"Log in"]){
                             [self.ShowProfileButton setTitle:@"Profile" forState:UIControlStateNormal];
                             [self.ShowProfileButton setTitle:@"Profile" forState:UIControlStateSelected];
                             [self.ShowProfileButton setTitle:@"Profile" forState:UIControlStateHighlighted];
                         }
                         [self hideMainInterface];
                     }];
}
- (IBAction)PickImage:(id)sender {
    self.ContainerView.hidden = YES;
    tmpImageContent = [[NSMutableArray alloc] init];
    UIImagePickerController *pickerC = [[UIImagePickerController alloc] init];
    pickerC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    pickerC.delegate = self;
    [self presentViewController:pickerC animated:YES completion:nil];
}

- (IBAction)TakeImage:(id)sender {
    self.ContainerView.hidden = YES;
    UIImagePickerController *pickerC = [[UIImagePickerController alloc] init];
    pickerC.sourceType = UIImagePickerControllerSourceTypeCamera;
    pickerC.delegate = self;
    [self presentViewController:pickerC animated:YES completion:nil];
}

- (UIImage *)CurrentImage{
    __block UIImage *image = nil;
    if([[self.imageContentArray objectAtIndex:currentIndex] isKindOfClass:[Image class]]){
        Image *image = [self.imageContentArray objectAtIndex:currentIndex];
        NSData *imageData = [[NSFileManager defaultManager] contentsAtPath:image.imagePath];
        return [UIImage imageWithData:imageData];
    }
    if([[self.imageContentArray objectAtIndex:currentIndex] isKindOfClass:[UIImage class]]){
        return [self.imageContentArray objectAtIndex:currentIndex];
    }
    if([[self.imageContentArray objectAtIndex:currentIndex] isKindOfClass:[NSDictionary class]]){
        NSDictionary *info = [self.imageContentArray objectAtIndex:currentIndex];
        ALAssetsLibrary *assetLibrary=[[ALAssetsLibrary alloc] init];        
        dispatch_semaphore_t sema = dispatch_semaphore_create(0);
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0);

        dispatch_async(queue, ^{
            [assetLibrary assetForURL:[info objectForKey:@"UIImagePickerControllerReferenceURL"] resultBlock:^(ALAsset *asset) {
                ALAssetRepresentation *rep = [asset defaultRepresentation];
                Byte *buffer = (Byte*)malloc(rep.size);
                NSUInteger buffered = [rep getBytes:buffer fromOffset:0.0 length:rep.size error:nil];
                NSData *data = [NSData dataWithBytesNoCopy:buffer length:buffered freeWhenDone:YES];
                image = [UIImage imageWithData:data];
                dispatch_semaphore_signal(sema);
            } failureBlock:^(NSError *err) {
                NSLog(@"Error: %@",[err localizedDescription]);
                dispatch_semaphore_signal(sema);
            }];
        });
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    }
    return image;
}

- (IBAction)UploadImage:(id)sender {
    [self checkIfImageUploadable];
    UPLOADIMAGE = 1;

    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeDeterminate;
    hud.labelText = @"Uploading";
    
    RKParams *params = [RKParams params];
    
    NSData* imageData = UIImageJPEGRepresentation([self CurrentImage], 0.3);
    
    if(!imageData) NSLog(@"no imageData");
    [params setValue:userInfoManager_.getFamilyid forParam:@"family_id"];
    [params setValue:@"1,2" forParam:@"coordinates"];
    [params setValue:userInfoManager_.userName forParam:@"user_name"];
    [params setData:imageData MIMEType:@"image/jpeg" forParam:@"uploadFile"];
    [[RKClient sharedClient] post:@"/try.py" params:params delegate:self];
}

#pragma mark UIpopoverControllerDelegate

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController {
    //    NSLog(@"%d choosen images", [imageReferenceURLs count]);
    //    [self displayChoosenImages];
    //    imageReferenceURLs = [[NSMutableArray alloc] init];
}

#pragma mark UIImagePickerControllerDelegate

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    NSLog(@"imagePickerControllerDidCancel");
    
    inSession = NO;
    [self dismissViewControllerAnimated:YES completion:^(){
        [self.pageController.view removeFromSuperview];
        [self initializePageController];
        [self setupPageController];
    }];
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    if(!error){
        NSLog(@"didFinishPickingMediaWithInfo");
        [self dismissViewControllerAnimated:YES completion:^(){
            [self.pageController.view removeFromSuperview];
            [self initializePageController];
            [self setupPageController];
        }];
    }else{
        NSLog(@"Problem saving image from camera");
    }
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    NSLog(@"didFinishPickingMediaWithInfo");
    if(picker.sourceType == UIImagePickerControllerSourceTypeCamera){
        UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
        [self.imageContentArray insertObject:image atIndex:0];
    }else{
        [self.imageContentArray insertObject:info atIndex:0];
        NSLog(@"%@", [info objectForKey:@"UIImagePickerControllerReferenceURL"]);
    }
}

- (void)hideMainInterface{
    self.ShowProfileButton.hidden = YES;
    self.TESTIND.hidden = YES;
}
- (void)unHideMainInterface{
    [UIView animateWithDuration:1.0 delay:0.0 options:UIViewAnimationOptionShowHideTransitionViews
                     animations:^{
                         self.ShowProfileButton.hidden = NO;
                         self.ContainerView.hidden = NO;
                         self.PickImageButton.hidden = NO;
                         self.TakeImageButton.hidden = NO;
                         self.UploadImageButton.hidden = NO;
                         self.LoadImagebutton.hidden = NO;
                     }completion:nil];
    self.TESTIND.hidden = NO;
    
}

- (void) touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event {
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark Demo interface setup

- (void)setUpDemoButtons{
    IPHONE = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)? TRUE : FALSE;
    CGRect frame;
    showImageButton_ = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    frame = IPHONE? CGRectMake(20, 20, 74, 44): CGRectMake(244, 50, 74, 44);
    [showImageButton_ setFrame:frame];
    [showImageButton_ setTitle:@"Show" forState:UIControlStateNormal];
    [showImageButton_ addTarget:self action:@selector(handleshowImageButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    sendImageButton_ = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    frame = IPHONE? CGRectMake(124, 20, 74, 44): CGRectMake(348, 50, 74, 44);
    [sendImageButton_ setFrame:frame];
    [sendImageButton_ setTitle:@"Send" forState:UIControlStateNormal];
    [sendImageButton_ addTarget:self action:@selector(handlesendImageButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    deleteImageButton_ = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    
    frame = IPHONE? CGRectMake(226, 20, 74, 44): CGRectMake(450, 50, 74, 44);
    [deleteImageButton_ setFrame:frame];
    [deleteImageButton_ setTitle:@"Delete" forState:UIControlStateNormal];
    [deleteImageButton_ addTarget:self action:@selector(handledeleteImageButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:showImageButton_];
    [self.view addSubview:sendImageButton_];
    [self.view addSubview:deleteImageButton_];
    
    /*Buttons for demo functionalities*/
    
    showDrawingButton_ = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    frame = IPHONE? CGRectMake(20, 84, 74, 44): CGRectMake(244, 50, 74, 44);
    [showDrawingButton_ setFrame:frame];
    [showDrawingButton_ setTitle:@"Draw" forState:UIControlStateNormal];
    [showDrawingButton_ addTarget:self action:@selector(handleshowSrawingButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    showAnimationButton_ = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    frame = IPHONE? CGRectMake(124, 84, 74, 44): CGRectMake(348, 50, 74, 44);
    [showAnimationButton_ setFrame:frame];
    [showAnimationButton_ setTitle:@"Flip" forState:UIControlStateNormal];
    [showAnimationButton_ addTarget:self action:@selector(handleshowAnimationButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:showDrawingButton_];
    [self.view addSubview:showAnimationButton_];
    
    UIButton *UserDemoButton_ = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    frame = IPHONE? CGRectMake(226, 84, 74, 44): CGRectMake(450, 50, 74, 44);
    [UserDemoButton_ setFrame:frame];
    [UserDemoButton_ setTitle:@"User" forState:UIControlStateNormal];
    [UserDemoButton_ addTarget:self action:@selector(handleUserDemoButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:UserDemoButton_];
    
}


- (void) setupInitial{
    TESTING = TRUE;
    
    NSLog(@"setUpInitial");
    [self setUpDemoButtons];
    imageViewCount = 0;
    imageViewArray_ = [[NSMutableArray alloc] init];
    imageReferenceURLs = [[NSMutableArray alloc] init];
    
    imagePicker_ = [[UIImagePickerController alloc] init];
    imagePicker_.delegate = self;
    imagePicker_.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    if(!IPHONE){
        popoverController_ = [[UIPopoverController alloc] initWithContentViewController:imagePicker_];
        popoverController_.delegate = self;
    }
    deleteMode = FALSE;
    client_ = [RKClient clientWithBaseURL:[NSURL URLWithString:ServerURL]];
    
    progressBar = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleBar];
    [progressBar setFrame:CGRectMake(20, 367, 280, 11)];
    progressBar.progress = 0.00999999;
    
    [self.view addSubview:progressBar];
    
    self.isIdle = [NSNumber numberWithBool:YES];
    [self addObserver:self forKeyPath:@"isIdle" options:NSKeyValueObservingOptionOld context:nil];
    self.isIdle = [NSNumber numberWithBool:YES];
    
    
    //on registering new user    
    
}




- (void) handlesendImageButtonTapped:(id *)sender{
    NSLog(@"handleshowImageButtonTapped");
//    draggableImageView *view = (draggableImageView *)[self.view viewWithTag:1];
//    [uploadListener_ upload: view.image];
//    progressBar.progress = InitialProgress;
    progressBar.hidden = NO;
}

- (void) handledeleteImageButtonTapped:(id *)sender{
    NSLog(@"handledeleteImageButtonTapped");
    switch (deleteMode) {
        case TRUE:
            deleteMode = FALSE;
            break;
        case FALSE:
            deleteMode = TRUE;
            break;
        default:
            break;
    }
    
    deleteMode? NSLog(@"deleteMode TRUE"): NSLog(@"deleteMode FALSE");
}

- (void)handleshowSrawingButtonTapped:(id *)sender{
    NSLog(@"handleshowSrawingButtonTapped");
    NSLog(@"%d", imageViewCount);
    draggableImageView *view;
    
    for(int i = 1; i< imageViewCount+1; i++){
        view = (draggableImageView *)[self.view viewWithTag:i];
        UIImage *image = view.image;
        CGSize size = view.image.size;
        float ratio = view.frame.size.width/self.view.frame.size.width;
        UIImage *scaledImage = [image scaleToSize:CGSizeMake(size.width*ratio,size.height*ratio)];
        
        //pass in three parameters right now, the imageview, the center and the degree of rotation;
        
        view.image = scaledImage;
        
        [imageViewArray_ addObject:view];
    }
    NSLog(@"%d", [imageViewArray_ count]);
    
    
    SecondViewController *aSecondViewController = [[SecondViewController alloc] init];
    aSecondViewController.imageViewArray_ = imageViewArray_;
    
    [self.navigationController pushViewController:aSecondViewController animated:YES];
    
    
}

- (void)handleshowAnimationButtonTapped:(id *)sender{
    NSLog(@"handleshowAnimationButtonTapped");
    
    //    AnimationViewController *aAnimationViewController = [[AnimationViewController alloc] init];
    ViewControllerWithFlip *aViewControllerWithFlip = [[ViewControllerWithFlip alloc] init];
    [self.navigationController pushViewController:aViewControllerWithFlip animated:YES];
    //    [self.navigationController pushViewController:aAnimationViewController animated:YES];
    
}

- (void) displayChoosenImages {
    
    int imageHeight = IPHONE? 120: 240;
    int imageWidth = IPHONE? 80: 160;
    int viewHeight = (int) self.view.frame.size.height - imageHeight;
    int viewWidth = (int) self.view.frame.size.width - imageWidth;
    
    for(int i= imageViewCount; i< imageViewCount+[imageReferenceURLs count]; i++){
        NSDictionary *info = [imageReferenceURLs objectAtIndex:(i-imageViewCount)];
        UIImage *aImage = [info objectForKey:UIImagePickerControllerOriginalImage];
        
        int imageX = arc4random() %(viewWidth);
        int imageY = arc4random() %(viewHeight);
        CGRect frame = CGRectMake(imageX, imageY, imageWidth, imageHeight);
        UIImageView *adraggableImageView = [[draggableImageView alloc] initWithFrame:frame];
        [adraggableImageView setImage:aImage];
        [adraggableImageView setUserInteractionEnabled:YES];
        adraggableImageView.tag = i+1;
        
        UIGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handletappingImage:)];
        [adraggableImageView addGestureRecognizer:tap];
        
        [self.view addSubview:adraggableImageView];
    }
    imageViewCount += [imageReferenceURLs count];
}


-(void)handletappingImage:(UITapGestureRecognizer *)recognizer{
    if(deleteMode){
        UIImageView *view = (UIImageView *)recognizer.view;
        NSLog(@"removing subview of tag %d", view.tag);
        [view removeFromSuperview];
        NSLog(@"subviews count %d", [[self.view subviews] count]);
    }
}


- (void)transitionFromViewController:(UIViewController *)fromViewController toViewController:(UIViewController *)toViewController
{
	if (fromViewController == toViewController)
	{
		return;
	}
	toViewController.view.frame = self.ContainerView.bounds;
	toViewController.view.autoresizingMask = self.ContainerView.autoresizingMask;
    
	[fromViewController willMoveToParentViewController:nil];
	[self addChildViewController:toViewController];
    
	[self transitionFromViewController:fromViewController
					  toViewController:toViewController
							  duration:0.4
							   options:UIViewAnimationOptionTransitionFlipFromRight
							animations:^{
							}
							completion:^(BOOL finished) {
								[toViewController didMoveToParentViewController:self];
								[fromViewController removeFromParentViewController];
							}];
}


#pragma mark SignUp2GSInfoViewControllerDelegate
- (void)LeaveSignUp2GSInfoView:(SignUp2GSInfoViewController *)controller{
    SignUp2GrandSonViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"SignUp2GrandSonViewController"];
    vc.delegate = self;
    [self transitionFromViewController:controller toViewController:vc];
}


#pragma mark SignUp2GrandMaViewControllerDelegate
- (void)LeaveSignUp2GrandMaView:(SignUp2GrandMaViewController *)controller{
    SingUp1ViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"SingUp1ViewController"];
    vc.delegate = self;
    [self transitionFromViewController:controller toViewController:vc];    
}


#pragma mark SignUp2GrandSonViewControllerDelegate
- (void)LeaveSignUp2GrandSonView:(SignUp2GrandSonViewController *)controller{
    SingUp1ViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"SingUp1ViewController"];
    vc.delegate = self;
    [self transitionFromViewController:controller toViewController:vc];
    currentChildController = vc;
}
- (void)ExitSignUp2GrandSonViewInfo:(SignUp2GrandSonViewController *)controller{
    inSession = NO;
    float distance = self.view.bounds.size.height - self.ContainerView.bounds.origin.y;
    CGPoint point = CGPointMake(self.ContainerView.center.x, self.ContainerView.center.y+distance);
    [UIView animateWithDuration:1.0 delay:0.0 options:UIViewAnimationCurveLinear
                     animations:^{
                         self.ContainerView.center = point;
                     }
                     completion:^(BOOL finished){
                         [self setUpSlider];
                         UserProfileViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"UserProfileViewController"];
                         [self transitionFromViewController:currentChildController toViewController:vc];
                         vc.delegate = self;
                         currentChildController = vc;
                     }];
    [userInfoManager_ fetchUserDefault];
}

- (void)ShowSignUp2GrandSonViewInfo:(SignUp2GrandSonViewController *)controller{
    SignUp2GSInfoViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"SignUp2GSInfoViewController"];
    vc.delegate = self;
    [self transitionFromViewController:controller toViewController:vc];
    currentChildController = vc;
}
#pragma mark SignUp1InfoViewControllerDelegate
- (void)LeaveSignUp1InfoView:(SignUp1InfoViewController *)controller{
    SingUp1ViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"SingUp1ViewController"];
    vc.delegate = self;
    [self transitionFromViewController:controller toViewController:vc];
    currentChildController = vc;
}
#pragma mark SingUp1ViewControllerDelegate
- (void)LeaveSingUp1View:(SingUp1ViewController *)controller{
    LoginController *vc = [storyboard instantiateViewControllerWithIdentifier:@"LoginController"];
    vc.delegate = self;
    [self transitionFromViewController:controller toViewController:vc];
    currentChildController = vc;
}
- (void)WaitForInvitation:(SingUp1ViewController *)controller{
    SignUp2GrandMaViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"SignUp2GrandMaViewController"];
    vc.delegate = self;
    [self transitionFromViewController:controller toViewController:vc];
    currentChildController = vc;
}
- (void)StartAChannel:(SingUp1ViewController *)controller{
    SignUp2GrandSonViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"SignUp2GrandSonViewController"];
    vc.delegate = self;
    [self transitionFromViewController:controller toViewController:vc];
    currentChildController = vc;
}
- (void)ShowInfo:(SingUp1ViewController *)controller{
    SignUp1InfoViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"SignUp1InfoViewController"];
    vc.delegate = self;
    [self transitionFromViewController:controller toViewController:vc];
    currentChildController = vc;
}

-(void)EnterSignUp1View:(LoginController *)controller{
    SingUp1ViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"SingUp1ViewController"];
    vc.delegate = self;
    [self transitionFromViewController:controller toViewController:vc];
    currentChildController = vc;
}

-(void)ExitFromView{
    float distance = self.view.bounds.size.height - self.ContainerView.bounds.origin.y;
    CGPoint point = CGPointMake(self.ContainerView.center.x, self.ContainerView.center.y+distance);
    [UIView animateWithDuration:1.0 delay:0.0 options:UIViewAnimationCurveLinear
                     animations:^{
                         self.ContainerView.center = point;
                     }
                     completion:^(BOOL finished){
                         if(!userInfoManager_.userName){
                             self.ShowProfileButton.hidden = NO;
                             [self.ShowProfileButton setTitle:@"Log in" forState:UIControlStateNormal];
                             [self.ShowProfileButton setTitle:@"Log in" forState:UIControlStateSelected];
                             [self.ShowProfileButton setTitle:@"Log in" forState:UIControlStateHighlighted];
                             LoginController *vc = [storyboard instantiateViewControllerWithIdentifier:@"LoginController"];
                             vc.delegate = self;
                             [self transitionFromViewController:currentChildController toViewController:vc];
                             currentChildController = vc;
                         }else{
//                             [self setUpSlider];
                         }
                     }];
}

-(void)ExitFromLoginView:(LoginController *)controller{
    inSession = NO;
    float distance = self.view.bounds.size.height - self.ContainerView.bounds.origin.y;
    CGPoint point = CGPointMake(self.ContainerView.center.x, self.ContainerView.center.y+distance);
    [UIView animateWithDuration:1.0 delay:0.0 options:UIViewAnimationCurveLinear
                     animations:^{
                         self.ContainerView.center = point;
                     }
                     completion:^(BOOL finished){
                         [self setUpSlider];
                         UserProfileViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"UserProfileViewController"];
                         [self transitionFromViewController:currentChildController toViewController:vc];
                         vc.delegate = self;
                         currentChildController = vc;
                     }];
    [userInfoManager_ fetchUserDefault];
}

#pragma mark UserProfileViewControllerdelegate
- (void)LeaveUserProfileView:(UserProfileViewController *)controller{
    GrandSonInviteController *vc = [storyboard instantiateViewControllerWithIdentifier:@"GrandSonInviteController"];
    vc.delegate = self;
    [self transitionFromViewController:currentChildController toViewController:vc];
    currentChildController = vc;
}
-(void)ExitFromProfileView:(UserProfileViewController *)controller{
    inSession = NO;
    self.ShowProfileButton.hidden = NO;
//    self.ContainerView.hidden = 
    [self ExitFromView];
}
#pragma mark SignUp2GrandMaViewControllerdelegate
- (void)ExitFromSignUp2GrandMaView:(SignUp2GrandMaViewController *)controller{
    inSession = NO; 
    [self ExitFromView];
    [userInfoManager_ fetchUserDefault];
}
- (void)InvitedAndExitFromSignUp2GrandMaView:(SignUp2GrandMaViewController *)controller{
    inSession = NO;
    float distance = self.view.bounds.size.height - self.ContainerView.bounds.origin.y;
    CGPoint point = CGPointMake(self.ContainerView.center.x, self.ContainerView.center.y+distance);
    [UIView animateWithDuration:1.0 delay:0.0 options:UIViewAnimationCurveLinear
                     animations:^{
                         self.ContainerView.center = point;
                     }
                     completion:^(BOOL finished){
                         [self setUpSlider];
                         UserProfileViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"UserProfileViewController"];
                         [self transitionFromViewController:currentChildController toViewController:vc];
                         vc.delegate = self;
                         currentChildController = vc;
                     }];
    [userInfoManager_ fetchUserDefault];
}


#pragma mark GrandSonInviteControllerdelegate
- (void)LeaveGrandSonInviteView:(GrandSonInviteController *)controller{
    UserProfileViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"UserProfileViewController"];
    vc.delegate = self;
    [self transitionFromViewController:currentChildController toViewController:vc];
    currentChildController = vc;
}
- (void)ExitFromGrandSonInviteView:(GrandSonInviteController *)controller{
    [self ExitFromView];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"Login"])
    {
        LoginController *vc = [segue destinationViewController];
        vc.delegate =self;
        currentChildController = vc;
        [self addChildViewController:vc];
    }
}


- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    if(!inSession)  self.ContainerView.hidden = YES;
    if(inSession) self.ShowProfileButton.hidden = YES;
    currentChildController.view.frame = self.ContainerView.bounds;
}

#pragma mark RKRequestdelegate

- (void)request:(RKRequest *)request didFailLoadWithError:(NSError *)error{
    NSLog(@"didFailLoadWithError: %@", error.localizedDescription);
    if(UPLOADIMAGE){
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }
}

- (void)request:(RKRequest *)request didLoadResponse:(RKResponse *)response{
    NSLog(@"didLoadResponse: %@", response.bodyAsString);
    if(UPLOADIMAGE){
        currentIndex = curPhotoViewController.pageIndex;
        [self.imageContentArray removeObjectAtIndex:curPhotoViewController.pageIndex];
        if([self.imageContentArray count]>0 && curPhotoViewController.pageIndex < [self.imageContentArray count]){
            [UIView animateWithDuration:0.5 animations:^{
                self.pageController.view.alpha = 0;
            }
                             completion:^(BOOL finished){
                                 [self.pageController.view removeFromSuperview];
                                 [self initializePageController];
                                 [self setupPageControlleratIndex:curPhotoViewController.pageIndex];
                             }];
        }else{
            if(curPhotoViewController.pageIndex == [self.imageContentArray count]){
                [UIView animateWithDuration:0.5 animations:^{
                    self.pageController.view.alpha = 0;
                }
                                 completion:^(BOOL finished){
                                     [self.pageController.view removeFromSuperview];
                                     [self initializePageController];
                                     [self setupPageController];
                                 }];
            }
        }
    }
    self.UploadImageButton.hidden = YES;
    UPLOADIMAGE = 0;
}
- (void)request:(RKRequest *)request didReceivedData:(NSInteger)bytesReceived totalBytesReceived:(NSInteger)totalBytesReceived totalBytesExectedToReceive:(NSInteger)totalBytesExpectedToReceive
{
    NSLog(@"didReceivedData");
}
- (void)request:(RKRequest *)request didSendBodyData:(NSInteger)bytesWritten totalBytesWritten:(NSInteger)totalBytesWritten totalBytesExpectedToWrite:(NSInteger)totalBytesExpectedToWrite
{
    float percentage = totalBytesWritten/(float)totalBytesExpectedToWrite;
    NSLog(@"percentage %f", percentage);
    if(UPLOADIMAGE){
        hud.progress = percentage;
    }
    if (percentage==1) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }
}
- (void)requestDidCancelLoad:(RKRequest *)request
{
}
- (void)requestDidStartLoad:(RKRequest *)request
{
    NSLog(@"requestDidStartLoad");
}
- (void)requestDidTimeout:(RKRequest *)request
{
    if(UPLOADIMAGE){
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }
    NSLog(@"requestDidTimeout");
}

@end

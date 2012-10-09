//
//  SecondViewController.m
//  Demo
//
//  Created by Tzu-Yang Ni on 10/5/12.
//  Copyright (c) 2012 Tzu-Yang Ni. All rights reserved.
//

#import "SecondViewController.h"
#import "UIImage+scale.h"

@interface SecondViewController (){
    CGPoint lastPoint;
    UIImageView *drawImage;
    bool mouseSwiped;
    CGFloat red;
    CGFloat green;
    CGFloat blue;
    CGFloat brush;
    CGFloat opacity;
    CGSize finalSize;
}

@end

@implementation SecondViewController
@synthesize imageViewArray_;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        UIView *view = [[UIView alloc] initWithFrame:self.view.frame];
        view.backgroundColor = [UIColor whiteColor];
        self.view = view;
        UIButton *sendImageButton_ = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        CGRect frame = CGRectMake(124, 20, 74, 44);
        [sendImageButton_ setFrame:frame];
        [sendImageButton_ setTitle:@"Save" forState:UIControlStateNormal];
        [sendImageButton_ addTarget:self action:@selector(handlesendImageButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:sendImageButton_];
        imageViewArray_ = [[NSMutableArray alloc] init];
        
        drawImage = [[UIImageView alloc] initWithFrame:self.view.frame];
        drawImage.backgroundColor = [UIColor clearColor];
        [self.view addSubview:drawImage];
    }
    return self;
}
- (CGSize)makeSize:(CGSize)originalSize fitInSize:(CGSize)boxSize
{
    float widthScale = 0;
    float heightScale = 0;
    
    widthScale = boxSize.width/originalSize.width;
    heightScale = boxSize.height/originalSize.height;
    float scale = MIN(widthScale, heightScale);
    CGSize newSize = CGSizeMake(originalSize.width * scale, originalSize.height * scale);
    return newSize;
}

- (void)setUpImageViews{
    for(draggableImageView *view in imageViewArray_){
        [view setUserInteractionEnabled:NO];
        [self.view addSubview:view];
        [self.view sendSubviewToBack:view];
    }


}

- (void)viewWillAppear:(BOOL)animated{
    if(imageViewArray_){
        finalSize = CGSizeMake(640, 960);        
        [self setUpImageViews];
        
    }else{
        NSLog(@"No ImageView");
    }    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"viewDidLoad");
    red = 0.0/255.0;
    green = 0.0/255.0;
    blue = 0.0/255.0;
    brush = 10.0;
    opacity = 1.0;
}

- (void) handlesendImageButtonTapped:(id *)sender{
    NSLog(@"handleshowImageButtonTapped");
    //saving the drawing directly.
//    UIGraphicsBeginImageContextWithOptions(drawImage.bounds.size, NO,0.0);
//    [drawImage.image drawInRect:CGRectMake(0, 0, drawImage.frame.size.width, drawImage.frame.size.height)];
//    UIImage *SaveImage = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    UIImageWriteToSavedPhotosAlbum(SaveImage, self,@selector(image:didFinishSavingWithError:contextInfo:), nil);
    
    if([imageViewArray_ count]){

        UIImage *maskImage = drawImage.image;
        CGSize maskImageSize = [maskImage size];
        
        UIGraphicsBeginImageContext(finalSize);
        
        for(int i = 0; i< [imageViewArray_ count]; i++){
            
            draggableImageView *imageview = [imageViewArray_ objectAtIndex:i];
            UIImage *rawImage = [imageview.image imageRotatedByRadians:imageview.angle];
    
//            NSLog(@"maskImageSize %@", NSStringFromCGSize(maskImageSize));
//            NSLog(@"finalSize %@", NSStringFromCGSize(finalSize));
            
            float widthRatio = finalSize.width/self.view.frame.size.width;
            float heightRatio = finalSize.height/self.view.frame.size.height;
            
            CGSize size = rawImage.size;
            
            [rawImage drawInRect:CGRectMake(imageview.center.x*widthRatio - size.width/2.,
                                            imageview.center.y*heightRatio - size.height/2.,
                                            size.width, size.height)];
            
        }
        [maskImage drawInRect:CGRectMake(0, 0, maskImageSize.width, maskImageSize.height)];
        
        UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
        
        UIGraphicsEndImageContext();

        UIImageWriteToSavedPhotosAlbum(newImage, self,@selector(image:didFinishSavingWithError:contextInfo:), nil);

    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    // Was there an error?
    if (error != NULL)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Image could not be saved.Please try again"  delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Close", nil];
        [alert show];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success" message:@"Image was successfully saved in photoalbum"  delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Close", nil];
        [alert show];
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    mouseSwiped = NO;
    UITouch *touch = [touches anyObject];    
    if ([touch tapCount] == 2) {
        drawImage.image = nil;
        return;
    }
    lastPoint = [touch locationInView:self.view];
    lastPoint.y -= 20;
    
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    mouseSwiped = YES;
    
    UITouch *touch = [touches anyObject];
    CGPoint currentPoint = [touch locationInView:self.view];
    currentPoint.y -= 20;
    

    float widthRatio = finalSize.width/self.view.frame.size.width;
    float heightRatio = finalSize.height/self.view.frame.size.height;

//    UIGraphicsBeginImageContext(self.view.frame.size);
    UIGraphicsBeginImageContext(finalSize);
//    [drawImage.image drawInRect:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [drawImage.image drawInRect:CGRectMake(0, 0, finalSize.width, finalSize.height)];
    
    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
    CGContextSetLineWidth(UIGraphicsGetCurrentContext(), 5.0);
    CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), 1.0, 0.0, 0.0, 1.0);
    CGContextBeginPath(UIGraphicsGetCurrentContext());
    CGContextMoveToPoint(UIGraphicsGetCurrentContext(), lastPoint.x *widthRatio, lastPoint.y *heightRatio);
    CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), currentPoint.x *widthRatio, currentPoint.y *heightRatio);
    CGContextStrokePath(UIGraphicsGetCurrentContext());
    drawImage.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    lastPoint = currentPoint;
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

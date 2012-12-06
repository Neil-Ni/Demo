
#import "PhotoViewController.h"
#import "ImageScrollView.h"

#define PrintFrame(frame) NSLog(@"%@", NSStringFromCGRect(frame));

@interface PhotoViewController () <ImageScrollViewDelegate>
{
    NSUInteger _pageIndex;
    NSMutableArray* _PathContentArray;
    ImageScrollView *scrollView;
    BOOL frontOrEnd;
}
@end

@implementation PhotoViewController
@synthesize delegate;

+ (PhotoViewController *)photoViewControllerForPageIndex:(NSUInteger)pageIndex andImageArray:(NSMutableArray *)PathContentArray
{
//    if (pageIndex == [PathContentArray count]){
//        return [[self alloc] initEndPageWithIndex: [PathContentArray count]];
//    }
    if (pageIndex < [PathContentArray count]) //&& pageIndex!=0)
    {
        return [[self alloc] initWithPageIndex:pageIndex andImageArray:PathContentArray];
    }
//    if (pageIndex == 0){
//        return [[self alloc] initFrontPage];
//    }
    return nil;
}

+ (PhotoViewController *)photoViewControllerFront
{
    return [[self alloc] initFrontPage];
}

- (id)initFrontPage{
    self = [super initWithNibName:nil bundle:nil];
    if (self)
    {
        frontOrEnd = true;
        _pageIndex = 0;
    }
    return self;

}
- (id)initEndPageWithIndex:(NSInteger) index{
    self = [super initWithNibName:nil bundle:nil];
    if (self)
    {
        frontOrEnd = true;
        _pageIndex = index;
    }
    return self;
}



- (id)initWithPageIndex:(NSInteger)pageIndex andImageArray:(NSMutableArray *)PathContentArray
{
    self = [super initWithNibName:nil bundle:nil];
    if (self)
    {
        frontOrEnd = false;
        _PathContentArray = PathContentArray;
        _pageIndex = pageIndex;
    }
    return self;
}

- (NSInteger)pageIndex
{
    return _pageIndex;
}

-(void)timerFired:(NSTimer *) theTimer
{
    [theTimer invalidate];
}
- (void) didSwipeRight:(UITapGestureRecognizer*)recognizer {
    NSLog(@"Swipe Right");
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    NSLog(@"hi");
    if (_pageIndex==0) {
        if ([(UIPanGestureRecognizer*)gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]] &&
            [(UIPanGestureRecognizer*)gestureRecognizer velocityInView:gestureRecognizer.view].x > 0.0f) {
            NSLog(@"DENIED SWIPE PREVIOUS ON FIRST PAGE");
            return NO;
        }
        if ([(UITapGestureRecognizer*)gestureRecognizer isKindOfClass:[UITapGestureRecognizer class]] &&
            [(UITapGestureRecognizer*)gestureRecognizer locationInView:gestureRecognizer.view].x < self.view.frame.size.width/2) {
            NSLog(@"DENIED TAP PREVIOUS ON FIRST PAGE");
            return NO;
        }
    }
    return YES;
}

- (void)loadView
{
    if(!frontOrEnd){
        
        scrollView = [[ImageScrollView alloc] init];
        scrollView.backgroundColor = [UIColor clearColor];
        scrollView.PathContentArray = _PathContentArray;
        scrollView.index = _pageIndex;
        scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        scrollView.tmpdelegate = self; 
        self.view = scrollView;
        [self.view setMultipleTouchEnabled:YES];

        UISwipeGestureRecognizer *swipeGestureRecognizerRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(didSwipeRight:)];
        swipeGestureRecognizerRight.direction = UISwipeGestureRecognizerDirectionRight;
        [self.view addGestureRecognizer:swipeGestureRecognizerRight];
        UITapGestureRecognizer *tapOnce = [[UITapGestureRecognizer alloc] initWithTarget:self  action:@selector(tapOnce:)];
        UITapGestureRecognizer *tapTwice = [[UITapGestureRecognizer alloc] initWithTarget:self  action:@selector(tapTwice:)];
        tapOnce.numberOfTapsRequired = 1;
        tapTwice.numberOfTapsRequired = 2;
        [tapOnce requireGestureRecognizerToFail:tapTwice];
        [self.view addGestureRecognizer:tapOnce];
        [self.view addGestureRecognizer:tapTwice];
        
    }else{
//        CGRect frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width/3., self.view.frame.size.height);
//        UIView *tmp = [[UIView alloc] initWithFrame:frame];
//        tmp.backgroundColor = [UIColor clearColor];
//        self.view = tmp;
//        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//        hud.mode = MBProgressHUDModeAnnularDeterminate;
//        hud.labelText = @"Retrieving";
//        [NSTimer scheduledTimerWithTimeInterval:2.0
//                                         target:self
//                                       selector:@selector(timerFired:)
//                                       userInfo:nil
//                                    repeats:YES];
        
    }
}

- (void)touchReceived:(ImageScrollView *)controller{
    NSLog(@"received");
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    return YES;
}

- (void)tapOnce:(UIGestureRecognizer *)gesture
{
    NSLog(@"currentindex: %d", _pageIndex);
    [self.delegate touchReceived:self];
//    [UIView animateWithDuration:0.2 animations:^(){
//        scrollView.transform = CGAffineTransformScale(scrollView.transform, 2/3., 2/3.);
//    }];
//    recognizer.scale = 1;
//    PrintFrame(frame);
//    [scrollView zoomToRect:frame animated:NO];
}
- (void)tapTwice:(UIGestureRecognizer *)gesture
{
    [self.delegate doubleTapped:self];
//    PrintFrame(self.view.frame);
//    [scrollView zoomToRect:self.view.frame animated:NO];
}

// (this can also be defined in Info.plist via UISupportedInterfaceOrientations)
- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAllButUpsideDown;
}

@end

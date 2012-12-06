
#import <Foundation/Foundation.h>

#import "ImageScrollView.h"
#import "TilingView.h"
#import "Image.h"
#import <AssetsLibrary/AssetsLibrary.h>

#define PrintFrame(frame) NSLog(@"%@", NSStringFromCGRect(frame));


#define TILE_IMAGES 0  // turn on to use tiled images, if off, we use whole images

// forward declaration of our utility functions
static NSUInteger _ImageCount(void);

#if TILE_IMAGES
static CGSize _ImageSizeAtIndex(NSUInteger index);
static UIImage *_PlaceholderImageNamed(NSString *name);
#endif

#if !TILE_IMAGES
static UIImage *_ImageAtIndex(NSUInteger index);
#endif

static NSString *_ImageNameAtIndex(NSUInteger index);

#pragma mark -

@interface ImageScrollView () <UIScrollViewDelegate>
{
    UIImageView *_zoomView;  // if tiling, this contains a very low-res placeholder image,
                             // otherwise it contains the full image.
    CGSize _imageSize;

#if TILE_IMAGES
    TilingView *_tilingView;
#endif
        
    CGPoint _pointToCenterAfterResize;
    CGFloat _scaleToRestoreAfterResize;
}

@end

@implementation ImageScrollView
@synthesize tmpdelegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.showsVerticalScrollIndicator = NO;
        self.showsHorizontalScrollIndicator = NO;
        self.bouncesZoom = YES;
        self.decelerationRate = UIScrollViewDecelerationRateFast;
        self.delegate = self;
    }
    return self;
}
- (void)setPathContentArray:(NSMutableArray *)PathContentArray{
    _PathContentArray = PathContentArray;
}

- (void)setIndex:(NSUInteger)index
{
    _index = index;
    
#if TILE_IMAGES
    [self displayTiledImageNamed:_ImageNameAtIndex(index) size:_ImageSizeAtIndex(index)];
#else
    if([[_PathContentArray objectAtIndex:_index] isKindOfClass:[Image class]]){
        Image *image = [_PathContentArray objectAtIndex:_index];
//        if(!image.imagePath) NSLog(@"no path");
//        NSLog(@"%@", image.imagePath);
        NSData *imageData = [[NSFileManager defaultManager] contentsAtPath:image.imagePath];
        [self displayImage:[UIImage imageWithData:imageData]];
    }
    if([[_PathContentArray objectAtIndex:_index] isKindOfClass:[UIImage class]]){
        [self displayImage:[_PathContentArray objectAtIndex:_index]];
    }
    if([[_PathContentArray objectAtIndex:_index] isKindOfClass:[NSDictionary class]]){
        NSDictionary *info = [_PathContentArray objectAtIndex:index];
//        NSLog(@"%@", [info objectForKey:@"UIImagePickerControllerReferenceURL"]);
        
        ALAssetsLibrary *assetLibrary=[[ALAssetsLibrary alloc] init];
        [assetLibrary assetForURL:[info objectForKey:@"UIImagePickerControllerReferenceURL"] resultBlock:^(ALAsset *asset) {
                ALAssetRepresentation *rep = [asset defaultRepresentation];
                Byte *buffer = (Byte*)malloc(rep.size);
                NSUInteger buffered = [rep getBytes:buffer fromOffset:0.0 length:rep.size error:nil];
                NSData *data = [NSData dataWithBytesNoCopy:buffer length:buffered freeWhenDone:YES];
                if(!data) NSLog(@"no data");
                [self displayImage:[UIImage imageWithData:data]];

            } failureBlock:^(NSError *err) {
                    NSLog(@"Error: %@",[err localizedDescription]);
        }];
    }
#endif
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.tmpdelegate touchReceived:self];
}

+ (NSUInteger)imageCount
{
    return _ImageCount();
}

- (void)layoutSubviews 
{
    [super layoutSubviews];
    
    // center the zoom view as it becomes smaller than the size of the screen
    CGSize boundsSize = self.bounds.size;
    CGRect frameToCenter = _zoomView.frame;
    
    // center horizontally
    if (frameToCenter.size.width < boundsSize.width)
        frameToCenter.origin.x = (boundsSize.width - frameToCenter.size.width) / 2;
    else
        frameToCenter.origin.x = 0;
    
    // center vertically
    if (frameToCenter.size.height < boundsSize.height)
        frameToCenter.origin.y = (boundsSize.height - frameToCenter.size.height) / 2;
    else
        frameToCenter.origin.y = 0;
    
    _zoomView.frame = frameToCenter;
}

- (void)setFrame:(CGRect)frame
{
    BOOL sizeChanging = !CGSizeEqualToSize(frame.size, self.frame.size);
    
    if (sizeChanging) {
        [self prepareToResize];
    }
    
    [super setFrame:frame];
    
    if (sizeChanging) {
        [self recoverFromResizing];
    }
}


#pragma mark - UIScrollViewDelegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return _zoomView;
}


#pragma mark - Configure scrollView to display new image (tiled or not)

#if TILE_IMAGES

- (void)displayTiledImageNamed:(NSString *)imageName size:(CGSize)imageSize
{
    // clear views for the previous image
    [_zoomView removeFromSuperview];
    _zoomView = nil;
    _tilingView = nil;
        
    // reset our zoomScale to 1.0 before doing any further calculations
    self.zoomScale = 1.0;
    
    
    // make views to display the new image
    _zoomView = [[UIImageView alloc] initWithFrame:(CGRect){ CGPointZero, imageSize }];
    [_zoomView setImage:_PlaceholderImageNamed(imageName)];
    [self addSubview:_zoomView];
    
    _tilingView = [[TilingView alloc] initWithImageName:imageName size:imageSize];
    _tilingView.frame = _zoomView.bounds;
    [_zoomView addSubview:_tilingView];
    
    
    [self configureForImageSize:imageSize];
}

#else

- (void)displayImage:(UIImage *)image
{
    // clear the previous image
    [_zoomView removeFromSuperview];
    _zoomView = nil;
    
    // reset our zoomScale to 1.0 before doing any further calculations
//    self.zoomScale = 5.0;
    self.zoomScale = 1.0;
    
    // make a new UIImageView for the new image
    _zoomView = [[UIImageView alloc] initWithImage:image];
    [self addSubview:_zoomView];
    
    [self configureForImageSize:image.size];
}

#endif // TILE_IMAGES

- (void)configureForImageSize:(CGSize)imageSize
{
    _imageSize = imageSize;
    self.contentSize = imageSize;
    [self setMaxMinZoomScalesForCurrentBounds];
    self.zoomScale = self.minimumZoomScale;
}

- (void)setMaxMinZoomScalesForCurrentBounds
{
    CGSize boundsSize = self.bounds.size;
    
    // calculate min/max zoomscale
    CGFloat xScale = boundsSize.width  / _imageSize.width;    // the scale needed to perfectly fit the image width-wise
    CGFloat yScale = boundsSize.height / _imageSize.height;   // the scale needed to perfectly fit the image height-wise
    
    // fill width if the image and phone are both portrait or both landscape; otherwise take smaller scale
    BOOL imagePortrait = _imageSize.height > _imageSize.width;
    BOOL phonePortrait = boundsSize.height > boundsSize.width;
    CGFloat minScale = imagePortrait == phonePortrait ? xScale : MIN(xScale, yScale);
    
    // on high resolution screens we have double the pixel density, so we will be seeing every pixel if we limit the
    // maximum zoom scale to 0.5.
    CGFloat maxScale = 1.0 / [[UIScreen mainScreen] scale];

    // don't let minScale exceed maxScale. (If the image is smaller than the screen, we don't want to force it to be zoomed.) 
    if (minScale > maxScale) {
        minScale = maxScale;
    }
        
    self.maximumZoomScale = maxScale;
    self.minimumZoomScale = minScale;
}

#pragma mark -
#pragma mark Methods called during rotation to preserve the zoomScale and the visible portion of the image

#pragma mark - Rotation support

- (void)prepareToResize
{
    CGPoint boundsCenter = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    _pointToCenterAfterResize = [self convertPoint:boundsCenter toView:_zoomView];

    _scaleToRestoreAfterResize = self.zoomScale;
    
    // If we're at the minimum zoom scale, preserve that by returning 0, which will be converted to the minimum
    // allowable scale when the scale is restored.
    if (_scaleToRestoreAfterResize <= self.minimumZoomScale + FLT_EPSILON)
        _scaleToRestoreAfterResize = 0;
}

- (void)recoverFromResizing
{
    [self setMaxMinZoomScalesForCurrentBounds];
    
    // Step 1: restore zoom scale, first making sure it is within the allowable range.
    CGFloat maxZoomScale = MAX(self.minimumZoomScale, _scaleToRestoreAfterResize);
    self.zoomScale = MIN(self.maximumZoomScale, maxZoomScale);
    
    // Step 2: restore center point, first making sure it is within the allowable range.
    
    // 2a: convert our desired center point back to our own coordinate space
    CGPoint boundsCenter = [self convertPoint:_pointToCenterAfterResize fromView:_zoomView];

    // 2b: calculate the content offset that would yield that center point
    CGPoint offset = CGPointMake(boundsCenter.x - self.bounds.size.width / 2.0,
                                 boundsCenter.y - self.bounds.size.height / 2.0);

    // 2c: restore offset, adjusted to be within the allowable range
    CGPoint maxOffset = [self maximumContentOffset];
    CGPoint minOffset = [self minimumContentOffset];
    
    CGFloat realMaxOffset = MIN(maxOffset.x, offset.x);
    offset.x = MAX(minOffset.x, realMaxOffset);
    
    realMaxOffset = MIN(maxOffset.y, offset.y);
    offset.y = MAX(minOffset.y, realMaxOffset);
    
    self.contentOffset = offset;
}

- (CGPoint)maximumContentOffset
{
    CGSize contentSize = self.contentSize;
    CGSize boundsSize = self.bounds.size;
    return CGPointMake(contentSize.width - boundsSize.width, contentSize.height - boundsSize.height);
}

- (CGPoint)minimumContentOffset
{
    return CGPointZero;
}

@end

static NSArray *_ImageData(void)
{
    static NSArray *data = nil;

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString *path = [[NSBundle mainBundle] pathForResource:@"ImageData" ofType:@"plist"];
        NSData *plistData = [NSData dataWithContentsOfFile:path];
        NSString *error; NSPropertyListFormat format;
        data = [NSPropertyListSerialization propertyListFromData:plistData
                                                mutabilityOption:NSPropertyListImmutable
                                                          format:&format
                                                errorDescription:&error];
        if (!data) {
            NSLog(@"Unable to read image data: %@", error);
        }
    });
    
    return data;
}

static NSUInteger _ImageCount(void)
{
    static NSUInteger count = 0;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        count = [_ImageData() count];
    });
    return count;
}

static NSString *_ImageNameAtIndex(NSUInteger index)
{
    NSDictionary *info = [_ImageData() objectAtIndex:index];
    return [info valueForKey:@"name"];
}

#if !TILE_IMAGES
// we use "imageWithContentsOfFile:" instead of "imageNamed:" here to avoid caching
static UIImage *_ImageAtIndex(NSUInteger index)
{
    NSString *imageName = _ImageNameAtIndex(index);
    NSString *path = [[NSBundle mainBundle] pathForResource:imageName ofType:@"jpg"];
    NSLog(@"%@", path);
    return [UIImage imageWithContentsOfFile:path];
}
#endif

#if TILE_IMAGES
static CGSize _ImageSizeAtIndex(NSUInteger index)
{
    NSDictionary *info = [_ImageData() objectAtIndex:index];
    return CGSizeMake([[info valueForKey:@"width"] floatValue],
                      [[info valueForKey:@"height"] floatValue]);
}

static UIImage *_PlaceholderImageNamed(NSString *name)
{
    return [UIImage imageNamed:[NSString stringWithFormat:@"%@_Placeholder", name]];
}
#endif

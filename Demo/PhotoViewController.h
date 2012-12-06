
#import <UIKit/UIKit.h>

@class PhotoViewController;

@protocol PhotoViewControllerDelegate <NSObject>
- (void)touchReceived:(PhotoViewController *)controller;
- (void)doubleTapped:(PhotoViewController *)controller;
@end

@interface PhotoViewController : UIViewController 
@property (nonatomic, weak) id <PhotoViewControllerDelegate> delegate;

+ (PhotoViewController *)photoViewControllerForPageIndex:(NSUInteger)pageIndex andImageArray:(NSMutableArray *)PathContentArray;
+ (PhotoViewController *)photoViewControllerFront;
- (NSInteger)pageIndex;

@end

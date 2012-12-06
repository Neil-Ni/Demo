
#import <UIKit/UIKit.h>


@class ImageScrollView;

@protocol ImageScrollViewDelegate <NSObject>
- (void)touchReceived:(ImageScrollView *)controller;
@end

@interface ImageScrollView : UIScrollView
@property (nonatomic, weak) id <ImageScrollViewDelegate> tmpdelegate;
@property (nonatomic) NSUInteger index;
@property (nonatomic) NSMutableArray *PathContentArray;
+ (NSUInteger)imageCount;

@end

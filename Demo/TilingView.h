

#import <UIKit/UIKit.h>


@interface TilingView : UIView 

- (id)initWithImageName:(NSString *)name size:(CGSize)size;
- (UIImage *)tileForScale:(CGFloat)scale row:(int)row col:(int)col;

@end

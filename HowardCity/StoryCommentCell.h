#import <UIKit/UIKit.h>

static NSString *kCommentsKey   = @"Comments";
static NSString *kCommentKey    = @"Comment";
static NSString *kTimeKey       = @"Time";
static NSString *kLikesCountKey = @"LikesCount";

static NSString *kCellIdentifier = @"storyCellId";

@interface StoryCommentCell : UITableViewCell
+ (void)setTableViewWidth:(CGFloat)tableWidth;
+ (id)storyCommentCellForTableWidth:(CGFloat)width;
+ (CGFloat)cellHeightForComment:(NSString *)comment;
- (void)configureCommentCellForComment:(NSDictionary *)comment;
@end

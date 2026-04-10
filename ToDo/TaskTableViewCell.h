#import <UIKit/UIKit.h>

@interface TaskTableViewCell : UITableViewCell

- (void)configureWithName:(NSString *)name
              description:(NSString *)desc
                    image:(UIImage *)image
                 priority:(NSString *)priority
                   status:(NSString *)status
                     date:(NSString *)date;
@end

#import <UIKit/UIKit.h>
#import "Task.h"

NS_ASSUME_NONNULL_BEGIN

@interface DetailsViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel     *taskName;
@property (weak, nonatomic) IBOutlet UIImageView *taskImage;
@property (strong, nonatomic) IBOutlet UILabel    *taskStatus;
@property (weak, nonatomic) IBOutlet UILabel     *taskPriority;
@property (weak, nonatomic) IBOutlet UILabel     *taskDate;
@property (weak, nonatomic) IBOutlet UITextView *taskDescView;
@property (strong, nonatomic) Task *task;
- (IBAction)deleteButton:(id)sender;
- (IBAction)editButton:(id)sender;

@end

NS_ASSUME_NONNULL_END

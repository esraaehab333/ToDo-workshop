#import <UIKit/UIKit.h>
#import "Task.h"

NS_ASSUME_NONNULL_BEGIN

@interface AddTaskViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *nameLabel;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentControll;
@property (weak, nonatomic) IBOutlet UISegmentedControl *statusSegmentController;
@property (weak, nonatomic) IBOutlet UIButton *addButton;
@property (weak, nonatomic) IBOutlet UITextView *descriptionLabelView;

@property (strong, nonatomic, nullable) Task *taskToEdit;

- (IBAction)addButton:(id)sender;

@end

NS_ASSUME_NONNULL_END

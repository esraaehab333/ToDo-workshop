#import "DetailsViewController.h"
#import "AddTaskViewController.h"
#import "Task.h"

static NSString *const kTasksKey = @"tasks";

@interface DetailsViewController ()
@property (weak, nonatomic) IBOutlet UIButton *editButton;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@end

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dateFormatter = [[NSDateFormatter alloc] init];
    self.dateFormatter.dateFormat = @"MMM d, yyyy";
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self refreshTaskFromDefaults];
    [self populateUI];
}

- (void)refreshTaskFromDefaults {
    NSData *savedData = [[NSUserDefaults standardUserDefaults] objectForKey:kTasksKey];
    if (!savedData || !self.task) return;
    
    NSSet *allowedClasses = [NSSet setWithObjects:[NSArray class], [Task class],
                             [NSString class], [NSDate class], nil];
    NSArray *allTasks = [NSKeyedUnarchiver unarchivedObjectOfClasses:allowedClasses
                                                            fromData:savedData
                                                               error:nil];
    for (Task *t in allTasks) {
        if ([t.createdAt isEqual:self.task.createdAt]) {
            self.task = t;
            break;
        }
    }
}

- (void)populateUI {
    if (!self.task) return;
    self.taskName.text     = self.task.name;
    self.taskStatus.text   = self.task.status;
    self.taskDescView.text     = self.task.taskDescription;
    self.taskPriority.text = self.task.priority;
    self.taskDate.text     = self.task.createdAt
    ? [self.dateFormatter stringFromDate:self.task.createdAt]
    : @"";
    UIImage *img = [UIImage imageNamed:
                    [self.task.priority isEqualToString:@"High"] ? @"high.png" : [self.task.priority isEqualToString:@"Low"] ? @"low.png":@"medium.png"];
    self.taskImage.image = img;
    self.taskPriority.layer.cornerRadius = 8;
    self.taskPriority.layer.masksToBounds = YES;
    self.taskStatus.layer.cornerRadius = 8;
    self.taskStatus.layer.masksToBounds = YES;
    self.taskPriority.text = [NSString stringWithFormat:@"  %@  ", self.task.priority];
    if ([self.task.priority isEqualToString:@"High"]) {
        self.taskPriority.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:0.15];
        self.taskPriority.textColor = [UIColor redColor];
    } else if ([self.task.priority isEqualToString:@"Medium"]) {
        self.taskPriority.backgroundColor = [[UIColor greenColor] colorWithAlphaComponent:0.15];
        self.taskPriority.textColor = [UIColor greenColor];
    } else {
        self.taskPriority.backgroundColor = [[UIColor blueColor] colorWithAlphaComponent:0.15];
        self.taskPriority.textColor = [UIColor blueColor];
    }
    self.taskStatus.text = [NSString stringWithFormat:@"  %@  ", self.task.status];
    
    if ([self.task.status isEqualToString:@"ToDo"]) {
        self.taskStatus.backgroundColor = [[UIColor greenColor] colorWithAlphaComponent:0.15];
        self.taskStatus.textColor = [UIColor greenColor];
    } else if ([self.task.status isEqualToString:@"Done"]) {
        self.taskStatus.backgroundColor = [[UIColor purpleColor] colorWithAlphaComponent:0.15];
        self.taskStatus.textColor = [UIColor purpleColor];
    } else {
        self.taskStatus.backgroundColor = [[UIColor orangeColor] colorWithAlphaComponent:0.15];
        self.taskStatus.textColor = [UIColor orangeColor];
    }
    self.editButton.enabled = ![self.task.status isEqualToString:@"Done"];
    
}

- (IBAction)deleteButton:(id)sender {
    UIAlertController *alert =
    [UIAlertController alertControllerWithTitle:@"Delete Task"
                                        message:@"Are you sure?"
                                 preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"Cancel"
                                              style:UIAlertActionStyleCancel
                                            handler:nil]];
    [alert addAction:[UIAlertAction actionWithTitle:@"Delete"
                                              style:UIAlertActionStyleDestructive
                                            handler:^(UIAlertAction *action) {
                                                [self deleteTaskAndPop];
                                            }]];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)deleteTaskAndPop {
    NSData *savedData = [[NSUserDefaults standardUserDefaults] objectForKey:kTasksKey];
    if (!savedData) {
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    
    NSSet *allowedClasses = [NSSet setWithObjects:[NSArray class], [Task class],
                             [NSString class], [NSDate class], nil];
    NSArray *loaded = [NSKeyedUnarchiver unarchivedObjectOfClasses:allowedClasses
                                                          fromData:savedData
                                                             error:nil];
    NSMutableArray *allTasks = [loaded mutableCopy];
    
    Task *toRemove = nil;
    for (Task *t in allTasks) {
        if ([t.createdAt isEqual:self.task.createdAt]) {
            toRemove = t;
            break;
        }
    }
    
    if (toRemove) {
        [allTasks removeObject:toRemove];
        NSData *newData = [NSKeyedArchiver archivedDataWithRootObject:allTasks
                                                requiringSecureCoding:YES
                                                                error:nil];
        [[NSUserDefaults standardUserDefaults] setObject:newData forKey:kTasksKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)editButton:(id)sender {
    AddTaskViewController *avc =
    [self.storyboard instantiateViewControllerWithIdentifier:@"AddTaskVC"];
    avc.taskToEdit = self.task;
    [self.navigationController pushViewController:avc animated:YES];
}

@end

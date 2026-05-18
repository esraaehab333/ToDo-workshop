//
//  AddTaskViewController.m
//  ToDo
//

#import "AddTaskViewController.h"
#import "Task.h"
#import <UserNotifications/UserNotifications.h>

static NSString *const kTasksKey = @"tasks";

@interface AddTaskViewController ()

@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (strong, nonatomic) NSDate *selectedDate;

@end

@implementation AddTaskViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    if (self.taskToEdit) {
        [self prefillForEditing];
    } else {
        self.navigationItem.title = @"Add Task";
    }

    self.navigationItem.hidesBackButton = YES;

    UIBarButtonItem *backBtn =
    [[UIBarButtonItem alloc]
     initWithTitle:@"Back"
     style:UIBarButtonItemStylePlain
     target:self
     action:@selector(backPressed)];

    self.navigationItem.leftBarButtonItem = backBtn;

    self.descriptionLabelView.layer.cornerRadius = 10;
    self.descriptionLabelView.layer.borderWidth = 0.5;
    self.descriptionLabelView.layer.borderColor =
    [UIColor lightGrayColor].CGColor;

    self.descriptionLabelView.backgroundColor =
    [UIColor whiteColor];

    self.descriptionLabelView.font =
    [UIFont systemFontOfSize:16];

    self.descriptionLabelView.textContainerInset =
    UIEdgeInsetsMake(8, 8, 8, 8);

    self.addButton.layer.cornerRadius = 15.0;

    self.datePicker.minimumDate = [NSDate date];
}


- (IBAction)datePicker:(id)sender {

    UIDatePicker *picker = (UIDatePicker *)sender;

    self.selectedDate = picker.date;

    if ([self.selectedDate timeIntervalSinceNow] <= 0) {

        UIAlertController *alert =
        [UIAlertController alertControllerWithTitle:@"Invalid Date"
                                            message:@"Please select a future date."
                                     preferredStyle:UIAlertControllerStyleAlert];

        [alert addAction:
         [UIAlertAction actionWithTitle:@"OK"
                                  style:UIAlertActionStyleDefault
                                handler:nil]];

        [self presentViewController:alert
                           animated:YES
                         completion:nil];

        self.selectedDate = nil;

        return;
    }

    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];

    formatter.dateStyle = NSDateFormatterMediumStyle;
    formatter.timeStyle = NSDateFormatterShortStyle;

    NSString *dateString =
    [formatter stringFromDate:self.selectedDate];

    UIAlertController *alert =
    [UIAlertController alertControllerWithTitle:@"Reminder Selected"
                                        message:dateString
                                 preferredStyle:UIAlertControllerStyleAlert];

    [alert addAction:
     [UIAlertAction actionWithTitle:@"OK"
                              style:UIAlertActionStyleDefault
                            handler:nil]];

    [self presentViewController:alert
                       animated:YES
                     completion:nil];
}

- (IBAction)addButton:(id)sender {

    if (![self isValidInput]) {
        return;
    }

    NSString *name = self.nameLabel.text;
    NSString *desc = self.descriptionLabelView.text;

    NSArray *priorities = @[@"High", @"Medium", @"Low"];
    NSArray *statuses = @[@"Todo", @"Inprocess", @"Done"];

    NSString *priority =
    priorities[self.segmentControll.selectedSegmentIndex];

    NSString *status =
    statuses[self.statusSegmentController.selectedSegmentIndex];

    NSData *savedData =
    [[NSUserDefaults standardUserDefaults]
     objectForKey:kTasksKey];

    NSMutableArray *allTasks = [NSMutableArray array];

    if (savedData) {

        NSSet *allowedClasses =
        [NSSet setWithObjects:
         [NSArray class],
         [Task class],
         [NSString class],
         [NSDate class],
         nil];

        NSArray *loaded =
        [NSKeyedUnarchiver
         unarchivedObjectOfClasses:allowedClasses
         fromData:savedData
         error:nil];

        allTasks = [loaded mutableCopy];
    }

    if (self.taskToEdit) {

        for (Task *t in allTasks) {

            if ([t.createdAt isEqual:self.taskToEdit.createdAt]) {

                t.name = name;
                t.taskDescription = desc;
                t.priority = priority;
                t.status = status;

                break;
            }
        }

    } else {

        Task *newTask =
        [[Task alloc]
         initWithName:name
         taskDescription:desc
         status:status
         priority:priority];

        [allTasks addObject:newTask];
    }

    NSData *newData =
    [NSKeyedArchiver archivedDataWithRootObject:allTasks
                          requiringSecureCoding:YES
                                          error:nil];

    [[NSUserDefaults standardUserDefaults]
     setObject:newData
     forKey:kTasksKey];

    [[NSUserDefaults standardUserDefaults] synchronize];

    // Schedule Notification After Saving Task

    if (self.selectedDate) {
        [self scheduleNotificationForDate:self.selectedDate];
    }

    UIAlertController *success =
    [UIAlertController alertControllerWithTitle:@"Success"
                                        message:@"Task saved successfully."
                                 preferredStyle:UIAlertControllerStyleAlert];

    [success addAction:
     [UIAlertAction actionWithTitle:@"OK"
                              style:UIAlertActionStyleDefault
                            handler:^(UIAlertAction * _Nonnull action) {

        [self.navigationController popViewControllerAnimated:YES];
    }]];

    [self presentViewController:success
                       animated:YES
                     completion:nil];
}

- (void)scheduleNotificationForDate:(NSDate *)date {

    if (!date || [date timeIntervalSinceNow] <= 0) {
        return;
    }

    NSString *taskName =
    self.nameLabel.text.length > 0 ?
    self.nameLabel.text :
    @"Task Reminder";

    UNMutableNotificationContent *content =
    [[UNMutableNotificationContent alloc] init];

    content.title = @"Task Reminder";

    content.body =
    [NSString stringWithFormat:
     @"Don't forget to complete: %@",
     taskName];

    content.sound = [UNNotificationSound defaultSound];

    content.badge = @1;

    NSDateComponents *components =
    [[NSCalendar currentCalendar]
     components:
     (NSCalendarUnitYear   |
      NSCalendarUnitMonth  |
      NSCalendarUnitDay    |
      NSCalendarUnitHour   |
      NSCalendarUnitMinute |
      NSCalendarUnitSecond)

     fromDate:date];

    UNCalendarNotificationTrigger *trigger =
    [UNCalendarNotificationTrigger
     triggerWithDateMatchingComponents:components
     repeats:NO];

    NSString *identifier =
    [NSString stringWithFormat:@"task_%@",
     [[NSUUID UUID] UUIDString]];

    UNNotificationRequest *request =
    [UNNotificationRequest
     requestWithIdentifier:identifier
     content:content
     trigger:trigger];

    [[UNUserNotificationCenter currentNotificationCenter]
     addNotificationRequest:request
     withCompletionHandler:
     ^(NSError * _Nullable error) {

        if (error) {

            NSLog(@"Notification Error: %@",
                  error.localizedDescription);

        } else {

            NSLog(@"Notification Scheduled Successfully");

            [[UNUserNotificationCenter currentNotificationCenter]
             getPendingNotificationRequestsWithCompletionHandler:
             ^(NSArray<UNNotificationRequest *> * _Nonnull requests) {

                NSLog(@"Pending Notifications Count: %lu",
                      (unsigned long)requests.count);
            }];
        }
    }];
}

- (void)backPressed {

    NSString *name =
    [self.nameLabel.text
     stringByTrimmingCharactersInSet:
     [NSCharacterSet whitespaceCharacterSet]];

    BOOL hasContent =
    name.length > 0 ||
    self.descriptionLabelView.text.length > 0;

    if (hasContent) {

        UIAlertController *alert =
        [UIAlertController alertControllerWithTitle:@"Discard Changes?"
                                            message:@"You have unsaved changes."
                                     preferredStyle:UIAlertControllerStyleAlert];

        [alert addAction:
         [UIAlertAction actionWithTitle:@"Stay"
                                  style:UIAlertActionStyleCancel
                                handler:nil]];

        [alert addAction:
         [UIAlertAction actionWithTitle:@"Discard"
                                  style:UIAlertActionStyleDestructive
                                handler:^(UIAlertAction * _Nonnull action) {

            [self.navigationController popViewControllerAnimated:YES];
        }]];

        [self presentViewController:alert
                           animated:YES
                         completion:nil];

    } else {

        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)prefillForEditing {

    self.nameLabel.text = self.taskToEdit.name;

    self.descriptionLabelView.text =
    self.taskToEdit.taskDescription;

    NSArray *priorities =
    @[@"High", @"Medium", @"Low"];

    NSArray *statuses =
    @[@"Todo", @"Inprocess", @"Done"];

    self.segmentControll.selectedSegmentIndex =
    [priorities indexOfObject:self.taskToEdit.priority];

    self.statusSegmentController.selectedSegmentIndex =
    [statuses indexOfObject:self.taskToEdit.status];

    self.navigationItem.title = @"Edit Task";

    if ([self.taskToEdit.status isEqualToString:@"Inprocess"]) {

        [self.statusSegmentController
         setEnabled:NO
         forSegmentAtIndex:0];

    } else if ([self.taskToEdit.status isEqualToString:@"Done"]) {

        [self.statusSegmentController
         setEnabled:NO
         forSegmentAtIndex:0];

        [self.statusSegmentController
         setEnabled:NO
         forSegmentAtIndex:1];
    }
}

- (BOOL)isValidInput {

    NSString *name =
    [self.nameLabel.text
     stringByTrimmingCharactersInSet:
     [NSCharacterSet whitespaceCharacterSet]];

    if (name.length == 0) {

        UIAlertController *alert =
        [UIAlertController alertControllerWithTitle:@"Error"
                                            message:@"Task name is required."
                                     preferredStyle:UIAlertControllerStyleAlert];

        [alert addAction:
         [UIAlertAction actionWithTitle:@"OK"
                                  style:UIAlertActionStyleDefault
                                handler:nil]];

        [self presentViewController:alert
                           animated:YES
                         completion:nil];

        return NO;
    }

    return YES;
}

@end

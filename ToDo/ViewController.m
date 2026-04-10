#import "ViewController.h"
#import "TaskTableViewCell.h"
#import "AddTaskViewController.h"
#import "Task.h"
#import "DetailsViewController.h"

static NSString *const kTasksKey = @"tasks";

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dateFormatter = [[NSDateFormatter alloc] init];
    self.dateFormatter.dateFormat = @"MMM d, yyyy";
    
    [self.tableView registerClass:[TaskTableViewCell class] forCellReuseIdentifier:@"TaskCell"];
    self.tableView.rowHeight          = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 100;
    self.tableView.separatorStyle     = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate           = self;
    self.tableView.dataSource         = self;
    self.searchBar.delegate           = self;
    
    [self initializeData];
    [self updateDisplayData];
    [self setSegmentUI];
    [self setUpFloatingActionButton];
    
    UIColor *navColor = [UIColor colorWithRed:253/255.0
                                        green:106/255.0
                                         blue:129/255.0
                                        alpha:1.0];
    
    self.navigationController.navigationBar.barTintColor = navColor;
    self.navigationController.navigationBar.titleTextAttributes = @{
                                                                    NSForegroundColorAttributeName: [UIColor whiteColor]
                                                                    };
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self loadTasksFromDefaults];
    [self updateDisplayData];
    
}

- (void)initializeData {
    self.allTasks     = [[NSMutableArray alloc] init];
    self.filteredData = [[NSMutableArray alloc] init];
    [self loadTasksFromDefaults];
}

- (void)loadTasksFromDefaults {
    NSData *savedData = [[NSUserDefaults standardUserDefaults] objectForKey:kTasksKey];
    if (savedData) {
        NSError *error = nil;
        NSSet *allowedClasses = [NSSet setWithObjects:[NSArray class], [Task class],
                                 [NSString class], [NSDate class], [NSData class], nil];
        NSArray *loaded = [NSKeyedUnarchiver unarchivedObjectOfClasses:allowedClasses
                                                              fromData:savedData
                                                                 error:&error];
        if (loaded && !error) {
            self.allTasks = [loaded mutableCopy];
        }
    }
}

- (void)saveTasksToDefaults {
    NSError *error = nil;
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self.allTasks
                                         requiringSecureCoding:YES
                                                         error:&error];
    if (!error) {
        [[NSUserDefaults standardUserDefaults] setObject:data forKey:kTasksKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (void)updateDisplayData {
    NSArray *tempFiltered;
    
    switch (self.segmentController.selectedSegmentIndex) {
        case 0:
            tempFiltered = self.allTasks;
            break;
        case 1:
            tempFiltered = [self.allTasks filteredArrayUsingPredicate:
                            [NSPredicate predicateWithFormat:@"status == %@", @"Inprocess"]];
            break;
        case 2:
            tempFiltered = [self.allTasks filteredArrayUsingPredicate:
                            [NSPredicate predicateWithFormat:@"status == %@", @"Todo"]];
            break;
        case 3:
            tempFiltered = [self.allTasks filteredArrayUsingPredicate:
                            [NSPredicate predicateWithFormat:@"status == %@", @"Done"]];
            break;
        case 4: {
            NSDictionary *priorityOrder = @{
                                            @"High":   @3,
                                            @"Medium": @2,
                                            @"Low":    @1
                                            };
            tempFiltered = [self.allTasks sortedArrayUsingComparator:
                            ^NSComparisonResult(Task *t1, Task *t2) {
                                NSNumber *p1 = priorityOrder[t1.priority] ?: @0;
                                NSNumber *p2 = priorityOrder[t2.priority] ?: @0;
                                return [p2 compare:p1];
                            }];
            break;
        }
        default:
            tempFiltered = self.allTasks;
            break;
    }
    
    NSString *searchText = [self.searchBar.text stringByTrimmingCharactersInSet:
                            [NSCharacterSet whitespaceCharacterSet]];
    if (searchText.length > 0) {
        NSPredicate *sp = [NSPredicate predicateWithFormat:@"name CONTAINS[cd] %@", searchText];
        self.filteredData = [[tempFiltered filteredArrayUsingPredicate:sp] mutableCopy];
    } else {
        self.filteredData = [tempFiltered mutableCopy];
    }
    
    [self.tableView reloadData];
    BOOL isEmpty = self.filteredData.count == 0;
    self.emptyListLabel.hidden = !isEmpty;
    self.subTitleEmptyList.hidden = !isEmpty;
    self.tableView.hidden = isEmpty;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.filteredData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TaskTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TaskCell"
                                                              forIndexPath:indexPath];
    Task *task = self.filteredData[indexPath.row];
    
    UIImage *img;
    if ([task.priority isEqualToString:@"High"]) {
        img = [UIImage imageNamed:@"high.png"];
    } else if ([task.priority isEqualToString:@"Low"]){
        img = [UIImage imageNamed:@"low.png"];
    }
    else{
        img = [UIImage imageNamed:@"medium.png"];
    }
    if (!img) { img = [UIImage imageNamed:@"high.png"]; }
    
    NSString *dateString = task.createdAt
    ? [self.dateFormatter stringFromDate:task.createdAt]
    : @"";
    
    [cell configureWithName:task.name
                description:task.taskDescription
                      image:img
                   priority:task.priority
                     status:task.status
                       date:dateString];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    DetailsViewController *dvc =
    [self.storyboard instantiateViewControllerWithIdentifier:@"DetailsVC"];
    dvc.task = self.filteredData[indexPath.row];
    [self.navigationController pushViewController:dvc animated:YES];
}

- (void)tableView:(UITableView *)tableView
commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        UIAlertController *alert =
        [UIAlertController alertControllerWithTitle:@"Delete Task"
                                            message:@"Are you sure you want to remove this task?"
                                     preferredStyle:UIAlertControllerStyleAlert];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"Cancel"
                                                  style:UIAlertActionStyleCancel
                                                handler:nil]];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"Delete"
                                                  style:UIAlertActionStyleDestructive
                                                handler:^(UIAlertAction *action) {
                                                    Task *taskToDelete = self.filteredData[indexPath.row];
                                                    [self.allTasks removeObject:taskToDelete];
                                                    [self.filteredData removeObjectAtIndex:indexPath.row];
                                                    [self saveTasksToDefaults];
                                                    [tableView deleteRowsAtIndexPaths:@[indexPath]
                                                                     withRowAnimation:UITableViewRowAnimationFade];
                                                }]];
        
        [self presentViewController:alert animated:YES completion:nil];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 110.0;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    [self updateDisplayData];
}

- (void)setSegmentUI {
    self.segmentController.layer.cornerRadius  = self.segmentController.frame.size.height / 2;
    self.segmentController.layer.masksToBounds = YES;
}

- (void)setUpFloatingActionButton {
    self.addButton.layer.cornerRadius  = self.addButton.frame.size.height / 2;
    self.addButton.layer.masksToBounds = YES;
}

- (IBAction)segmentChanged:(UISegmentedControl *)sender {
    [self updateDisplayData];
}

- (IBAction)addButton:(id)sender {
    if ([self.navigationController.topViewController isKindOfClass:[AddTaskViewController class]]) {
        return;
    }
    AddTaskViewController *avc =
    [self.storyboard instantiateViewControllerWithIdentifier:@"AddTaskVC"];
    [self.navigationController pushViewController:avc animated:YES];
}

@end

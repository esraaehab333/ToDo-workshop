//
//  ViewController.h
//  ToDo
//
//  Created by ZATER on 4/7/26.
//  Copyright © 2026 ZATER. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentController;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong , nonatomic) NSMutableArray *allTasks;
@property (nonatomic, assign) BOOL isPriorityMode;
- (IBAction)segmentChanged:(id)sender;
@property (strong , nonatomic)NSMutableArray *filteredData;
- (IBAction)addButton:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *addButton;
@property (weak, nonatomic) IBOutlet UILabel *emptyListLabel;
@property (weak, nonatomic) IBOutlet UILabel *subTitleEmptyList;

@end



#import "TaskTableViewCell.h"

@interface TaskTableViewCell ()
@property (nonatomic, strong) UIImageView *taskImageView;
@property (nonatomic, strong) UILabel     *nameLabel;
@property (nonatomic, strong) UILabel     *descLabel;
@property (nonatomic, strong) UILabel     *priorityLabel;
@property (nonatomic, strong) UILabel     *statusLabel;
@property (nonatomic, strong) UILabel     *dateLabel;
@property (nonatomic, strong) UIView      *cardView;
@end

@implementation TaskTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupViews];
        [self setupConstraints];
    }
    return self;
}

- (void)setupViews {
    self.backgroundColor = [UIColor clearColor];
    self.selectionStyle  = UITableViewCellSelectionStyleNone;
    
    self.cardView = [[UIView alloc] init];
    self.cardView.translatesAutoresizingMaskIntoConstraints = NO;
    self.cardView.backgroundColor    = [UIColor whiteColor];
    self.cardView.layer.cornerRadius = 16;
    self.cardView.layer.shadowColor  = [UIColor blackColor].CGColor;
    self.cardView.layer.shadowOpacity = 0.08;
    self.cardView.layer.shadowOffset  = CGSizeMake(0, 4);
    self.cardView.layer.shadowRadius  = 8;
    [self.contentView addSubview:self.cardView];
    
    self.taskImageView = [[UIImageView alloc] init];
    self.taskImageView.translatesAutoresizingMaskIntoConstraints = NO;
    self.taskImageView.layer.cornerRadius = 15;
    self.taskImageView.clipsToBounds = YES;
    self.taskImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.cardView addSubview:self.taskImageView];
    
    self.nameLabel = [[UILabel alloc] init];
    self.nameLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.nameLabel.font = [UIFont boldSystemFontOfSize:15];
    [self.cardView addSubview:self.nameLabel];
    
    self.descLabel = [[UILabel alloc] init];
    self.descLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.descLabel.font = [UIFont systemFontOfSize:13];
    self.descLabel.numberOfLines = 80;
    [self.cardView addSubview:self.descLabel];
    
    self.priorityLabel = [[UILabel alloc] init];
    self.priorityLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.priorityLabel.font = [UIFont boldSystemFontOfSize:11];
    self.priorityLabel.textAlignment = NSTextAlignmentCenter;
    self.priorityLabel.layer.cornerRadius = 8;
    self.priorityLabel.layer.masksToBounds = YES;
    [self.cardView addSubview:self.priorityLabel];
    
    self.statusLabel = [[UILabel alloc] init];
    self.statusLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.statusLabel.font = [UIFont boldSystemFontOfSize:11];
    self.statusLabel.textAlignment = NSTextAlignmentCenter;
    self.statusLabel.layer.cornerRadius = 8;
    self.statusLabel.layer.masksToBounds = YES;
    [self.cardView addSubview:self.statusLabel];
    
    self.dateLabel = [[UILabel alloc] init];
    self.dateLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.dateLabel.font = [UIFont systemFontOfSize:11];
    [self.cardView addSubview:self.dateLabel];
}

- (void)setupConstraints {
    [NSLayoutConstraint activateConstraints:@[
                                              [self.cardView.topAnchor constraintEqualToAnchor:self.contentView.topAnchor constant:8],
                                              [self.cardView.bottomAnchor constraintEqualToAnchor:self.contentView.bottomAnchor constant:-8],
                                              [self.cardView.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor constant:16],
                                              [self.cardView.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor constant:-16],
                                              [self.taskImageView.leadingAnchor constraintEqualToAnchor:self.cardView.leadingAnchor constant:12],
                                              [self.taskImageView.centerYAnchor constraintEqualToAnchor:self.cardView.centerYAnchor],
                                              [self.taskImageView.widthAnchor constraintEqualToConstant:60],
                                              [self.taskImageView.heightAnchor constraintEqualToConstant:60],
                                              [self.nameLabel.topAnchor constraintEqualToAnchor:self.cardView.topAnchor constant:14],
                                              [self.nameLabel.leadingAnchor constraintEqualToAnchor:self.taskImageView.trailingAnchor constant:12],
                                              [self.nameLabel.trailingAnchor constraintEqualToAnchor:self.cardView.trailingAnchor constant:-12],
                                              [self.descLabel.topAnchor constraintEqualToAnchor:self.nameLabel.bottomAnchor constant:4],
                                              [self.descLabel.leadingAnchor constraintEqualToAnchor:self.taskImageView.trailingAnchor constant:12],
                                              [self.descLabel.trailingAnchor constraintEqualToAnchor:self.cardView.trailingAnchor constant:-12],
                                              [self.priorityLabel.topAnchor constraintEqualToAnchor:self.descLabel.bottomAnchor constant:8],
                                              [self.priorityLabel.leadingAnchor constraintEqualToAnchor:self.taskImageView.trailingAnchor constant:12],
                                              [self.priorityLabel.heightAnchor constraintEqualToConstant:20],
                                              [self.statusLabel.centerYAnchor constraintEqualToAnchor:self.priorityLabel.centerYAnchor],
                                              [self.statusLabel.leadingAnchor constraintEqualToAnchor:self.priorityLabel.trailingAnchor constant:8],
                                              [self.statusLabel.heightAnchor constraintEqualToConstant:20],
                                              [self.dateLabel.centerYAnchor constraintEqualToAnchor:self.priorityLabel.centerYAnchor],
                                              [self.dateLabel.trailingAnchor constraintEqualToAnchor:self.cardView.trailingAnchor constant:-12],
                                              [self.priorityLabel.bottomAnchor constraintEqualToAnchor:self.cardView.bottomAnchor constant:-14],
                                              ]];
}

- (void)configureWithName:(NSString *)name
              description:(NSString *)desc
                    image:(UIImage *)image
                 priority:(NSString *)priority
                   status:(NSString *)status
                     date:(NSString *)date {
    
    self.nameLabel.text = name;
    self.descLabel.text = desc;
    self.taskImageView.image = image;
    self.dateLabel.text = date;
    self.priorityLabel.text = [NSString stringWithFormat:@"  %@  ", priority];
    
    if ([priority isEqualToString:@"High"]) {
        self.priorityLabel.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:0.15];
        self.priorityLabel.textColor = [UIColor redColor];
    } else if ([priority isEqualToString:@"Medium"]) {
        self.priorityLabel.backgroundColor = [[UIColor greenColor] colorWithAlphaComponent:0.15];
        self.priorityLabel.textColor = [UIColor greenColor];
    } else {
        self.priorityLabel.backgroundColor = [[UIColor blueColor] colorWithAlphaComponent:0.15];
        self.priorityLabel.textColor = [UIColor blueColor];
    }
    self.statusLabel.text = [NSString stringWithFormat:@"  %@  ", status];
    
    if ([status isEqualToString:@"ToDo"]) {
        self.statusLabel.backgroundColor = [[UIColor greenColor] colorWithAlphaComponent:0.15];
        self.statusLabel.textColor = [UIColor greenColor];
    } else if ([status isEqualToString:@"Done"]) {
        self.statusLabel.backgroundColor = [[UIColor purpleColor] colorWithAlphaComponent:0.15];
        self.statusLabel.textColor = [UIColor purpleColor];
    } else {
        self.statusLabel.backgroundColor = [[UIColor orangeColor] colorWithAlphaComponent:0.15];
        self.statusLabel.textColor = [UIColor orangeColor];
    }
}

@end

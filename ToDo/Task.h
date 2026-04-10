#import <Foundation/Foundation.h>

@interface Task : NSObject <NSSecureCoding>

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *taskDescription;
@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) NSString *priority;
@property (nonatomic, strong) NSDate   *createdAt;
@property (nonatomic, strong) NSData   *imageData;  

- (instancetype)initWithName:(NSString *)name
             taskDescription:(NSString *)taskDescription
                      status:(NSString *)status
                    priority:(NSString *)priority;

@end

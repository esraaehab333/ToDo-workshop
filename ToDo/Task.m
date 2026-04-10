#import "Task.h"

@implementation Task

+ (BOOL)supportsSecureCoding { return YES; }

- (instancetype)initWithName:(NSString *)name
             taskDescription:(NSString *)taskDescription
                      status:(NSString *)status
                    priority:(NSString *)priority {
    self = [super init];
    if (self) {
        self.name            = name;
        self.taskDescription = taskDescription;
        self.status          = status;
        self.priority        = priority;
        self.createdAt       = [NSDate date]; 
        self.imageData       = nil;
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:self.name            forKey:@"name"];
    [coder encodeObject:self.taskDescription forKey:@"taskDescription"];
    [coder encodeObject:self.status          forKey:@"status"];
    [coder encodeObject:self.priority        forKey:@"priority"];
    [coder encodeObject:self.createdAt       forKey:@"createdAt"];
    [coder encodeObject:self.imageData       forKey:@"imageData"];
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super init];
    if (self) {
        self.name            = [coder decodeObjectOfClass:[NSString class] forKey:@"name"];
        self.taskDescription = [coder decodeObjectOfClass:[NSString class] forKey:@"taskDescription"];
        self.status          = [coder decodeObjectOfClass:[NSString class] forKey:@"status"];
        self.priority        = [coder decodeObjectOfClass:[NSString class] forKey:@"priority"];
        self.createdAt       = [coder decodeObjectOfClass:[NSDate class]   forKey:@"createdAt"];
        self.imageData       = [coder decodeObjectOfClass:[NSData class]   forKey:@"imageData"];
    }
    return self;
}

@end

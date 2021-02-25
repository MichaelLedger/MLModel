//
//  MLModel.m
//  MLModel-Demo
//
//  Created by Gavin Xing on 2021/2/24.
//

#import "MLModel.h"

@implementation MLArchivalModel

#pragma mark - NSSecureCoding
+ (BOOL)supportsSecureCoding {
    return YES;
}

#pragma mark - NSCoding
- (void)encodeWithCoder:(NSCoder *)coder {
    [self ml_modelEncodeWithCoder:coder];
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    if (self = [super init]) {
        [self ml_modelInitWithCoder:coder];
    }
    return self;
}

#pragma mark - NSCopying
- (id)copyWithZone:(NSZone *)zone {
    return [self ml_modelCopyWithZone:zone];
}

@end

@implementation MLAdressModel

@end

@implementation MLCourseModel

@end

@implementation MLStudentModel

#pragma mark - Override description
- (NSString *)description {
    NSMutableString *desc = [NSMutableString string];
    [desc appendFormat:@"\nstudent.name:%@ .uid:%@ .age:%ld .weight:%ld", _name, _uid, _age, _weight];
    [desc appendFormat:@"\naddress.country:%@ .province:%@ .city:%@", _address.country, _address.province, _address.city];
    for (unsigned int i = 0; i < _courses.count; i++) {
        MLCourseModel *courseModel = _courses[i];
        [desc appendFormat:@"\ncourses[%d].name = %@ .desc = %@", i, courseModel.name, courseModel.desc];
    }
    return desc;
}

#pragma mark - MLModel
// Attributes that need special handling
+ (NSDictionary<NSString *,id> *)ml_modelContainerPropertyGenericClass {
    return @{
             @"courses" : [MLCourseModel class],
             @"uid" : @"id"
             };
}

@end

//
//  MLModel.h
//  MLModel-Demo
//
//  Created by Gavin Xing on 2021/2/24.
//

#import <Foundation/Foundation.h>
#import "NSObject+MLModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MLArchivalModel : NSObject <NSSecureCoding, NSCopying>

@end

@interface MLAdressModel : MLArchivalModel

@property (nonatomic, copy) NSString *country;

@property (nonatomic, copy) NSString *province;

@property (nonatomic, copy) NSString *city;

@end

@interface MLCourseModel : MLArchivalModel

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *desc;

@end

@interface MLStudentModel : MLArchivalModel <MLModel>

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *uid;

@property (nonatomic, assign) NSInteger age;

@property (nonatomic, assign) NSInteger weight;

@property (nonatomic, strong) MLAdressModel *address;

@property (nonatomic, strong) NSArray <MLCourseModel *> *courses;

@end

NS_ASSUME_NONNULL_END

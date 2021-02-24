//
//  NSObject+MLModel.h
//  MLModel-Demo
//
//  Created by MichaelLedger on 2021/2/24.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// MLModel Protocol
@protocol MLModel <NSObject>

@optional
/// Optional protocol method: Return a dictionary indicating the processing rules for special fields
+ (nullable NSDictionary<NSString *, id> *)ml_modelContainerPropertyGenericClass;

@end

@interface NSObject (MLModel)

/// convert Dictionary to model
+ (instancetype)ml_modelWithDictionary:(NSDictionary *)dictionary;

/// Unarchive
- (instancetype)ml_modelInitWithCoder:(NSCoder *)aDecoder;

/// Archive
- (void)ml_modelEncodeWithCoder:(NSCoder *)aCoder;

@end

NS_ASSUME_NONNULL_END

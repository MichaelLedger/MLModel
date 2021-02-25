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

/*
 To save data in the form of archive, it can only be archived and decompressed once.
 Therefore, it can only target a small amount of data, and the data operation is relatively awkward,
 that is, if you want to change a small part of the data, you still need to decompress the entire data or archive the entire data.
 */
/// Unarchive
- (instancetype)ml_modelInitWithCoder:(NSCoder *)aDecoder;

/// Archive
- (void)ml_modelEncodeWithCoder:(NSCoder *)aCoder;

/// Copy
- (id)ml_modelCopyWithZone:(NSZone *)zone;

@end

NS_ASSUME_NONNULL_END

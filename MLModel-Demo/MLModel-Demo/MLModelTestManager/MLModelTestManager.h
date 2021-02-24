//
//  MLModelTestManager.h
//  MLModel-Demo
//
//  Created by MichaelLedger on 2021/2/24.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MLModelTestManager : NSObject

+ (void)ml_convertJsonToModel;

+ (void)ml_archiveAndUnarchiveModel;

@end

NS_ASSUME_NONNULL_END

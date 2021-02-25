//
//  MLModelTestManager.m
//  MLModel-Demo
//
//  Created by MichaelLedger on 2021/2/24.
//

#import "MLModelTestManager.h"
#import "NSObject+MLModel.h"
#import "MLModel.h"

@implementation MLModelTestManager

+ (void)ml_convertJsonToModel {
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"Student" ofType:@"json"];
    NSData *jsonData = [NSData dataWithContentsOfFile:filePath];
    
    // Read json from filePath
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
    NSLog(@"%@", json);
    
    // Convert json to model
    MLStudentModel *student = [MLStudentModel ml_modelWithDictionary:json];
    NSLog(@"student:%@", student);
}

+ (void)ml_archiveAndUnarchiveModel {
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"Student" ofType:@"json"];
    NSData *jsonData = [NSData dataWithContentsOfFile:filePath];
    
    // Read json from filePath
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
    NSLog(@"%@", json);
    
    // Convert json to model
    MLStudentModel *student = [MLStudentModel ml_modelWithDictionary:json];
    NSLog(@"%@", student);
    
    // Protocol NSCopying
    MLStudentModel *copiedStudent = [student copy];
    
    // Archive
    NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    NSString *studentArchivedPath = [cachePath stringByAppendingPathComponent:@"student.plist"];
    NSLog(@"studentArchivedPath:\n%@", studentArchivedPath);
    
    if (@available(iOS 12.0, *)) {
        NSError *archiveErr = nil;
        NSData *archivedData = [NSKeyedArchiver archivedDataWithRootObject:copiedStudent requiringSecureCoding:YES error:&archiveErr];
        if (archiveErr) {
            NSLog(@"archiveErr:%@", archiveErr.localizedDescription);
        } else {
            [archivedData writeToFile:studentArchivedPath atomically:YES];
            NSLog(@"==archived success==");
        }
    } else {
        BOOL archived = [NSKeyedArchiver archiveRootObject:copiedStudent toFile:studentArchivedPath];
        if (archived) {
            NSLog(@"==archived success==");
        } else {
            NSLog(@"==archived failed==");
        }
    }
    // Unarchive
    MLStudentModel *unarchivedStudent;
    if (@available(iOS 12.0, *)) {
        NSError *unarchiveErr = nil;
        /*
         [NSKeyedUnarchiver unarchivedObjectOfClass:[NSObject class] fromData:[NSData dataWithContentsOfFile:path] error:&unarchiveErr];

         *** -[NSKeyedUnarchiver _warnAboutNSObjectInAllowedClasses]: NSSecureCoding allowed classes list contains [NSObject class], which bypasses security by allowing any Objective-C class to be implicitly decoded. Consider reducing the scope of allowed classes during decoding by listing only the classes you expect to decode, or a more specific base class than NSObject. This will be disallowed in the future.
         */
        NSData *data = [NSData dataWithContentsOfFile:studentArchivedPath];
        NSLog(@"dataLength:%lu", (unsigned long)data.length);
        /*unarchiveErr:The data couldn’t be read because it isn’t in the correct format.*/
//        unarchivedStudent = [NSKeyedUnarchiver unarchivedObjectOfClass:[MLStudentModel class] fromData:data error:&unarchiveErr];
        unarchivedStudent = [NSKeyedUnarchiver unarchivedObjectOfClasses:[NSSet setWithObjects:
                                                                          [MLStudentModel class],
                                                                          [MLCourseModel class],
                                                                          [MLAdressModel class],
                                                                          [MLArchivalModel class],
                                                                          [NSArray class],
                                                                          nil]
                                                                fromData:data error:&unarchiveErr];
        if (unarchiveErr) {
            NSLog(@"unarchiveErr:%@", unarchiveErr.localizedDescription);
        } else {
            NSLog(@"==unarchived success==");
        }
    } else {
        unarchivedStudent = [NSKeyedUnarchiver unarchiveObjectWithFile:studentArchivedPath];
        NSLog(@"==unarchived %@==", unarchivedStudent == nil ? @"failed" : @"success");
    }
    NSLog(@"unarchivedStudent:%@", unarchivedStudent);
    
    NSLog(@"student memory address:%p", student);
    NSLog(@"copiedStudent memory address:%p", copiedStudent);
    NSLog(@"unarchivedStudent memory address:%p", unarchivedStudent);
}

@end

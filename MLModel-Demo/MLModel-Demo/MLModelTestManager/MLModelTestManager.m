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
    
    // Archive
    NSString *path = [NSString stringWithFormat:@"%@/person.plist", NSHomeDirectory()];
    [NSKeyedArchiver archiveRootObject:student toFile:path];

    // Unarchive
    MLStudentModel *archivedStudent = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
    NSLog(@"archivedStudent:%@", student);
}

@end

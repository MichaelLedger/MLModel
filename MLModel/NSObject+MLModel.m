//
//  NSObject+MLModel.m
//  MLModel-Demo
//
//  Created by MichaelLedger on 2021/2/24.
//

#import "NSObject+MLModel.h"
#import <objc/runtime.h>

@implementation NSObject (MLModel)

+ (instancetype)ml_modelWithDictionary:(NSDictionary *)dictionary {
    // Create current model object
    id object = [[self alloc] init];
    
    // Describes the properties declared by a class
    Class cls = [self class];
    unsigned int count;
    objc_property_t *propertyList = class_copyPropertyList(cls, &count);
    
    // Ergodic all the properties in the propertyList, use the property name as key, and look up the value in the dictionary
    for (unsigned int i = 0; i < count; i++) {
        objc_property_t property = propertyList[i];
        const char *propertyName = property_getName(property);
        NSString *propertyNameStr = [NSString stringWithUTF8String:propertyName];
        id value = [dictionary objectForKey:propertyNameStr];
        
        //Get the class name of the attribute
        NSString *propertyType;
        unsigned int attrCount;
        objc_property_attribute_t *attrs = property_copyAttributeList(property, &attrCount);
        for (unsigned int j = 0; j < attrCount; j++) {
            char firstNameChar = attrs[j].name[0];
            switch (firstNameChar) {
                case 'T'://Type encoding
                {
                    const char *attrValue = attrs[j].value;
                    if (attrValue) {
                        propertyType = [NSString stringWithUTF8String:attrValue];
                        // Remove escape characters: @"NSString" -> @NSString
                        propertyType = [propertyType stringByReplacingOccurrencesOfString:@"\"" withString:@""];
                        // Remove the '@' symbol
                        propertyType = [propertyType stringByReplacingOccurrencesOfString:@"@" withString:@""];
                    }
                }
                    break;
                default:
                    break;
            }
        }
        
        // Processing special attributes
        // Determine whether the current class implements the protocol method, and obtain the processing method of the special attribute specified in the protocol method
        NSDictionary *propertyTypeDic;
        if ([self respondsToSelector:@selector(ml_modelContainerPropertyGenericClass)]) {
            propertyTypeDic = [self performSelector:@selector(ml_modelContainerPropertyGenericClass)];
        }
        
        // Handling the problem that the key of the dictionary does not match the model attribute, such as 'id' -> 'uid'
        id anotherName = propertyTypeDic[propertyNameStr];
        if (anotherName != nil && [anotherName isKindOfClass:[NSString class]]) {
            value = dictionary[anotherName];
        }
        
        // Processing the case of model nested model
        if ([value isKindOfClass:[NSDictionary class]] && ![propertyType hasPrefix:@"NS"]) {
            Class modelClass = NSClassFromString(propertyType);
            if (modelClass != nil) {
                // Convert the nested dictionary data into Model
                value = [modelClass ml_modelWithDictionary:value];
            }
        }
        
        // Processing the case of model nested model array
        // Determine that the current value is an array, and there is a protocol method that returns perpertyTypeDic
        if ([value isKindOfClass:[NSArray class]] && propertyTypeDic) {
            Class itemModelClass = propertyTypeDic[propertyNameStr];
            // Encapsulated array: Convert each sub-data into Model orderly
            NSArray *arrayValue = value;
            if (arrayValue.count > 0) {
                @autoreleasepool {
                    NSMutableArray *items = [NSMutableArray arrayWithCapacity:0];
                    for (NSDictionary *itemDic in value) {
                        id item = [itemModelClass ml_modelWithDictionary:itemDic];
                        [items addObject:item];
                    }
                    value = items;
                }
            } else {
                value = @[];
            }
        }
        
        // Use KVC method to update value to object
        if (value != nil) {
            [object setValue:value forKey:propertyNameStr];
        }
    }
    
    free(propertyList);
    
    return object;
}

// Unarchive
- (instancetype)ml_modelInitWithCoder:(NSCoder *)aDecoder {
    if (!aDecoder) return self;
    if (!self) {
        return self;
    }
    
    unsigned int count;
    objc_property_t *propertyList = class_copyPropertyList([self class], &count);
    for (unsigned int i = 0; i < count; i++) {
        const char *propertyName = property_getName(propertyList[i]);
        NSString *name = [NSString stringWithUTF8String:propertyName];
        /*
        *** Terminating app due to uncaught exception 'NSUnknownKeyException', reason: '[<MLStudentModel 0x6000001947c0> setValue:forUndefinedKey:]: this class is not key value coding-compliant for the key XXX.'
         */
        NSArray <NSString *> *ignoreCharacters = [NSArray arrayWithObjects:@"hash", @"superclass", @"description", @"debugDescription", nil];
        if ([ignoreCharacters containsObject:name]) {
            continue;
        }
        id value = [aDecoder decodeObjectForKey:name];
        [self setValue:value forKey:name];
    }
    free(propertyList);
    
    return self;
}

// Archive
- (void)ml_modelEncodeWithCoder:(NSCoder *)aCoder {
    if (!aCoder) return;
    if (!self) {
        return;
    }
    unsigned int count;
    objc_property_t *propertyList = class_copyPropertyList([self class], &count);
    for (unsigned int i = 0; i < count; i++) {
        const char *propertyName = property_getName(propertyList[i]);
        NSString *name = [NSString stringWithUTF8String:propertyName];
        NSArray <NSString *> *ignoreCharacters = [NSArray arrayWithObjects:@"superclass", nil];
        if ([ignoreCharacters containsObject:name]) {
            continue;
        }
        id value = [self valueForKey:name];
        [aCoder encodeObject:value forKey:name];
    }
    free(propertyList);
}

// Copy
- (id)ml_modelCopyWithZone:(NSZone *)zone {
    id newObject = [[[self class] allocWithZone:zone] init];
    unsigned int count;
    objc_property_t *propertyList = class_copyPropertyList([self class], &count);
    for (unsigned int i = 0; i < count; i++) {
        const char *propertyName = property_getName(propertyList[i]);
        NSString *name = [NSString stringWithUTF8String:propertyName];
        /*
         *** Terminating app due to uncaught exception 'NSUnknownKeyException', reason: '[<MLStudentModel 0x6000039fcf40> setValue:forUndefinedKey:]: this class is not key value coding-compliant for the key XXX.'
         */
        NSArray <NSString *> *ignoreCharacters = [NSArray arrayWithObjects:@"hash", @"superclass", @"description", @"debugDescription", nil];
        if ([ignoreCharacters containsObject:name]) {
            continue;
        }
        id value = [self valueForKey:name];
        [newObject setValue:value forKey:name];
    }
    free(propertyList);
    return newObject;
}

@end

//
//  JHPhotoPickerModel.m
//  JHPhotoPickerController
//
//  Created by Jiahao Huang on 2021/4/13.
//

#import "JHPhotoPickerModel.h"

@implementation JHPhotoPickerModel

- (instancetype)initWithDict:(NSDictionary *)dict{
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

+ (instancetype)objectWithKeyValues:(id)keyValues{
    
    return [[self alloc] initWithDict:keyValues];
}


@end

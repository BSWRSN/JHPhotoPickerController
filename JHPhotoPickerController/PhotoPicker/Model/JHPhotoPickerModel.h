//
//  JHPhotoPickerModel.h
//  JHPhotoPickerController
//
//  Created by Jiahao Huang on 2021/4/13.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JHPhotoPickerModel : NSObject

@property (nonatomic, copy) NSString *photoStr;
@property (nonatomic, assign) CGRect convertRect;

- (instancetype)initWithDict:(NSDictionary *)dict;
+ (instancetype)objectWithKeyValues:(id)keyValues;

@end

NS_ASSUME_NONNULL_END

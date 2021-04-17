//
//  UIView+JHExtension.h
//  JHPhotoPickerController
//
//  Created by Jiahao Huang on 2021/4/17.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (JHExtension)

@property (nonatomic, assign) CGFloat jh_x;
@property (nonatomic, assign) CGFloat jh_y;
@property (nonatomic, assign) CGFloat jh_width;
@property (nonatomic, assign) CGFloat jh_height;
@property (nonatomic, assign) CGSize jh_size;
@property (nonatomic, assign) CGPoint jh_origin;
@property (nonatomic, assign) CGFloat jh_centerX;
@property (nonatomic, assign) CGFloat jh_centerY;

@end

NS_ASSUME_NONNULL_END

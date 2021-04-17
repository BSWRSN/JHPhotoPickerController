//
//  JHPhotoPreviewView.h
//  JHPhotoPickerController
//
//  Created by Jiahao Huang on 2021/4/13.
//

#import <UIKit/UIKit.h>
#import "JHPhotoPickerModel.h"

typedef void(^SingleBlock)(void);

NS_ASSUME_NONNULL_BEGIN

@interface JHPhotoPreviewView : UIView

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, assign) CGRect convertRect;
@property (nonatomic, strong) JHPhotoPickerModel *model;

- (void)singleTapGestureRecognizerBlock:(SingleBlock)block;

- (void)recoverSubviews;

@end

NS_ASSUME_NONNULL_END

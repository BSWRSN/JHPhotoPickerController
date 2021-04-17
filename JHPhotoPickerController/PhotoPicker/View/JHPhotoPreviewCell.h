//
//  JHPhotoPreviewCell.h
//  JHPhotoPickerController
//
//  Created by Jiahao Huang on 2021/4/13.
//

#import <UIKit/UIKit.h>
#import "JHPhotoPickerModel.h"
#import "JHPhotoPreviewView.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^SingleTapGestureBlock)(void);


@interface JHPhotoPreviewCell : UICollectionViewCell

@property (nonatomic, assign) CGRect convertRect;
@property (nonatomic, strong) JHPhotoPreviewView *previewView;
@property (nonatomic, strong) JHPhotoPickerModel *model;

- (void)recoverSubviews;
- (void)previewSingleTapGestureRecognizerBlock:(SingleTapGestureBlock)block;

@end

NS_ASSUME_NONNULL_END

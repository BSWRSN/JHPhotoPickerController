//
//  JHPhotoBrowserCell.h
//  JHPhotoPickerController
//
//  Created by Jiahao Huang on 2021/4/13.
//

#import <UIKit/UIKit.h>
#import "JHPhotoPickerModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^SingleBlock)(void);


@interface JHPhotoBrowserCell : UICollectionViewCell

@property (nonatomic, assign) CGRect convertRect;
@property (nonatomic, strong) JHPhotoPickerModel *model;

- (void)recoverSubviews;
- (void)singleTapGestureRecognizerBlock:(SingleBlock)block;

@end

NS_ASSUME_NONNULL_END

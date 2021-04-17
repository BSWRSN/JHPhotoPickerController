//
//  JHPhotoPickerCell.h
//  JHPhotoPickerController
//
//  Created by Jiahao Huang on 2021/4/13.
//

#import <UIKit/UIKit.h>
#import "JHPhotoPickerModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHPhotoPickerCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, strong) JHPhotoPickerModel *model;

@end

NS_ASSUME_NONNULL_END

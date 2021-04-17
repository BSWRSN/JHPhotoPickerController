//
//  JHPhotoPickerCell.m
//  JHPhotoPickerController
//
//  Created by Jiahao Huang on 2021/4/13.
//

#import "JHPhotoPickerCell.h"

@implementation JHPhotoPickerCell

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self initializeView];
    }
    return self;
}

- (void)initializeView{
    [self.contentView addSubview:self.imageView];
    
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.right.mas_equalTo(0);
    }];
}


#pragma mark - setter
- (void)setModel:(JHPhotoPickerModel *)model{
    _model = model;
    
    self.imageView.image = [UIImage imageNamed:model.photoStr];
}


#pragma mark - getter
- (UIImageView *)imageView{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.layer.masksToBounds = YES;
    }
    return _imageView;
}

@end

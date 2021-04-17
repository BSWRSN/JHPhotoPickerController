//
//  JHPhotoPreviewCell.m
//  JHPhotoPickerController
//
//  Created by Jiahao Huang on 2021/4/13.
//

#import "JHPhotoPreviewCell.h"


@interface JHPhotoPreviewCell ()

@property (nonatomic, copy) SingleTapGestureBlock singleTapGestureBlock;

@end

@implementation JHPhotoPreviewCell

- (instancetype)initWithFrame:(CGRect)frame{
    if ([super initWithFrame:frame]) {
        self.backgroundColor = [UIColor blackColor];
        [self initializeView];
    }
    return self;
}

#pragma mark - Private methods
- (void)initializeView{
    self.previewView.frame = self.bounds;
    
    __weak typeof(self) weakSelf = self;
    [self.previewView singleTapGestureRecognizerBlock:^ {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (strongSelf.singleTapGestureBlock) {
            strongSelf.singleTapGestureBlock();
        }
    }];
    [self addSubview:self.previewView];
}

- (void)previewSingleTapGestureRecognizerBlock:(SingleTapGestureBlock)block{
    _singleTapGestureBlock = block;
}

/// 恢复 previewView 大小
- (void)recoverSubviews{
    [self.previewView recoverSubviews];
}

#pragma mark - setter
- (void)setModel:(JHPhotoPickerModel *)model{
//    [super setModel:model];
    _model = model;
    self.previewView.model = model;
}

- (void)setConvertRect:(CGRect)convertRect{
    _convertRect = convertRect;
    
    self.previewView.convertRect = convertRect;
}

#pragma mark - getter
- (JHPhotoPreviewView *)previewView{
    if (!_previewView) {
        _previewView = [[JHPhotoPreviewView alloc] initWithFrame:CGRectZero];
    }
    return _previewView;
}

@end

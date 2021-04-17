//
//  JHPhotoPreviewView.m
//  JHPhotoPickerController
//
//  Created by Jiahao Huang on 2021/4/13.
//

#import "JHPhotoPreviewView.h"

@interface JHPhotoPreviewView ()<UIScrollViewDelegate>

@property (nonatomic, copy) SingleBlock singleTapGestureRecognizerBlock;

@end


@implementation JHPhotoPreviewView

- (instancetype)initWithFrame:(CGRect)frame{
    if ([super initWithFrame:frame]) {
        [self initializeView];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.scrollView.frame = CGRectMake(10, 0, self.jh_width - 20, self.jh_height);
    
    [self recoverSubviews];
}

#pragma mark - Private methods
- (void)initializeView{
    [self addSubview:self.scrollView];
    [self.scrollView addSubview:self.imageView];
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapGestureRecognizer:)];
    [self addGestureRecognizer:singleTap];
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTapGestureRecognizer:)];
    doubleTap.numberOfTapsRequired = 2;
    [singleTap requireGestureRecognizerToFail:doubleTap];
    [self addGestureRecognizer:doubleTap];
}

/// 刷新 imageView 中心点
- (void)refreshImageViewCenter{
    CGFloat offsetX = (self.scrollView.jh_width > self.scrollView.contentSize.width) ? ((self.scrollView.jh_width - self.scrollView.contentSize.width) * 0.5) : 0.0;
    CGFloat offsetY = (self.scrollView.jh_height > self.scrollView.contentSize.height) ? ((self.scrollView.jh_height - self.scrollView.contentSize.height) * 0.5) : 0.0;
    self.imageView.center = CGPointMake(self.scrollView.contentSize.width * 0.5 + offsetX, self.scrollView.contentSize.height * 0.5 + offsetY);
}

/// 滑动切换后恢复 scrollView 大小
- (void)recoverSubviews{
    [self.scrollView setZoomScale:self.scrollView.minimumZoomScale animated:NO];
    [self resizeSubviews];
}

/// 设置imageview frame
- (void)resizeSubviews{
    self.imageView.jh_origin = CGPointZero;
    self.imageView.jh_width = self.scrollView.jh_width;
    
    UIImage *image = self.imageView.image;
    if (image.size.height / image.size.width > self.jh_height / self.scrollView.jh_width) {
        self.imageView.jh_height = floor(image.size.height / (image.size.width / self.scrollView.jh_width));
    } else {
        CGFloat height = image.size.height / image.size.width * self.scrollView.jh_width;
        if (height < 1 || isnan(height)) {
            height = self.jh_height;
        }
        height = floor(height);
        self.imageView.jh_height = height;
        self.imageView.jh_centerY = self.jh_height/2;
    }
    
    if (self.imageView.jh_height > self.jh_height && self.imageView.jh_height - self.jh_height <= 1) {
        self.imageView.jh_height = self.jh_height;
    }
    
    CGFloat contentSizeHeight = MAX(self.imageView.jh_height, self.jh_height);
    self.scrollView.contentSize = CGSizeMake(self.scrollView.jh_width, contentSizeHeight);
    [self.scrollView scrollRectToVisible:self.bounds animated:NO];
    self.scrollView.alwaysBounceVertical = self.imageView.jh_height <= self.jh_height ? NO : YES;
}

- (void)singleTapGestureRecognizerBlock:(SingleBlock)block{
    _singleTapGestureRecognizerBlock = block;
}

#pragma mark - UITapGestureRecognizer Event
- (void)doubleTapGestureRecognizer:(UITapGestureRecognizer *)tap{
    if (self.scrollView.zoomScale > self.scrollView.minimumZoomScale) {
        self.scrollView.contentInset = UIEdgeInsetsZero;
        [self.scrollView setZoomScale:self.scrollView.minimumZoomScale animated:YES];
    } else {
        CGPoint touchPoint = [tap locationInView:self.imageView];
        CGFloat newZoomScale = 2.1;
        CGFloat xsize = self.jh_width/newZoomScale;
        CGFloat ysize = self.jh_height/newZoomScale;
        [self.scrollView zoomToRect:CGRectMake(touchPoint.x - xsize/2, touchPoint.y - ysize/2, xsize, ysize) animated:YES];
    }
}

- (void)singleTapGestureRecognizer:(UITapGestureRecognizer *)tap{
    
    CGRect convertRect = self.model.convertRect;
    if (convertRect.size.width <= 0) {
        convertRect = self.convertRect;
    }
    
    [UIView animateWithDuration:0.15 animations:^{
        [self.scrollView setZoomScale:self.scrollView.minimumZoomScale animated:YES];
        self.imageView.frame = convertRect;
    } completion:^(BOOL finished) {
        if (self.singleTapGestureRecognizerBlock) {
            self.singleTapGestureRecognizerBlock();
        }
    }];
}




#pragma mark - UIScrollViewDelegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return self.imageView;
}

- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(UIView *)view{
    scrollView.contentInset = UIEdgeInsetsZero;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView{
    [self refreshImageViewCenter];
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale{
    
}


#pragma mark - setter
- (void)setModel:(JHPhotoPickerModel *)model{
    _model = model;
    
    self.imageView.image = [UIImage imageNamed:model.photoStr];
}

- (void)setConvertRect:(CGRect)convertRect{
    _convertRect = convertRect;
    
    if (convertRect.origin.x == self.model.convertRect.origin.x && convertRect.origin.y == self.model.convertRect.origin.y) {
        self.imageView.frame = convertRect;
        [UIView animateWithDuration:0.15 animations:^{
            [self resizeSubviews];
        } completion:^(BOOL finished) {
            
        }];
    }
}

#pragma mark - getter
- (UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.backgroundColor = [UIColor blackColor];
        _scrollView.bouncesZoom = YES;
        _scrollView.maximumZoomScale = 4;
        _scrollView.minimumZoomScale = 1.0;
        _scrollView.multipleTouchEnabled = YES;
        _scrollView.delegate = self;
        _scrollView.scrollsToTop = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _scrollView.delaysContentTouches = NO;
        _scrollView.canCancelContentTouches = YES;
        _scrollView.alwaysBounceVertical = NO;
        
        if (@available(iOS 11, *)) {
            _scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    return _scrollView;
}

- (UIImageView *)imageView{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.clipsToBounds = YES;
    }
    return _imageView;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

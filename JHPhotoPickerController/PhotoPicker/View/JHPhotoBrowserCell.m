//
//  JHPhotoBrowserCell.m
//  JHPhotoPickerController
//
//  Created by Jiahao Huang on 2021/4/13.
//

#import "JHPhotoBrowserCell.h"


@interface JHPhotoBrowserCell ()<UIScrollViewDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, copy) SingleBlock singleTapGestureRecognizerBlock;
/// 判断 scrollView 是否缩放
@property (nonatomic, assign) BOOL isScrollViewZoom;
/// 记录开始拖拽时手指触摸点
@property (nonatomic, assign) CGPoint location;
/// 记录拖拽前 imageView 的 frame
@property (nonatomic, assign) CGRect imageViewFrame;

@end

@implementation JHPhotoBrowserCell

- (instancetype)initWithFrame:(CGRect)frame{
    if ([super initWithFrame:frame]) {
//        self.backgroundColor = [UIColor blackColor];
        [self initializeView];
    }
    return self;
}

#pragma mark - Private methods
- (void)initializeView{
    [self addSubview:self.scrollView];
    [self.scrollView addSubview:self.imageView];
    
    // 延迟创建是为了防止打开时多次点击导致关闭
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 单击
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapGestureRecognizer:)];
        [self addGestureRecognizer:singleTap];
        
        // 双击
        UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTapGestureRecognizer:)];
        doubleTap.numberOfTapsRequired = 2;
        [singleTap requireGestureRecognizerToFail:doubleTap];
        [self addGestureRecognizer:doubleTap];
        
        // 拖拽
        UIPanGestureRecognizer *dragPan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(dragPanGestureRecognizer:)];
        dragPan.delegate = self;
        [self.scrollView addGestureRecognizer:dragPan];
    });
}

/// 刷新 imageView 中心点
- (void)refreshImageViewCenter{
    CGFloat offsetX = (self.scrollView.jh_width > self.scrollView.contentSize.width) ? ((self.scrollView.jh_width - self.scrollView.contentSize.width)/2) : 0.0;
    CGFloat offsetY = (self.scrollView.jh_height > self.scrollView.contentSize.height) ? ((self.scrollView.jh_height - self.scrollView.contentSize.height)/2) : 0.0;
    self.imageView.center = CGPointMake(self.scrollView.contentSize.width/2 + offsetX, self.scrollView.contentSize.height/2 + offsetY);
}

/// 滑动切换后恢复 scrollView 大小
- (void)recoverSubviews{
    [self.scrollView setZoomScale:self.scrollView.minimumZoomScale animated:false];
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
    [self.scrollView scrollRectToVisible:self.bounds animated:false];
    self.scrollView.alwaysBounceVertical = self.imageView.jh_height <= self.jh_height ? false : true;
}

/// 关闭浏览
- (void)closeBrowser{
    CGRect convertRect = self.model.convertRect;
    if (convertRect.size.width <= 0) {
        convertRect = self.convertRect;
    }
    
    [UIView animateWithDuration:0.2 animations:^{
        [self.scrollView setZoomScale:self.scrollView.minimumZoomScale animated:true];
        self.imageView.frame = convertRect;
        self.superview.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.1];
    } completion:^(BOOL finished) {
        if (self.singleTapGestureRecognizerBlock) {
            self.singleTapGestureRecognizerBlock();
        }
    }];
    
//    [UIView transitionWithView:self.imageView duration:3 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
//        [self.scrollView setZoomScale:self.scrollView.minimumZoomScale animated:YES];
//        self.imageView.frame = convertRect;
//        self.superview.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.1];
//    } completion:^(BOOL finished) {
//        if (self.singleTapGestureRecognizerBlock) {
//            self.singleTapGestureRecognizerBlock();
//        }
//    }];
}

#pragma mark - UITapGestureRecognizer Event
// 双击
- (void)doubleTapGestureRecognizer:(UITapGestureRecognizer *)tap{
    if (self.scrollView.zoomScale > self.scrollView.minimumZoomScale) {
        self.scrollView.contentInset = UIEdgeInsetsZero;
        [self.scrollView setZoomScale:self.scrollView.minimumZoomScale animated:true];
    } else {
        CGPoint touchPoint = [tap locationInView:self.imageView];
        CGFloat newZoomScale = 2.1;
        CGFloat scaleX = self.jh_width/newZoomScale;
        CGFloat scaleY = self.jh_height/newZoomScale;
        [self.scrollView zoomToRect:CGRectMake(touchPoint.x - scaleX/2, touchPoint.y - scaleY/2, scaleX, scaleY) animated:true];
    }
}

// 单击
- (void)singleTapGestureRecognizer:(UITapGestureRecognizer *)tap{
    
    [self closeBrowser];
}

// 拖拽
- (void)dragPanGestureRecognizer:(UIPanGestureRecognizer *)pan{
    if (pan.state != UIGestureRecognizerStateEnded && pan.state != UIGestureRecognizerStateBegan) {
        /// 获取拖拽时手指触摸点
        CGPoint point = [pan locationInView:pan.view];
        /// 获取开始拖拽时到拖拽后的距离
        CGPoint translation = [pan translationInView:pan.view];
        
        // 背景渐变
        CGFloat translationY = translation.y/1.5;
        CGFloat alphaComponent = 1 - translationY/256;
        if (alphaComponent > 0.2 && translation.y > 0) {
            self.superview.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:alphaComponent];
        }
        
        if (translation.y >= 0) {
            CGFloat scale = (self.imageViewFrame.size.height - translationY)/self.imageViewFrame.size.height;// 缩放比例
            self.imageView.jh_width = self.imageViewFrame.size.width * scale;
            self.imageView.jh_height = self.imageViewFrame.size.height - translationY;
            if (self.imageView.jh_width < 120) {
                CGFloat scaleWidth = 120/self.imageViewFrame.size.width;
                self.imageView.jh_width = 120;
                self.imageView.jh_height = self.imageViewFrame.size.height * scaleWidth;
            }
        }
        
        // 手指触摸点跟图片的比例
        CGFloat scaleX = self.location.x/self.imageViewFrame.size.width;
        CGFloat scaleY = (self.location.y - self.imageViewFrame.origin.y)/self.imageViewFrame.size.height;
        
        // 当前图片的 x、y 到触摸点的距离
        CGFloat xn = self.imageView.jh_width * scaleX;
        CGFloat yn = self.imageView.jh_height * scaleY;
        
        self.imageView.jh_x = point.x - xn;
        self.imageView.jh_y = point.y - yn;
        
    } else if (pan.state == UIGestureRecognizerStateEnded) {
        CGPoint velocity = [pan velocityInView:self];// 获取拖拽速度
        
        if (velocity.y > 100) {
            // 速度大于 100 关闭浏览
            [self closeBrowser];
        } else {
            [UIView animateWithDuration:0.2 animations:^{
                self.imageView.frame = self.imageViewFrame;
                self.superview.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:1];
            } completion:^(BOOL finished) {
                
            }];
        }
    }
    
}

// block
- (void)singleTapGestureRecognizerBlock:(SingleBlock)block{
    _singleTapGestureRecognizerBlock = block;
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {

    }
    CGPoint point = [gestureRecognizer locationInView:gestureRecognizer.view];
    CGPoint translation = [(UIPanGestureRecognizer *)gestureRecognizer translationInView:gestureRecognizer.view];
    
    if (fabs(translation.x) > fabs(translation.y) || translation.y <= 0) {
        return false;
    }
    
    if (self.isScrollViewZoom) {
        if ( self.scrollView.contentOffset.y == 0) {
            self.location = point;
            self.imageViewFrame = self.imageView.frame;
            return true;
        }
        return false;
    }
    
    self.location = point;
    self.imageViewFrame = self.imageView.frame;
    
    return true;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    
    if (self.isScrollViewZoom) {
        return true;
    } else {
        return false;
    }
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
    if (scale == 1) {
        self.isScrollViewZoom = false;
    } else {
        self.isScrollViewZoom = true;
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{

}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{

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
        [UIView animateWithDuration:0.2 animations:^{
            [self resizeSubviews];
        } completion:^(BOOL finished) {
            
        }];
    }
}

#pragma mark - getter
- (UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(10, 0, self.jh_width - 20, self.jh_height)];
//        _scrollView.backgroundColor = [UIColor blackColor];
        _scrollView.bouncesZoom = true;
        _scrollView.maximumZoomScale = 4;
        _scrollView.minimumZoomScale = 1;
        _scrollView.multipleTouchEnabled = true;
        _scrollView.delegate = self;
        _scrollView.scrollsToTop = false;
        _scrollView.showsHorizontalScrollIndicator = false;
        _scrollView.showsVerticalScrollIndicator = false;
        _scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _scrollView.delaysContentTouches = false;
        _scrollView.canCancelContentTouches = true;
        _scrollView.alwaysBounceVertical = false;
        
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
        _imageView.clipsToBounds = true;
    }
    return _imageView;
}

@end

//
//  JHPhotoPreviewController.m
//  JHPhotoPickerController
//
//  Created by Jiahao Huang on 2021/4/13.
//

#import "JHPhotoPreviewController.h"
#import "JHPhotoPreviewCell.h"
#import "JHPhotoPickerModel.h"

static NSString *const JHPhotoPreviewCellID = @"JHPhotoPreviewCell";

@interface JHPhotoPreviewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UINavigationControllerDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *photoArray;
@property (nonatomic, assign) CGRect convertRect;

@end

@implementation JHPhotoPreviewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initializeView];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    [self.navigationController setNavigationBarHidden:YES animated:NO];
    self.navigationController.delegate = self;
    self.navigationController.navigationBar.translucent = YES;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
//    [self.navigationController setNavigationBarHidden:NO animated:NO];
    self.navigationController.navigationBar.translucent = NO;
    
}

- (BOOL)prefersStatusBarHidden{
    return YES;
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation{
    return UIStatusBarAnimationFade;
}


#pragma mark - Public Methods
- (void)initializeView{
    if (@available(iOS 11.0, *)) {
        self.collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    [self.view addSubview:self.collectionView];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(@0);
        make.left.mas_equalTo(-10);
        make.right.mas_equalTo(10);
    }];
}

- (void)reloadWithPhotoArray:(NSMutableArray *)photoArray index:(NSInteger)index{
    _photoArray = photoArray;
    
    self.collectionView.contentSize = CGSizeMake(photoArray.count * (KSCREEN_WIDTH + 20), 0);
    [self.collectionView setContentOffset:CGPointMake((KSCREEN_WIDTH + 20) * index, 0) animated:NO];
    
    JHPhotoPickerModel *model = photoArray[index];
    self.convertRect = model.convertRect;
    
    [self.collectionView reloadData];
}


#pragma mark - UINavigationControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    // 判断要显示的控制器是否是自己
    BOOL isShowHomePage = [viewController isKindOfClass:[JHPhotoPreviewController class]];
    [self.navigationController setNavigationBarHidden:isShowHomePage animated:YES];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.photoArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    JHPhotoPreviewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:JHPhotoPreviewCellID forIndexPath:indexPath];
    
    cell.model = self.photoArray[indexPath.item];
    cell.convertRect = self.convertRect;
    
    __weak typeof(self) weakSelf = self;
    [cell previewSingleTapGestureRecognizerBlock:^ {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [self.navigationController setNavigationBarHidden:NO animated:NO];
        [strongSelf.navigationController popViewControllerAnimated:NO];
        [strongSelf dismissViewControllerAnimated:NO completion:nil];
    }];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([cell isKindOfClass:[JHPhotoPreviewCell class]]) {
        [(JHPhotoPreviewCell *)cell recoverSubviews];
    }
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
//    if ([cell isKindOfClass:[LHPhotoPreviewCell class]]) {
//        [(LHPhotoPreviewCell *)cell recoverSubviews];
//    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
}




#pragma mark - UICollectionViewDelegateFlowLayout
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    
    return UIEdgeInsetsMake(0, 0, 0, 0);
}


#pragma mark - getter
- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(KSCREEN_WIDTH + 20, KSCREEN_HEIGHT);
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor blackColor];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.pagingEnabled = YES;
        _collectionView.scrollsToTop = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.contentOffset = CGPointMake(0, 0);
        
        [_collectionView registerClass:[JHPhotoPreviewCell class] forCellWithReuseIdentifier:JHPhotoPreviewCellID];
    }
    return _collectionView;
}

- (NSMutableArray *)photoArray{
    if (!_photoArray) {
        _photoArray = [NSMutableArray array];
    }
    return _photoArray;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

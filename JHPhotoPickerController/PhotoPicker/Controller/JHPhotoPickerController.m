//
//  JHPhotoPickerController.m
//  JHPhotoPickerController
//
//  Created by Jiahao Huang on 2021/4/13.
//

#import "JHPhotoPickerController.h"
#import "JHPhotoPickerCell.h"
#import "JHPhotoPreviewController.h"

static NSString *const JHPhotoPickerCellID = @"JHPhotoPickerCell";

@interface JHPhotoPickerController ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation JHPhotoPickerController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initializeView];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.view.backgroundColor = [UIColor blackColor];
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.navigationBar.barTintColor = [UIColor blackColor];
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
//    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
}


- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.translucent = NO;
}

- (void)initializeView{
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    if (@available(iOS 11.0, *)) {
        self.collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentAutomatic;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    [self.view addSubview:self.collectionView];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(@0);
        make.top.mas_equalTo(JH_NavBarHeight);
    }];
    
}


#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.photoArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    JHPhotoPickerCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:JHPhotoPickerCellID forIndexPath:indexPath];
    
    cell.model = [JHPhotoPickerModel objectWithKeyValues:self.photoArray[indexPath.item]];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    JHPhotoPreviewController *vc = [[JHPhotoPreviewController alloc] init];
    NSMutableArray *photoArr = [NSMutableArray array];
    
    for (int i = 0; i < self.photoArray.count; i++) {
        JHPhotoPickerModel *model = [JHPhotoPickerModel objectWithKeyValues:self.photoArray[i]];
        JHPhotoPickerCell *cell = (JHPhotoPickerCell *)[collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        model.convertRect = [cell.imageView convertRect:cell.imageView.bounds toView:[UIApplication sharedApplication].keyWindow];
        [photoArr addObject:model];
    }
    
    [vc reloadWithPhotoArray:photoArr index:indexPath.item];
    
    [self.navigationController pushViewController:vc animated:NO];
}


#pragma mark - UICollectionViewDelegateFlowLayout
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    
    return UIEdgeInsetsMake(2, 2, 2, 2);
}


#pragma mark - getter
- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake((KSCREEN_WIDTH-10)/4, (KSCREEN_WIDTH-10)/4);
        layout.minimumLineSpacing = 2;
        layout.minimumInteritemSpacing = 0;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        
        [_collectionView registerClass:[JHPhotoPickerCell class] forCellWithReuseIdentifier:JHPhotoPickerCellID];
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

//
//  JHPhotoPreviewController.h
//  JHPhotoPickerController
//
//  Created by Jiahao Huang on 2021/4/13.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JHPhotoPreviewController : UIViewController

- (void)reloadWithPhotoArray:(NSMutableArray *)photoArray index:(NSInteger)index;

@end

NS_ASSUME_NONNULL_END

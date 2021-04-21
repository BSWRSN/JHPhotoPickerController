//
//  ViewController.m
//  JHPhotoPickerController
//
//  Created by Jiahao Huang on 2021/4/13.
//

#import "ViewController.h"
#import "JHPhotoPickerController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    NSLog(@"status bar height == %f, navigation bar height == %f", [UIApplication sharedApplication].statusBarFrame.size.height, [UINavigationBar appearance].frame.size.height);
    self.navigationItem.title = @"图片浏览";
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
}

- (IBAction)openPhotoPicker:(UIButton *)sender {
    JHPhotoPickerController *vc = [[JHPhotoPickerController alloc] init];
    vc.photoArray = [NSMutableArray arrayWithObjects:@{@"photoStr":@"danaimei"}, @{@"photoStr":@"lptj1"}, @{@"photoStr":@"lptj2"}, @{@"photoStr":@"lptj3"}, @{@"photoStr":@"lptj4"}, @{@"photoStr":@"lptj5"}, @{@"photoStr":@"lptj6"}, @{@"photoStr":@"lptj7"}, @{@"photoStr":@"nuli"}, nil];
    [self.navigationController pushViewController:vc animated:YES];
}


@end

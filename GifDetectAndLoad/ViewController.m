//
//  ViewController.m
//  GifDetectAndLoad
//
//  Created by Zark on 2017/8/2.
//  Copyright © 2017年 Zarky. All rights reserved.
//

#import "ViewController.h"
#import <Photos/Photos.h>
#import "TableViewController.h"

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray<PHAsset *> *gifAssetsArr;
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation ViewController

#pragma LifeCircle

- (void)viewDidLoad {
    [super viewDidLoad];
    // 首先获取一次权限，再重新 run
    // 懒，没手动写
    [self gifAssetsArr];
    
    [self configNaviBtn];
    
    [self.view addSubview:self.tableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma Private

- (void)configNaviBtn {
    UIBarButtonItem *reloadBtn = [[UIBarButtonItem alloc] initWithTitle:@"R" style:UIBarButtonItemStylePlain target:self action:@selector(reloadTableView)];
    
    self.navigationItem.rightBarButtonItem = reloadBtn;
}

- (void)reloadTableView {
    [self updateDataSource];
    [self.tableView reloadData];
    NSLog(@"TableView Reload Data");
}

- (void)updateDataSource {
    NSMutableArray *array = [NSMutableArray array];
    PHFetchResult *imageRes = [PHAsset fetchAssetsWithMediaType:PHAssetMediaTypeImage options:nil];
    for (PHAsset *asset in imageRes) {
        // 或者可使用同样未公开的属性 @"uniformTypeIdentifier"
        // [[selectedAssetURL valueForKey:@"uniformTypeIdentifier"] isEqualToString:@"com.compuserve.gif"]
        if ([[asset valueForKey:@"filename"] hasSuffix:@"GIF"]) {
            [array addObject:asset];
        }
    }
    self.gifAssetsArr = [array mutableCopy];
}

#pragma TableView Delegate & DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.gifAssetsArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    cell.textLabel.text = [NSString stringWithFormat:@"GIF %lu", indexPath.row+1];
    
    
    
  
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
        PHImageRequestOptions *option = [[PHImageRequestOptions alloc] init];
        option.networkAccessAllowed = YES;
        option.version = PHImageRequestOptionsVersionOriginal;  // important
    
        [[PHCachingImageManager defaultManager] requestImageDataForAsset:self.gifAssetsArr[indexPath.row] options:option resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
            if (imageData) {
                TableViewController *vc = [[TableViewController alloc] init];
                NSMutableArray *array = [NSMutableArray array];
                for (NSString *key in info.allKeys) {
                    NSDictionary *dict = @{key: [info valueForKey:key]};
                    [array addObject:dict];
                }
                vc.assetDetail = array;
                [self.navigationController pushViewController:vc animated:YES];
            } else {
                UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"未知错误发生了！" message:@"没有获取到 NSData" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
                [alertVC addAction:okAction];
                [self presentViewController:alertVC animated:YES completion:nil];
            }
        }];
    
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma Getters & Setters

- (NSMutableArray *) gifAssetsArr {
    if (!_gifAssetsArr) {
        NSMutableArray *array = [NSMutableArray array];
        PHFetchResult *imageRes = [PHAsset fetchAssetsWithMediaType:PHAssetMediaTypeImage options:nil];
        for (PHAsset *asset in imageRes) {
            // 或者可使用同样未公开的属性 @"uniformTypeIdentifier"
            // [[selectedAssetURL valueForKey:@"uniformTypeIdentifier"] isEqualToString:@"com.compuserve.gif"]
            if ([[asset valueForKey:@"filename"] hasSuffix:@"GIF"]) {
                [array addObject:asset];
            }
        }
        _gifAssetsArr = [array mutableCopy];
    }
    return _gifAssetsArr;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = ({
            UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
            tableView.delegate = self;
            tableView.dataSource = self;
            tableView.tableFooterView = [[UIView alloc] init];
            [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
            tableView;
        });
    }
    
    return _tableView;
}

@end

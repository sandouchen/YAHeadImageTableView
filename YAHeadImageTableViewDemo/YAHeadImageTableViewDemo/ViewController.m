//
//  ViewController.m
//  YAHeadImageTableViewDemo
//
//  Created by yinyao on 2017/3/13.
//  Copyright © 2017年 yinyao. All rights reserved.
//

#import "ViewController.h"
#import "CommonMacro.h"
#import "YAImageTableViewVC.h"

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, strong) NSArray *dataArr;

@end

@implementation ViewController

static NSString *cellIdentifier = @"Cell";

#pragma mark - 视图生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"Demo";
    
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.rowHeight = 50.0f;
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.textLabel.text = self.dataArr[indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //初始化目标控制器
    YAImageTableViewVC *detailVC = [YAImageTableViewVC new];
    detailVC.navbarTitle = _dataArr[indexPath.row];
    detailVC.imageTableViewStyle = indexPath.row;
    [self.navigationController pushViewController:detailVC animated:YES];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark - 懒加载
- (UITableView *)tableView {
    
    if (_tableView == nil) {
        
        UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        tableView.delegate = self;
        tableView.dataSource = self;
        
        _tableView = tableView;
        [self.view addSubview:_tableView];
    
        //注册cell
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellIdentifier];
        
    }
    return _tableView;
}

- (NSArray *)dataArr {

    if (_dataArr == nil) {
        _dataArr = @[
                     @"导航栏可透明,顶部图片可拉伸",
                     @"导航栏可透明,文字可伸展收起,顶部图片下拉无弹性"
                     ];
    }
    return _dataArr;
}


@end

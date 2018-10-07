//
//  NextViewController.m
//  Lists
//
//  Created by 方伟易 on 2018/9/28.
//  Copyright © 2018年 方伟易. All rights reserved.
//

#import "NextViewController.h"

@interface NextViewController ()
<UITableViewDataSource, UITableViewDelegate>

@property(nonatomic,strong) UITableView *tableview;

@end

@implementation NextViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (self.theTitle) {
        self.title = self.theTitle;
    }
    [self.view addSubview:self.tableview];
    self.automaticallyAdjustsScrollViewInsets = NO;
}


- (void)setUploadedFiles:(NSArray *)uploadedFiles {
    _uploadedFiles = uploadedFiles;
    [self.origionArray addObjectsFromArray:uploadedFiles];
    [self.tableview reloadData];
}

- (NSMutableArray *)origionArray {
    if (!_origionArray) {
        _origionArray = [NSMutableArray arrayWithArray:@[@"原有文件0",@"原有文件1",@"原有文件2",@"原有文件3",@"原有文件4",@"原有文件5",@"原有文件6",@"原有文件7",@"原有文件8",@"原有文件9"]];
    }
    return _origionArray;
}

- (UITableView *)tableview {
    if (!_tableview) {
        _tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.height - 64) style:UITableViewStylePlain];
        _tableview.dataSource = self;
        _tableview.delegate = self;
    }
    return _tableview;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.origionArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellID"];
    }
    cell.textLabel.text = self.origionArray[indexPath.row];
    return cell;
}

@end

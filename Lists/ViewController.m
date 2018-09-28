//
//  ViewController.m
//  Lists
//
//  Created by 方伟易 on 2018/9/25.
//  Copyright © 2018年 方伟易. All rights reserved.
//

#import "ViewController.h"

#import "EGShakeFileTableViewCell.h"
#import "EGDetailTableViewCell.h"

@interface ViewController ()<
UITableViewDelegate, UITableViewDataSource, EGDetailTableViewCellProtocal>

@property (weak, nonatomic) IBOutlet UITableView *fileList;

@property (weak, nonatomic) IBOutlet UITableView *detailList;

@property(nonatomic,copy) NSArray *files;

@property(nonatomic,copy) NSArray *details;

@property(nonatomic,copy) NSMutableArray<NSIndexPath *> *selectedList;

@property(nonatomic,copy) NSMutableArray<NSString *> *fileFocusArray;

@property(nonatomic,strong) UIView *maskView;

@property(nonatomic,assign) CGPoint currentFocusPoint;

@property(nonatomic,weak) EGShakeFileTableViewCell *currentFocusCell;

@property(nonatomic,strong) UIImageView *filesSelectedImageView;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.navigationItem.leftBarButtonItem  = [[UIBarButtonItem alloc] initWithTitle:@"打印" style:UIBarButtonItemStylePlain target:self action:@selector(printDetail)];
    self.navigationItem.rightBarButtonItem  = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(dragSwitch:)];
    
    self.fileList.bounces = NO;
    self.fileList.allowsMultipleSelectionDuringEditing = YES;
}

- (void)printDetail {
}

- (void)dragSwitch:(id)sender {
    self.detailList.editing = !self.detailList.editing;
    if (!self.detailList.editing) {
        self.selectedList = nil;
    }
}

- (void)setCurrentFocusCell:(EGShakeFileTableViewCell *)currentFocusCell {
    if (currentFocusCell && ![currentFocusCell isEqual:_currentFocusCell]) {
        _currentFocusCell = currentFocusCell;
        [self.currentFocusCell isFoucusedOn];
    }
}

#pragma mark - tableview delegate / datasource

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!tableView.editing) {
        return;
    }
    
    if ([tableView isEqual:self.detailList]) {
         if ([self.selectedList containsObject:indexPath]) {
            [self.selectedList removeObject:indexPath];
        }else {        
            [self.selectedList addObject:indexPath];
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([tableView isEqual:self.fileList]) {
        return 100;
    }else {
        return  60;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([tableView isEqual:self.fileList]) {
        return self.files.count;
    }else {
        return  self.details.count;
    }
}

- (__kindof UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([tableView isEqual:self.fileList]) {
        EGShakeFileTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"fileCellID"];
        if (!cell) {
            cell = [[EGShakeFileTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"fileCellID"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
         }
        cell.textLabel.text = self.files[indexPath.row];
        return  cell;
    }else {
        EGDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"fileDetailCellID"];
        if (!cell) {
            cell = [[EGDetailTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"fileDetailCellID"];
            cell.selectDelegate = self;
            cell.containerMask = self.maskView;
            cell.backgroundColor = [UIColor greenColor];
        }
        cell.textLabel.text = self.details[indexPath.row];
        return  cell;
    }
}

#pragma mark - private

- (void)addImageMask {
    [self.view addSubview:self.maskView];
}

- (void)startShakeAction {
    [self.fileList.visibleCells enumerateObjectsUsingBlock:^(EGShakeFileTableViewCell * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj startShakeAction];
    }];
}

- (void)stopShakeAction {
    [self.fileList.visibleCells enumerateObjectsUsingBlock:^(EGShakeFileTableViewCell * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj finishShakeAction];
    }];
}

#pragma mark - cell selected

- (void)tableViewDidSelectedCell:(EGDetailTableViewCell *)cell {
    [self addImageMask];
    [self startShakeAction];
    
    self.filesSelectedImageView.center = CGPointMake( cell.center.x - 250,  cell.center.y);
    [self.maskView addSubview:self.filesSelectedImageView];
}

- (void)tableViewDidDeselectedCell:(EGDetailTableViewCell *)cell {
    [self.selectedList enumerateObjectsUsingBlock:^(__kindof NSIndexPath * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        EGDetailTableViewCell *cell = [self.detailList cellForRowAtIndexPath:obj];
        if ([self.detailList.visibleCells containsObject:cell]) {
            cell.alpha = 1;
        }
    }];
    
    [self.maskView removeFromSuperview];
    [self stopShakeAction];
}

- (void)cellsDidDragCell:(EGDetailTableViewCell *)cell toPoint:(CGPoint)point  {
    
    [self.selectedList enumerateObjectsUsingBlock:^(NSIndexPath * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        EGDetailTableViewCell *cell = [self.detailList cellForRowAtIndexPath:obj];
        if ([self.detailList.visibleCells containsObject:cell]) {
            cell.alpha = 0;
        }
    }];
    
    //可能的目的文件夹
    [self.fileList.visibleCells enumerateObjectsUsingBlock:^(__kindof EGShakeFileTableViewCell * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if(CGRectContainsPoint(obj.frame, point)) {
            NSLog(@"EGShakeFileTableViewCell %@", obj.textLabel.text);
            self.currentFocusPoint = obj.center;
            self.currentFocusCell = obj;
        }else {
            [self.currentFocusCell isFoucusedOff];
            self.currentFocusCell = nil;
        }
    }];
    
    self.filesSelectedImageView.center = CGPointMake(point.x, point.y);
}

#pragma mark - lazy

- (NSArray *)files {
    return @[@"文件夹1", @"文件夹2", @"文件夹3", @"文件夹4"];
}

- (NSArray *)details {
    return @[@"文件1", @"文件2", @"文件3", @"文件4", @"文件5", @"文件6", @"文件7", @"文件8", @"文件9", @"文件10",
             @"文件11", @"文件12", @"文件13", @"文件14", @"文件15", @"文件16", @"文件17", @"文件18", @"文件19", @"文件20",
             @"文件21", @"文件22", @"文件23", @"文件24", @"文件25", @"文件26", @"文件27", @"文件28", @"文件29", @"文件30",
             @"文件31", @"文件32", @"文件33", @"文件34", @"文件35", @"文件36", @"文件37", @"文件38", @"文件39", @"文件40"];
}

- (NSMutableArray *)selectedList {
    if (!_selectedList) {
        _selectedList = [NSMutableArray array];
    }
    return _selectedList;
}

- (NSMutableArray *)fileFocusArray {
    NSMutableArray *foucusArray = [NSMutableArray array];
    [self.fileList.visibleCells enumerateObjectsUsingBlock:^(__kindof UITableViewCell * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [foucusArray addObject:NSStringFromCGPoint(obj.center)];
    }];
    
    return foucusArray;
}

- (UIView *)maskView {
    if (!_maskView) {
        _maskView = [[UIView alloc]initWithFrame:CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
        _maskView.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.3];
        _maskView.layer.masksToBounds = NO;
    }
    return _maskView;
}

- (UIImageView *)filesSelectedImageView {
    if (!_filesSelectedImageView) {
        _filesSelectedImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"selectedFiles"]];
        _filesSelectedImageView.backgroundColor = [UIColor redColor];
      }
    return _filesSelectedImageView;
}

@end

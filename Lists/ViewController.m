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

@property(nonatomic,copy) NSMutableArray<NSDictionary *> *animationImageFrameArray;

@property(nonatomic,copy) NSMutableArray<UIImageView *> *animationImages;

@property(nonatomic,copy) NSMutableArray<NSString *> *fileFocusArray;

@property(nonatomic,strong) UIView *maskScroll;

@property(nonatomic,assign) CGPoint currentFocusPoint;

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
        self.animationImageFrameArray = nil;
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
            cell.backgroundColor = [UIColor orangeColor];
         }
        cell.textLabel.text = self.files[indexPath.row];
        return  cell;
    }else {
        EGDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"fileDetailCellID"];
        if (!cell) {
            cell = [[EGDetailTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"fileDetailCellID"];
            cell.backgroundColor = [UIColor greenColor];
            cell.selectDelegate = self;
            cell.containerMask = self.maskScroll;
        }
        cell.textLabel.text = self.details[indexPath.row];
        return  cell;
    }
}

#pragma mark - private

- (UIImage *) screenShotView:(__kindof UIView *)view{
    UIImage *imageRet = [[UIImage alloc]init];
    UIGraphicsBeginImageContextWithOptions(view.frame.size, false, 0.0);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    imageRet = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return imageRet;
}

- (void)addImageMask {
    if (self.animationImageFrameArray.count == 0) {
        return;
    }
    
    
    
    NSLog(@"self.animationImages-%lu-%@" ,(unsigned long)self.animationImages.count, self.animationImages);
    NSLog(@"self.animationImageFrameArray-%lu-%@" ,(unsigned long)self.animationImageFrameArray.count, self.animationImageFrameArray);

    dispatch_async(dispatch_get_main_queue(), ^{
        [self.view addSubview:self.maskScroll];
        [self.maskScroll becomeFirstResponder];
        [self.animationImageFrameArray enumerateObjectsUsingBlock:^(NSDictionary *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            UIImageView *imageView = [[UIImageView alloc]initWithImage:[obj valueForKey:@"image"]];
            
            [self.animationImages addObject:imageView];
            
            imageView.frame = CGRectMake(self.detailList.frame.origin.x, CGRectFromString([obj valueForKey:@"frame"]).origin.y - 64, CGRectFromString([obj valueForKey:@"frame"]).size.width, CGRectFromString([obj valueForKey:@"frame"]).size.height);
            [self.maskScroll addSubview:imageView];
        }];
    });
}

- (void)startShakeAction {
    [self.fileList.visibleCells enumerateObjectsUsingBlock:^(EGShakeFileTableViewCell * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj startShakeAction];
    }];
    NSLog(@"文件夹list开始抖动");
}

- (void)stopShakeAction {
    [self.fileList.visibleCells enumerateObjectsUsingBlock:^(EGShakeFileTableViewCell * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj finishShakeAction];
    }];
    self.animationImageFrameArray = nil;
    NSLog(@"文件夹list停止抖动");
}

#pragma mark - cell selected

- (void)tableViewDidSelectedCells:(EGDetailTableViewCell *)cell {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
         [self addImageMask];
    });
    
    [self startShakeAction];
}

- (void)tableViewDidDeselectedCells:(EGDetailTableViewCell *)cell {
    [self.maskScroll.subviews enumerateObjectsUsingBlock:^(__kindof UIImageView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];
    
    [self.selectedList enumerateObjectsUsingBlock:^(__kindof NSIndexPath * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        EGDetailTableViewCell *cell = [self.detailList cellForRowAtIndexPath:obj];
        if ([self.detailList.visibleCells containsObject:cell]) {
            cell.alpha = 1;
        }
    }];
    
    [self.animationImages removeAllObjects];
    [self.maskScroll removeFromSuperview];
    [self.animationImageFrameArray removeAllObjects];
    [self stopShakeAction];
}

- (void)cellsDidDragCell:(EGDetailTableViewCell *)cell toPoint:(CGPoint)point  {
    [self.selectedList enumerateObjectsUsingBlock:^(NSIndexPath * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        EGDetailTableViewCell *cell = [self.detailList cellForRowAtIndexPath:obj];
        if ([self.detailList.visibleCells containsObject:cell]) {
            cell.alpha = 0;
        }
    }];
    
    [self.fileList.visibleCells enumerateObjectsUsingBlock:^(__kindof EGShakeFileTableViewCell * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if(CGRectContainsPoint(obj.frame, point)) {
            self.currentFocusPoint = obj.center;
        };
     }];
    
    [self.animationImages enumerateObjectsUsingBlock:^(UIImageView *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.frame = CGRectMake(point.x, obj.frame.origin.y, obj.frame.size.width, obj.frame.size.height);
    }];
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

- (NSMutableArray *)animationImageFrameArray {
    NSMutableArray *frames = [NSMutableArray array];
    [self.selectedList enumerateObjectsUsingBlock:^(NSIndexPath *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        EGDetailTableViewCell *cell = [self.detailList cellForRowAtIndexPath:obj];
        if ([self.detailList.visibleCells containsObject:cell]) {
            [frames addObject:@{@"frame" : NSStringFromCGRect([self.detailList convertRect:cell.frame toView:self.view]),
                                @"image" : [self screenShotView:cell]
                                }];
        }
    }];
    return frames;
}

- (NSMutableArray *)animationImages {
    if (!_animationImages) {
        _animationImages = [NSMutableArray array];
    }
    return _animationImages;
}

- (NSMutableArray *)fileFocusArray {
    NSMutableArray *foucusArray = [NSMutableArray array];
    [self.fileList.visibleCells enumerateObjectsUsingBlock:^(__kindof UITableViewCell * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [foucusArray addObject:NSStringFromCGPoint(obj.center)];
    }];
    
    return foucusArray;
}

- (UIView *)maskScroll {
    if (!_maskScroll) {
        _maskScroll = [[UIView alloc]initWithFrame:CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
        _maskScroll.backgroundColor = [UIColor colorWithWhite:0.1 alpha:0];
        _maskScroll.layer.masksToBounds = NO;
    }
    return _maskScroll;
}

@end

//
//  ViewController.m
//  Lists
//
//  Created by 方伟易 on 2018/9/25.
//  Copyright © 2018年 方伟易. All rights reserved.
//

#import "ViewController.h"
#import "EGDetailTableViewCell.h"

@interface ViewController ()<
UITableViewDelegate, UITableViewDataSource, EGDetailTableViewCellProtocal>

@property (weak, nonatomic) IBOutlet UITableView *fileList;

@property (weak, nonatomic) IBOutlet UITableView *detailList;

@property(nonatomic,copy) NSArray *files;

@property(nonatomic,copy) NSArray *details;

@property(nonatomic,copy) NSMutableArray *selectedList;

@property(nonatomic,copy) NSMutableArray *animationImageFrameArray;

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

- (void)setCurrentFocusPoint:(CGPoint)currentFocusPoint {
    _currentFocusPoint = currentFocusPoint;
    NSLog(@"当前的焦点位置为 %@", NSStringFromCGPoint(currentFocusPoint));
}

#pragma mark - tableview delegate / datasource

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!tableView.editing) {
        return;
    }
    
    if ([tableView isEqual:self.detailList]) {
         if ([self.selectedList containsObject:[tableView cellForRowAtIndexPath:indexPath]]) {
            [self.selectedList removeObject:[tableView cellForRowAtIndexPath:indexPath]];
        }else {        
            [self.selectedList addObject:[tableView cellForRowAtIndexPath:indexPath]];
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([tableView isEqual:self.fileList]) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"fileCellID"];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"fileCellID"];
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

- (UIImage *) screenShotView:(UIView *)view{
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
    NSLog(@"文件夹list开始抖动");
}

- (void)stopShakeAction {
    NSLog(@"文件夹list停止抖动");
}

#pragma mark - cell selected

- (void)tableViewDidSelectedCells:(EGDetailTableViewCell *)cell {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [self.selectedList enumerateObjectsUsingBlock:^(EGDetailTableViewCell *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([self.detailList.visibleCells containsObject:obj]) {
                [self.animationImageFrameArray addObject:@{
                                                 @"frame" : NSStringFromCGRect([self.detailList convertRect:obj.frame toView:self.view]),
                                                 @"image" : [self screenShotView:obj]
                                                 }];
            }
        }];
        [self addImageMask];
    });
    
    [self startShakeAction];
}

- (void)tableViewDidDeselectedCells:(EGDetailTableViewCell *)cell {
    [self.maskScroll.subviews enumerateObjectsUsingBlock:^(__kindof UIImageView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];
    
    [self.selectedList enumerateObjectsUsingBlock:^(__kindof UITableViewCell * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.alpha = 1;
    }];
    
    [self.animationImages removeAllObjects];
    [self.maskScroll removeFromSuperview];
    [self.animationImageFrameArray removeAllObjects];
    [self stopShakeAction];
}

- (void)cellsDidDragCell:(EGDetailTableViewCell *)cell toPoint:(CGPoint)point  {
    double fileCenterX = 0.5 * ([UIScreen mainScreen].bounds.size.width - 250);
    CGFloat alpha = (point.x - ([UIScreen mainScreen].bounds.size.width - 250)) / fileCenterX;
    
    [self.selectedList enumerateObjectsUsingBlock:^(__kindof UITableViewCell * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.alpha = alpha;
    }];
    
    __block CGPoint focus;
    __block CGFloat lenght;
    __block CGFloat width;
    __block CGFloat distance;
    __block CGPoint ref;
    [self.fileFocusArray enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        focus  = CGPointFromString(obj);
        lenght = fabs(focus.x - point.x);
        width = fabs(focus.y - point.y);
        if (distance < sqrt(lenght*lenght + width*lenght) ) {
//            self.currentFocusPoint = focus;
            ref = focus;
            distance = sqrt(lenght*lenght + width*lenght);
        }
    }];
    
    [self.animationImages enumerateObjectsUsingBlock:^(UIImageView *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.frame = CGRectMake(point.x, (obj.frame.origin.y - ref.y) , obj.frame.size.width, obj.frame.size.height);
    }];
}


#pragma mark - lazy

- (NSArray *)files {
    return @[@"文件夹1", @"文件夹2", @"文件夹3", @"文件夹4"];
}

- (NSArray *)details {
    return @[@"文件1", @"文件2", @"文件3", @"文件4", @"文件5", @"文件6", @"文件7", @"文件8", @"文件9", @"文件10", @"文件11", @"文件12", @"文件13", @"文件14", @"文件15", @"文件1", @"文件2", @"文件3", @"文件4", @"文件5", @"文件6", @"文件7", @"文件8", @"文件9", @"文件10", @"文件11", @"文件12", @"文件13", @"文件14", @"文件15"];
}

- (NSMutableArray *)selectedList {
    if (!_selectedList) {
        _selectedList = [NSMutableArray array];
    }
    return _selectedList;
}

- (NSMutableArray *)animationImageFrameArray {
    if (!_animationImageFrameArray) {
        _animationImageFrameArray = [NSMutableArray array];
    }
    return _animationImageFrameArray;
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

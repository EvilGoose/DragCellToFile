//
//  ViewController.m
//  Lists
//
//  Created by 方伟易 on 2018/9/25.
//  Copyright © 2018年 方伟易. All rights reserved.
//

#import "ViewController.h"
#import "EGDetailTableViewCell.h"
#import "EGTableView.h"

@interface ViewController ()<
UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *fileList;

@property (weak, nonatomic) IBOutlet EGTableView *detailList;

@property(nonatomic,copy) NSArray *files;

@property(nonatomic,copy) NSArray *details;

@property(nonatomic,copy) NSMutableArray *selectedList;

@property(nonatomic,copy) NSMutableArray *animationImage;

@property(nonatomic,strong) UIScrollView *maskScroll;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.navigationItem.leftBarButtonItem  = [[UIBarButtonItem alloc] initWithTitle:@"打印" style:UIBarButtonItemStylePlain target:self action:@selector(printDetail)];
    self.navigationItem.rightBarButtonItem  = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(dragSwitch:)];
    self.fileList.bounces = NO;
  
    
    self.detailList.pressed = ^(BOOL mark, NSArray * _Nonnull visibleCells) {
        if (!mark){
            [self.maskScroll.subviews enumerateObjectsUsingBlock:^(__kindof UIImageView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [obj removeFromSuperview];
            }];
            [self.maskScroll removeFromSuperview];
            [self.animationImage removeAllObjects];
            return;
        }
        
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [self.selectedList enumerateObjectsUsingBlock:^(EGDetailTableViewCell *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([visibleCells containsObject:obj]) {
                      [self.animationImage addObject:@{
                                      @"frame" : NSStringFromCGRect([self.detailList convertRect:obj.frame toView:self.view]),
                                      @"image" : [self screenShotView:obj]
                                      }];
                }
            }];
        
            [self addImageMask];
        });
        
    };
}

- (UIImage *) screenShotView:(UIView *)view{
    UIImage *imageRet = [[UIImage alloc]init];
    UIGraphicsBeginImageContextWithOptions(view.frame.size, false, 0.0);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    imageRet = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return imageRet;
}

- (void)addImageMask {
    if (self.animationImage.count == 0) {
        return;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.view addSubview:self.maskScroll];
        [self.animationImage enumerateObjectsUsingBlock:^(NSDictionary *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            UIImageView *imageView = [[UIImageView alloc]initWithImage:[obj valueForKey:@"image"]];
            imageView.frame = CGRectMake(self.detailList.frame.origin.x, CGRectFromString([obj valueForKey:@"frame"]).origin.y - 64, CGRectFromString([obj valueForKey:@"frame"]).size.width, CGRectFromString([obj valueForKey:@"frame"]).size.height);
            [self.maskScroll addSubview:imageView];
        }];
    });
}

- (void)printDetail {
}

- (void)dragSwitch:(id)sender {
    self.detailList.editing = !self.detailList.editing;
    if (!self.detailList.editing) {
        self.selectedList = nil;
        self.animationImage = nil;
    }
}

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
            cell.backgroundColor = [UIColor grayColor];
        }
        cell.textLabel.text = self.details[indexPath.row];
        return  cell;
    }
    
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

- (NSMutableArray *)animationImage {
    if (!_animationImage) {
        _animationImage = [NSMutableArray array];
    }
    return _animationImage;
}

- (UIScrollView *)maskScroll {
    if (!_maskScroll) {
        _maskScroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
        _maskScroll.backgroundColor = [UIColor colorWithWhite:0.1 alpha:0.5];
    }
    return _maskScroll;
}

@end

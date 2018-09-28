//
//  EGDetailTableViewCell.h
//  Lists
//
//  Created by 方伟易 on 2018/9/25.
//  Copyright © 2018年 方伟易. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class EGDetailTableViewCell;

@protocol EGDetailTableViewCellProtocal <NSObject>

- (void)tableViewDidSelectedCell:(EGDetailTableViewCell *)cell;

- (void)tableViewDidDeselectedCell:(EGDetailTableViewCell *)cell;

- (void)cellsDidDragCell:(EGDetailTableViewCell *)cell toPoint:(CGPoint)point;

@end

@interface EGDetailTableViewCell : UITableViewCell

@property(nonatomic,weak) id<EGDetailTableViewCellProtocal> selectDelegate;

@property(nonatomic,weak) __kindof UIView *containerMask;

@end

NS_ASSUME_NONNULL_END

//
//  EGShakeFileTableViewCell.h
//  Lists
//
//  Created by 方伟易 on 2018/9/27.
//  Copyright © 2018年 方伟易. All rights reserved.
//

#import <UIKit/UIKit.h>
@class NextViewController;
NS_ASSUME_NONNULL_BEGIN

@interface EGShakeFileTableViewCell : UITableViewCell

@property(nonatomic,strong) NextViewController *nextController;

- (void)startShakeAction;

- (void)finishShakeAction;

- (void)isFoucusedOn;

- (void)isFoucusedOff;

- (void)uploadFiles:(NSArray *)files;

@end

NS_ASSUME_NONNULL_END

//
//  EGShakeFileTableViewCell.h
//  Lists
//
//  Created by 方伟易 on 2018/9/27.
//  Copyright © 2018年 方伟易. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface EGShakeFileTableViewCell : UITableViewCell

- (void)startShakeAction;

- (void)finishShakeAction;

- (void)isFoucusedOn;

- (void)isFoucusedOff;

@end

NS_ASSUME_NONNULL_END

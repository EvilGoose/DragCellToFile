//
//  EGTableView.h
//  Lists
//
//  Created by 方伟易 on 2018/9/25.
//  Copyright © 2018年 方伟易. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^longPressedCallBack)(BOOL mark,NSArray *visibleCell);

@interface EGTableView : UITableView

@property(nonatomic,copy) longPressedCallBack pressed;


@end

NS_ASSUME_NONNULL_END

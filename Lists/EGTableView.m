//
//  EGTableView.m
//  Lists
//
//  Created by 方伟易 on 2018/9/25.
//  Copyright © 2018年 方伟易. All rights reserved.
//

#import "EGTableView.h"

@interface EGTableView()<
UIGestureRecognizerDelegate>

@end

@implementation EGTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    if (self = [super initWithFrame:frame style:style]) {
        self.multipleTouchEnabled = YES;
        UILongPressGestureRecognizer *press = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(pressDetail:)];
        press.minimumPressDuration = 1;
        [self addGestureRecognizer:press];
     }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    if (self = [super initWithCoder:coder]) {
        self.multipleTouchEnabled = YES;
        UILongPressGestureRecognizer *press = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(pressDetail:)];
        press.minimumPressDuration = 2;
        press.delegate = self;
        [self addGestureRecognizer:press];
    }
    return self;
}

- (void)pressDetail:(UIPanGestureRecognizer *)pan {
    if (!self.editing) {
        return;
    }
    
    if (!self.pressed) {
        return;
    }
    
    switch (pan.state) {
        case UIGestureRecognizerStateBegan:
             self.pressed(YES ,[self visibleCells]);
            
            break;
 
        case  UIGestureRecognizerStateChanged:
 
            break;

        case  UIGestureRecognizerStateEnded:
            self.pressed(NO ,@[]);
            break;

        case  UIGestureRecognizerStateCancelled:
            self.pressed(NO ,@[]);
            break;

        case  UIGestureRecognizerStateFailed:
            self.pressed(NO ,@[]);
            break;

        default:
            break;
    }
    
  
}

@end

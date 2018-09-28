//
//  EGDetailTableViewCell.m
//  Lists
//
//  Created by 方伟易 on 2018/9/25.
//  Copyright © 2018年 方伟易. All rights reserved.
//

#import "EGDetailTableViewCell.h"

@interface EGDetailTableViewCell()<UIGestureRecognizerDelegate>

@property(nonatomic,assign) CGPoint originPoint;

@end

@implementation EGDetailTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:NO];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        UILongPressGestureRecognizer *press = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(pressDetail:)];
        press.minimumPressDuration = 1;
        press.delegate = self;
        [self addGestureRecognizer:press];
    }
    return self;
}

- (void)pressDetail:(UILongPressGestureRecognizer *)press {
    if (!self.editing) {
        return;
    }
    
    switch (press.state) {
        case UIGestureRecognizerStateBegan:
            if ([self.selectDelegate respondsToSelector:@selector(tableViewDidSelectedCell:)]) {
                [self.selectDelegate tableViewDidSelectedCell:self];
                self.originPoint = [press locationInView:self];
            }
            break;
            
        case  UIGestureRecognizerStateEnded:
            if ([self.selectDelegate respondsToSelector:@selector(tableViewDidDeselectedCell:)]) {
                [self.selectDelegate tableViewDidDeselectedCell:self];
            }
            break;
            
        case  UIGestureRecognizerStateCancelled:
            if ([self.selectDelegate respondsToSelector:@selector(tableViewDidDeselectedCell:)]) {
                [self.selectDelegate tableViewDidDeselectedCell:self];
            }
            break;

        case  UIGestureRecognizerStateChanged:
            if ([self.selectDelegate respondsToSelector:@selector(cellsDidDragCell:toPoint:)]) {
                 if (!self.containerMask) return; 
                 [self.selectDelegate cellsDidDragCell:self toPoint:CGPointMake([press locationInView:self.containerMask].x,[press locationInView:self.containerMask].y)];
             }
             break;
            
        case  UIGestureRecognizerStateFailed:
            if ([self.selectDelegate respondsToSelector:@selector(tableViewDidDeselectedCell:)]) {
                [self.selectDelegate tableViewDidDeselectedCell:self];
            }
            break;
        default:
            break;
    }
}

@end

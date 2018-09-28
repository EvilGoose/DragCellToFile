//
//  EGShakeFileTableViewCell.m
//  Lists
//
//  Created by 方伟易 on 2018/9/27.
//  Copyright © 2018年 方伟易. All rights reserved.
//

#import "EGShakeFileTableViewCell.h"

#define angelToRandian(x)  ((x)/180.0*M_PI)

@implementation EGShakeFileTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor orangeColor];
    }
    return self;
}

- (void)startShakeAction {
    CAKeyframeAnimation* anim=[CAKeyframeAnimation animation];
    anim.keyPath=@"transform.rotation";
    anim.values=@[@(angelToRandian(-4)),@(angelToRandian(4)),@(angelToRandian(-4))];
    anim.repeatCount=MAXFLOAT;
    anim.duration=0.2;
    [self.layer addAnimation:anim forKey:@"shake"];
 }

- (void)finishShakeAction {
    [self.layer removeAllAnimations];
}

- (void)isFoucusedOn {
    self.backgroundColor = [UIColor redColor];
    NSLog(@"Focused on me %@", self);
}

- (void)isFoucusedOff {
    self.backgroundColor = [UIColor orangeColor];
    NSLog(@"Do not focused on me %@", self);
}

@end

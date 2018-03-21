//
//  GameButton.m
//  Tetris
//
//  Created by 张雨 on 16/1/21.
//  Copyright © 2016年 张雨. All rights reserved.
//

#import "GameButton.h"

@implementation GameButton

-(BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
//    CGRect bounds = self.bounds;
//    //若原热区小于44x44，则放大热区，否则保持原大小不变
//    CGFloat widthDelta  = MAX(120.0 - bounds.size.width, 0);
////    CGFloat heightDelta = MAX(120.0 - bounds.size.height, 0);
//    bounds = CGRectInset(bounds, -0.5 * widthDelta, /*-0.5 * heightDelta*/0);
//    return CGRectContainsPoint(bounds, point);
    return [super pointInside:point withEvent:event];
}
@end

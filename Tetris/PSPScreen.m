//
//  PSPScreen.m
//  PSP
//
//  Created by 张雨 on 15/5/29.
//  Copyright (c) 2015年 张雨. All rights reserved.
//

#import "PSPScreen.h"
#import "PSPGameTetris.h"
@implementation PSPScreen
+(id)sharedScreen
{
    static id _s;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken,^{
        _s=[[[self class] alloc] init];
    });
    return _s;
}
-(void)drawCellWithContext:(CGContextRef)context WithFrame:(CGRect)frame beLighten:(BOOL)lighten
{
    NSUInteger cellW= frame.size.width   ;
    NSUInteger cellH= frame.size.height  ;
    CGContextSetLineWidth  (context, 2);
    [ lighten?SCR_LIGHTEN_CLR:SCR_UNLIGHTEN_CLR setStroke];
    CGRect out_rect   = CGRectMake(frame.origin.x+1, frame.origin.y+1, cellW-3, cellH-3);
    CGContextStrokeRect(context, out_rect);
    CGRect inner_rect = CGRectMake(frame.origin.x+3, frame.origin.y+3, frame.size.width-7, frame.size.height-7);
    [lighten?SCR_LIGHTEN_CLR:SCR_UNLIGHTEN_CLR setFill];
    CGContextFillRect(context, inner_rect);
}
-(void)drawCount:(unsigned int)count AtPoint:(CGPoint)point
{
    
    unsigned int c0,c1,c2,c3,c4,c5;
    bool         b0,b1,b2,b3,b4,b5;
    b0 = b1 = b2 = b3 = b4 = b5 =0;
    c0    = count / 100000;
    count = count - c0 *100000;
    c1    = count /10000;
    count = count - c1 *10000;
    c2    = count /1000;
    count = count - c2 * 1000;
    c3    = count /100;
    count = count - c3 * 100;
    c4    = count /10;
    count = count - c4 *10;
    c5    = count;
    
    b0    = c0 > 0;
    b1    = b0 || c1 > 0;
    b2    = b1 || c2 > 0;
    b3    = b2 || c3 > 0;
    b4    = b3 || c4 > 0;
    b5    = 1;
    UIFont * digital_font = [UIFont fontWithName:@"LETSGODIGITAL-REGULAR" size:20];
    if(b0)
    {
        [[NSString stringWithFormat:@"%d",c0] drawAtPoint:CGPointMake(point.x,point.y) withAttributes:@{NSFontAttributeName:digital_font,NSForegroundColorAttributeName:SCR_LIGHTEN_CLR}];
    }
    if(b1)
    {
        [[NSString stringWithFormat:@"%d",c1] drawAtPoint:CGPointMake(point.x+10,point.y) withAttributes:@{NSFontAttributeName:digital_font,NSForegroundColorAttributeName:SCR_LIGHTEN_CLR}];
    }
    if(b2)
    {
        [[NSString stringWithFormat:@"%d",c2] drawAtPoint:CGPointMake(point.x+20,point.y) withAttributes:@{NSFontAttributeName:digital_font,NSForegroundColorAttributeName:SCR_LIGHTEN_CLR}];
    }
    if(b3)
    {
        [[NSString stringWithFormat:@"%d",c3] drawAtPoint:CGPointMake(point.x+30,point.y) withAttributes:@{NSFontAttributeName:digital_font,NSForegroundColorAttributeName:SCR_LIGHTEN_CLR}];
    }
    if(b4)
    {
        [[NSString stringWithFormat:@"%d",c4] drawAtPoint:CGPointMake(point.x+40,point.y) withAttributes:@{NSFontAttributeName:digital_font,NSForegroundColorAttributeName:SCR_LIGHTEN_CLR}];
    }
    if(b5)
    {
        [[NSString stringWithFormat:@"%d",c5] drawAtPoint:CGPointMake(point.x+50,point.y) withAttributes:@{NSFontAttributeName:digital_font,NSForegroundColorAttributeName:SCR_LIGHTEN_CLR}];
    }
}
-(void)drawRect:(CGRect)rect
{
    // draw background
    CGContextRef  context =UIGraphicsGetCurrentContext();
    float offset_x = 5;
    float offset_y = 5;
    float cell_width = 14;
    float gap        = 3;
    //draw frame
    CGContextBeginPath     (context);
    CGContextMoveToPoint   (context,offset_x - gap -0.75, offset_y - gap);
    CGContextAddLineToPoint(context,offset_x + cell_width * 10 + gap, offset_y-gap);
    CGContextAddLineToPoint(context,offset_x + cell_width * 10 + gap, offset_y+ 20 *cell_width + gap);
    CGContextAddLineToPoint(context,offset_x - gap , offset_y + 20 * cell_width + gap);
    CGContextAddLineToPoint(context,offset_x - gap , offset_y - gap - 0.75);
    CGContextSetLineWidth  (context, 1.5);
    [[UIColor blackColor] setStroke];
    CGContextDrawPath      (context, kCGPathStroke);
    //draw frame
    
    //draw game info
    float left     = 165;
    float top      = 5;
    UIFont * text_font    = [UIFont boldSystemFontOfSize:12];
    UIFont * digital_font = [UIFont fontWithName:@"LETSGODIGITAL-REGULAR" size:20];
    [@"HI-SCORE" drawAtPoint:CGPointMake(left, top) withAttributes:@{NSFontAttributeName:text_font,NSForegroundColorAttributeName:SCR_LIGHTEN_CLR}];
    [@"888888" drawAtPoint:CGPointMake  (left, top +20) withAttributes:@{NSFontAttributeName:digital_font,NSForegroundColorAttributeName:SCR_UNLIGHTEN_CLR}];
    [self drawCount:[_dataSource highScore] AtPoint:CGPointMake(left, top +20)];
    
    
    [@"SCORE" drawAtPoint:CGPointMake   (left, top +40) withAttributes:@{NSFontAttributeName:text_font,NSForegroundColorAttributeName:SCR_LIGHTEN_CLR}];
    [@"888888" drawAtPoint:CGPointMake  (left, top +60) withAttributes:@{NSFontAttributeName:digital_font,NSForegroundColorAttributeName:SCR_UNLIGHTEN_CLR}];
    [self drawCount:[_dataSource score] AtPoint:CGPointMake(left, top +60)];
    
    [@"LINES" drawAtPoint:CGPointMake   (left, top +80) withAttributes:@{NSFontAttributeName:text_font,NSForegroundColorAttributeName:SCR_LIGHTEN_CLR}];
    [@"888888" drawAtPoint:CGPointMake  (left, top +100) withAttributes:@{NSFontAttributeName:digital_font,NSForegroundColorAttributeName:SCR_UNLIGHTEN_CLR}];
    [self drawCount:[_dataSource line] AtPoint:CGPointMake(left, top +100)];
    
    [@"LEVEL" drawAtPoint:CGPointMake   (left, top +120) withAttributes:@{NSFontAttributeName:text_font,NSForegroundColorAttributeName:SCR_LIGHTEN_CLR}];
     [@"888888" drawAtPoint:CGPointMake  (left, top +140) withAttributes:@{NSFontAttributeName:digital_font,NSForegroundColorAttributeName:SCR_UNLIGHTEN_CLR}];
    [self drawCount:[_dataSource level] AtPoint:CGPointMake(left, top +140)];
    
    [@"NEXT" drawAtPoint:CGPointMake    (left, top +160) withAttributes:@{NSFontAttributeName:text_font,NSForegroundColorAttributeName:SCR_LIGHTEN_CLR}];
    //draw game info
    //draw next
    struct NextScreenData nextData = [_dataSource nextForShow];
    float next_x = left;
    float next_y = top+180;
    for (int row =0 ;row <2 ;row++)
    {
        for(int line =0;line <4;line++)
        {
            [self drawCellWithContext:context WithFrame:CGRectMake(next_x +line * cell_width, next_y + row * cell_width, cell_width, cell_width) beLighten:nextData.matrix[row][line]];
        }
    }
    //draw next
    //draw matrix
    struct ScreenData data = [_dataSource dataForShow];
    for(NSUInteger m =0;m < 20;m++)
    {
        for(NSUInteger n=0;n<10; n++)
        {
            [self drawCellWithContext:context WithFrame:CGRectMake(n*cell_width+offset_x, m*cell_width+offset_y,cell_width, cell_width) beLighten:data.matrix[m][n]];
        }
    }
    //draw matrix
    //draw game state
    [@"G-STATE" drawAtPoint:CGPointMake    (left, top +220) withAttributes:@{NSFontAttributeName:text_font,NSForegroundColorAttributeName:SCR_LIGHTEN_CLR}];
    [SCR_LIGHTEN_CLR setFill];
    unsigned int stateIconW = 10;
    if([[PSPGameTetris sharedInstance] gameState] == STOP)
    {
        CGContextFillRect(context, CGRectMake(left,top+240, stateIconW, stateIconW));
    }
    else if([[PSPGameTetris sharedInstance] gameState] == STARTED)
    {
        CGContextMoveToPoint   (context, left, top + 240);
        CGContextAddLineToPoint(context, left+stateIconW, top + 240+ (stateIconW>>1) );
        CGContextAddLineToPoint(context, left, top + 240+ stateIconW);
        CGContextAddLineToPoint(context, left, 240);
        CGContextFillPath      (context);
    }
    else
    {
        CGContextFillRect(context, CGRectMake(left    ,top+240, 4, stateIconW));
        CGContextFillRect(context, CGRectMake(left + 6,top+240, 4, stateIconW));
    }
    //draw game state
}
@end

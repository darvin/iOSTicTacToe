//
//  BoardView.m
//  TicTacToeMinimax
//
//  Created by Sergey Klimov on 11/13/14.
//  Copyright (c) 2014 Sergey Klimov. All rights reserved.
//

#import "BoardView.h"

@implementation BoardView {
    TTMBoard *_boardCopy;
}

- (void)drawRect:(CGRect)rect {
    CGSize size = self.frame.size;
    CGFloat sideX = size.width/(CGFloat)_boardCopy.size.x;
    CGFloat sideY = size.height/(CGFloat)_boardCopy.size.y;
    
    CGFloat insetX = sideX /4.0;
    CGFloat insetY = sideY /4.0;
    CGFloat lineWidth = sideX/300.0;
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    for (int x=0; x<_boardCopy.size.x; x++) {
        for (int y=0; y<_boardCopy.size.y; y++) {
            CGContextSetLineWidth(context, lineWidth);

            CGContextStrokeRect(context, CGRectMake(x*sideX, y*sideY, sideX, sideY));
            CGContextSetLineWidth(context, lineWidth *10);

            if ([_boardCopy markAtCoords:TTMCoordsMake(x, y)]==TTMMarkO) {
                CGContextStrokeEllipseInRect(context, CGRectMake(x*sideX+insetX, y*sideY+insetY, sideX-insetX*2, sideY-insetY*2));
            }
            if ([_boardCopy markAtCoords:TTMCoordsMake(x, y)]==TTMMarkX) {
                CGContextStrokeRect(context, CGRectMake(x*sideX+insetX, y*sideY+insetY, sideX-insetX*2, sideY-insetY*2));
            }

        }
    }
    
}

-(void)drawBoard:(TTMBoard *)board {
    NSLog(@"Drawing board in BoardView: %@", board);
    _boardCopy = [board copy];
    [self setNeedsDisplay];
}


-(TTMCoords)boardCoordinatesFromCGPoint:(CGPoint)point {
    CGSize size = self.frame.size;
    CGFloat sideX = size.width/(CGFloat)_boardCopy.size.x;
    CGFloat sideY = size.height/(CGFloat)_boardCopy.size.y;

    return TTMCoordsMake(point.x/sideX, point.y/sideY);
}
@end

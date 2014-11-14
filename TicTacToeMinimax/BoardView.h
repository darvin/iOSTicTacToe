//
//  BoardView.h
//  TicTacToeMinimax
//
//  Created by Sergey Klimov on 11/13/14.
//  Copyright (c) 2014 Sergey Klimov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTMBoard.h"
#import "TTMGame.h"
@interface BoardView : UIView

-(void)drawBoard:(TTMBoard *)board;
-(TTMCoords)boardCoordinatesFromCGPoint:(CGPoint)point;
@end

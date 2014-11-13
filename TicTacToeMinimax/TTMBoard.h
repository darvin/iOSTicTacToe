//
//  TTMBoard.h
//  TicTacToeMinimax
//
//  Created by Sergey Klimov on 11/13/14.
//  Copyright (c) 2014 Sergey Klimov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TTMGame.h"

@interface TTMBoard : NSObject
-(id)initWithSide:(int)side;

//for prefilled boards
-(id)initWithSide:(int)side marks:(TTMMark *)marks;

@property (readonly) TTMCoords size;

-(BOOL)setMark:(TTMMark)mark atCoords:(TTMCoords)coords;
-(TTMMark)markAtCoords:(TTMCoords)coords;


-(TTMMark)winner;
-(BOOL)isFull;
-(BOOL)isGameFinished;
-(TTMCoords)winningCoordsStart;
-(TTMCoords)winningCoordsEnd;

@end

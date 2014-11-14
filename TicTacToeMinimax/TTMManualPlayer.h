//
//  TTMManualPlayer.h
//  TicTacToeMinimax
//
//  Created by Sergey Klimov on 11/13/14.
//  Copyright (c) 2014 Sergey Klimov. All rights reserved.
//

#import "TTMPlayer.h"
#import "TTMGame.h"
@interface TTMManualPlayer : TTMPlayer
-(BOOL)takeManualTurn:(TTMCoords)coords inGame:(TTMGame *)game;
@end

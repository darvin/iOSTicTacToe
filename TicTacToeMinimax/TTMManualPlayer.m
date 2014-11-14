//
//  TTMManualPlayer.m
//  TicTacToeMinimax
//
//  Created by Sergey Klimov on 11/13/14.
//  Copyright (c) 2014 Sergey Klimov. All rights reserved.
//

#import "TTMManualPlayer.h"

@implementation TTMManualPlayer {
    BOOL _awaitingTurn;
}
-(void)takeTurnInGame:(TTMGame*)game {
    //do nothing, await input.
    _awaitingTurn = YES;
}

-(BOOL)takeManualTurn:(TTMCoords)coords inGame:(TTMGame *)game {
    if (!_awaitingTurn) {
        return NO;
    } else {
        _awaitingTurn = NO;
        [game player:self takesTurn:coords];

        return YES;
    }
}

@end

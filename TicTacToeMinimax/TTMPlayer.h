//
//  TTMPlayer.h
//  TicTacToeMinimax
//
//  Created by Sergey Klimov on 11/12/14.
//  Copyright (c) 2014 Sergey Klimov. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TTMGame;

@interface TTMPlayer : NSObject


// Called by TTMGame when its time to player to take turn
-(void)takeTurnInGame:(TTMGame*)game;


@end

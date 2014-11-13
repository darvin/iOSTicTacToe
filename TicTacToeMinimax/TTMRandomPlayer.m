//
//  TTMRandomPlayer.m
//  TicTacToeMinimax
//
//  Created by Sergey Klimov on 11/13/14.
//  Copyright (c) 2014 Sergey Klimov. All rights reserved.
//

#import "TTMRandomPlayer.h"
#import "TTMBoard.h"

@implementation TTMRandomPlayer

-(void)takeTurnInGame:(TTMGame*)game {
    TTMBoard *board = [game copyBoard];
    //Well, this one player is sanity tester, let it assert insane stuff
    assert(![board isFull]); //takeTurnInGame: should not be called if board is full
//    assert([board winner]==TTMMarkNULL); //takeTurnInGame: should not be called if game won by someone
    // Now we are sure that there is some place to put our mark
    TTMMark myMark = [game markForPlayer:self];
    
    TTMCoords *emptyCoords = malloc(board.size.x*board.size.y*sizeof(emptyCoords));
    int emptyCoordsNum = 0;
    for (int x=0; x<board.size.x; x++) {
        for (int y=0; y<board.size.y; y++) {
            TTMCoords coords = TTMCoordsMake(x,y);
            TTMMark mark = [board markAtCoords:coords];
            if (mark==TTMMarkNULL) {
                emptyCoords[emptyCoordsNum] = coords;
                emptyCoordsNum ++;
            }
        }
    }
    
    TTMCoords verySmartlyChoosenCoordsForTurn = emptyCoords[arc4random()%emptyCoordsNum];
    
    free(emptyCoords);
    
    [game player:self takesTurn:verySmartlyChoosenCoordsForTurn];
    
}


@end

//
//  TTMMinMaxPlayer.m
//  TicTacToeMinimax
//
//  Created by Sergey Klimov on 11/13/14.
//  Copyright (c) 2014 Sergey Klimov. All rights reserved.
//

#import "TTMMinMaxPlayer.h"

#import "TTMGame.h"
#import "TTMBoard.h"


int minmaxBestMove(TTMBoard *board, TTMMark player, int*score);

int minimaxScoreBoard(TTMBoard *board, TTMMark player) {

    if([board isGameFinished]) {
        TTMMark winner = [board winner];
        TTMMark opponent = (player==TTMMarkO)?TTMMarkX:TTMMarkO;
        
        if (winner==player) {
            return 1;
        } else if(winner==opponent) {
            return -1;
        } else {
            return 0;
        }
    } else {
        int score;
        minmaxBestMove(board, player, &score);
        return score;
 
    }
    
}


int minmaxBestMove(TTMBoard *board, TTMMark player, int*resultScore) {
    int maxScore = -2;
    int move = -1;
    TTMMark opponent = (player==TTMMarkO)?TTMMarkX:TTMMarkO;
    for(int i = 0; i < [board marksCount]; ++i) {
        if([board markAtIndex:i] == TTMMarkNULL) {
            [board setMark:player atIndex:i];
            int opponentScore = minimaxScoreBoard(board, opponent);
            int score = -opponentScore;
            [board setMark:TTMMarkNULL atIndex:i];
//            if(score==1) {
//                *resultScore = score;
//                return i;
//            }
            if (score>maxScore) {
                maxScore = score;
                move = i;
            }
        }
    }

    *resultScore = maxScore;
    return move;


}

TTMCoords bestMoveForPlayer(TTMBoard *board, TTMMark player) {
    int score;
    int move = minmaxBestMove(board, player, &score);
    TTMCoords coords = [board coordsForIndex:move];
    NSLog(@"MINIMAX ROBOT, PLAYS FOR %@ WITH COORDS %d %d", NSStringWithTTMMark(player), coords.x, coords.y);
    return coords;

}

@implementation TTMMinMaxPlayer
-(void)takeTurnInGame:(TTMGame*)game {
    TTMBoard *board = [game copyBoard];
    TTMMark myMark = [game markForPlayer:self];
    TTMCoords move = bestMoveForPlayer(board, myMark);
    [game player:self takesTurn:move];
}
@end

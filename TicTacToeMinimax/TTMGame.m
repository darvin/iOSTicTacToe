//
//  TTMGame.m
//  TicTacToeMinimax
//
//  Created by Sergey Klimov on 11/12/14.
//  Copyright (c) 2014 Sergey Klimov. All rights reserved.
//

#import "TTMGame.h"
#import "TTMBoard.h"
#import "TTMPlayer.h"

TTMCoords TTMCoordsMake(int x, int y) {
    TTMCoords coords;
    coords.x = x;
    coords.y = y;
    return  coords;
}

BOOL TTMCoordsEqualToCoords(TTMCoords c1, TTMCoords c2) {
    return c1.x==c2.x&&c1.y==c2.y;
}

NSString *NSStringWithTTMMark(TTMMark mark) {
    switch (mark) {
        case TTMMarkNULL:
            return @" ";
            break;
        case TTMMarkO:
            return @"O";
            break;
        case TTMMarkX:
            return @"X";
            break;
        default:
            return nil;
            break;
    }
    
}
TTMMark TTMMarkOppositeToMark(TTMMark mark) {
    switch (mark) {
        case TTMMarkNULL:
            return TTMMarkNULL;
            break;
        case TTMMarkO:
            return TTMMarkX;
            break;
        case TTMMarkX:
            return TTMMarkO;
            break;
        default:
            return TTMMarkNULL;
            break;
    }
}

@implementation TTMGame {
    TTMBoard *_board;
    NSMutableArray *_players;
    int _currentPlayerIndex;
    BOOL _isGameSync;
}

@synthesize delegate = _delegate;

-(id)initWithBoard:(TTMBoard *)board {
    if (self=[super init]) {
        _board = board;
        _players = [[NSMutableArray alloc] init];
        _currentPlayerIndex = 0;
        _isGameSync = YES;
    }
    return self;
}

-(NSString *)description {
    return [NSString stringWithFormat:@"<TTMGame: board:\n%@\nIt's turn of %@ >", _board, NSStringWithTTMMark([self markForPlayer:[self _currentPlayer]])];
}



-(TTMPlayer *)_nextPlayer {
    _currentPlayerIndex ++;
    if (_currentPlayerIndex==[_players count]) {
        _currentPlayerIndex = 0;
    }
    return [self _currentPlayer];
}

-(TTMPlayer *)_currentPlayer {
    return [_players objectAtIndex:_currentPlayerIndex];
}

-(void)performGameSync {
    _isGameSync = YES;
    [[self _currentPlayer] takeTurnInGame:self];
}

-(void)startGame {
    _isGameSync = NO;
    dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){

        [[self _currentPlayer] takeTurnInGame:self];
    });
}

-(BOOL)addPlayerToGame:(TTMPlayer*)player {
    if ([_players count]<TTMMarkX_MAX) {
        [_players addObject:player];
        return YES;
    } else {
        return NO;
    }
}



-(void)player:(TTMPlayer*)player takesTurn:(TTMCoords)coords {
    [_board setMark:[self markForPlayer:player] atCoords:coords];
    [self _nextPlayer];
    if ([self.delegate respondsToSelector:@selector(game:player:mark:tookTurnWithCoords:)]) {
        dispatch_async(dispatch_get_main_queue(), ^{

            [self.delegate game:self player:player mark:[self markForPlayer:player] tookTurnWithCoords:coords];
        });
    }
    if ([_players count]==1) {
        return; //If there is only one player plays this game, do not allow it to play it with itself, let it just to make one move
    }
    if ([_board isGameFinished]) {
        if ([self.delegate respondsToSelector:@selector(game:player:mark:wonWithStartingCoords:endingCoords:)]) {
            TTMMark winnerMark = [_board winner];
            TTMPlayer *winner = [self playerForMark:winnerMark];
            dispatch_async(dispatch_get_main_queue(), ^{

                [self.delegate game:self player:winner mark:winnerMark wonWithStartingCoords:[_board winningCoordsStart] endingCoords:[_board winningCoordsEnd]];
            });
        }
    } else {
        if (_isGameSync) {
            [[self _currentPlayer] takeTurnInGame:self];

        } else {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
                [[self _currentPlayer] takeTurnInGame:self];
            });
        }
    }

}
-(TTMBoard *)copyBoard {
    
    return [_board copy];
    
}
-(TTMMark)markForPlayer:(TTMPlayer *)player {
    return  (TTMMark)[_players indexOfObject:player];
}

-(TTMPlayer *)playerForMark:(TTMMark)mark {
    if (mark>TTMMarkNULL&&mark<TTMMarkX_MAX) {
        return [_players objectAtIndex:mark];
    } else {
        return nil;
    }
}


@end

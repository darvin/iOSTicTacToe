//
//  TTMGame.h
//  TicTacToeMinimax
//
//  Created by Sergey Klimov on 11/12/14.
//  Copyright (c) 2014 Sergey Klimov. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TTMPlayer;

typedef struct  {
    int x;
    int y;
} TTMCoords;

TTMCoords TTMCoordsMake(int x, int y);
BOOL TTMCoordsEqualToCoords(TTMCoords c1, TTMCoords c2);

typedef enum : int {
    TTMMarkNULL = -1,
    TTMMarkO,
    TTMMarkX,
    TTMMarkX_MAX
} TTMMark;


NSString *NSStringWithTTMMark(TTMMark mark);

@class TTMGame;
@class TTMBoard;

@protocol TTMGameDelegate <NSObject>

-(void)game:(TTMGame *)game player:(TTMPlayer*) player mark:(TTMMark) mark tookTurnWithCoords:(TTMCoords) coords;


// If game is draw, player gonna be nil
-(void)game:(TTMGame *)game player:(TTMPlayer*) player mark:(TTMMark) mark wonWithStartingCoords:(TTMCoords) coords endingCoords:(TTMCoords) coords;

@end


@interface TTMGame : NSObject
-(id)initWithBoard:(TTMBoard *)board;
-(void)startGame;

//For bot matches/test purposes, why not?
-(void)performGameSync;
@property (weak) id<TTMGameDelegate>delegate;


//Returns YES on success
-(BOOL)addPlayerToGame:(TTMPlayer*)player;


////////// Player's API
//That are the only methods players are suppose to call
-(void)player:(TTMPlayer*)player takesTurn:(TTMCoords)coords;
-(TTMBoard *)copyBoard;
-(TTMMark)markForPlayer:(TTMPlayer *)winner;
//////////////////





@end

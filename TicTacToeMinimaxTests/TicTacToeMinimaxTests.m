//
//  TicTacToeMinimaxTests.m
//  TicTacToeMinimaxTests
//
//  Created by Sergey Klimov on 11/12/14.
//  Copyright (c) 2014 Sergey Klimov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import "TTMGame.h"
#import "TTMBoard.h"
#import "TTMRandomPlayer.h"



@interface TestGameDelegate : NSObject<TTMGameDelegate> {
    BOOL _isGameFinished;
    TTMMark _markThatWon;
    TTMPlayer * _playerThatWon;
}
@property BOOL logging;
-(TTMPlayer *)winningPlayer;
-(TTMMark)winningMark;

- (void)wait;
@end

@implementation TestGameDelegate

@synthesize logging = _logging;

-(void)game:(TTMGame *)game player:(TTMPlayer*) player mark:(TTMMark) mark tookTurnWithCoords:(TTMCoords) coords {
    if (_logging) {
        NSLog(@"Player %@ took turn. Game state: %@", NSStringWithTTMMark(mark), game);

    }
}

-(void)game:(TTMGame *)game player:(TTMPlayer*) player mark:(TTMMark) mark wonWithStartingCoords:(TTMCoords) coords endingCoords:(TTMCoords) coords {
    if (_logging) {
        if (mark==TTMMarkNULL) {
            NSLog(@"Its draw :(");
        } else {
            NSLog(@"Player %@ won :)", NSStringWithTTMMark(mark));
        }

    }
    _isGameFinished = YES;
    _markThatWon = mark;
    _playerThatWon = player;

}
- (void)wait {
    //Well, thats not so great but will do for now
    while (!_isGameFinished) {
        sleep(0.1);
    }
}

-(TTMPlayer *)winningPlayer {
    return _playerThatWon;
}
-(TTMMark)winningMark {
    return _markThatWon;
}

@end



@interface TicTacToeMinimaxTests : XCTestCase

@end

@implementation TicTacToeMinimaxTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}


void TTMAssertBoardWins(TTMMark*marks, int side, TTMMark expectedMark) {
    TTMBoard *board = [[TTMBoard alloc] initWithSide:side marks:marks];
    NSCAssert([board winner]==expectedMark, @"winner of the board should be defined correctly");
}
- (void)testBoard {
    //I was thinking to make it #defines and wish anyone "happy debugging", but changed my mind and made them into local constants
 
    const int X = TTMMarkX;
    const int O = TTMMarkO;
    const int _  =TTMMarkNULL;
    const int side = 3;
    
    TTMMark vertX[side*side] ={
        O, X, O,
        X, X, O,
        _, X, X
    };
    
    TTMAssertBoardWins(vertX, side, X);
    
    TTMMark vertO[side*side] ={
        O, X, O,
        X, O, O,
        _, X, O
    };
    TTMAssertBoardWins(vertO, side, O);

    TTMMark horO[side*side] ={
        O, X, X,
        O, O, O,
        _, X, O
    };
    TTMAssertBoardWins(horO, side, O);

    
    TTMMark diagX[side*side] ={
        X, X, O,
        X, X, O,
        _, O, X
    };
    TTMAssertBoardWins(diagX, side, X);

    TTMMark rdiagX[side*side] ={
        O, O, X,
        X, X, O,
        X, O, X
    };
    TTMAssertBoardWins(rdiagX, side, X);

}


- (void) performSyncGameWithPlayer1:(TTMPlayer *) player1 player2:(TTMPlayer *)player2 logging:(BOOL) logging{
    TTMBoard *emptyBoard = [[TTMBoard alloc] initWithSide:5];
    TTMGame *game = [[TTMGame alloc] initWithBoard:emptyBoard];
    TestGameDelegate *gameDelegate = [[TestGameDelegate alloc] init];
    gameDelegate.logging = logging;
    game.delegate = gameDelegate;
    XCTAssert([game addPlayerToGame:player1], @"Should successfully add player to a game");
    XCTAssert([game addPlayerToGame:player2], @"Should successfully add player to a game");
    [game performGameSync];
    
    TTMBoard *resultBoard = [game copyBoard];
    XCTAssert([gameDelegate winningMark]==[resultBoard winner], @"Winner should be proper");

    
}

- (void)testRandomPlayerSync {
    // Lets test random players playing with each other. Basically, sanity test for our game engine
    
    TTMPlayer *player1 = [[TTMRandomPlayer alloc] init];
    TTMPlayer *player2 = [[TTMRandomPlayer alloc] init];
    
    [self performSyncGameWithPlayer1:player1 player2:player2 logging:YES];
    
}



- (void)testMuptiplyRandomGameSanity {
    const int numGames = 1000;
    TTMPlayer *player1 = [[TTMRandomPlayer alloc] init];
    TTMPlayer *player2 = [[TTMRandomPlayer alloc] init];
    

    [self measureBlock:^{
        for (int i=0; i<numGames; i++) {
            [self performSyncGameWithPlayer1:player1 player2:player2 logging:NO];
        }
    }];
}

@end

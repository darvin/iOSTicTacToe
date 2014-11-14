//
//  ViewController.m
//  TicTacToeMinimax
//
//  Created by Sergey Klimov on 11/12/14.
//  Copyright (c) 2014 Sergey Klimov. All rights reserved.
//

#import "ViewController.h"
#import "BoardView.h"
#import "TTMGame.h"
#import "TTMBoard.h"
#import "TTMMinMaxPlayer.h"
#import "TTMManualPlayer.h"

@interface ViewController ()<TTMGameDelegate> {
    IBOutlet BoardView* _boardView;
    IBOutlet UILabel* _statusLabel;
    IBOutlet UIStepper* _sideStepper;
    TTMManualPlayer *_userPlayer;
    TTMPlayer *_aiPlayer;
    TTMGame *_game;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _userPlayer = [[TTMManualPlayer alloc] init];
    _aiPlayer = [[TTMMinMaxPlayer alloc] init];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(boardViewTappedWithGestureRecognizer:)];
    [_boardView addGestureRecognizer:tap];
    [self startNewGame];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)startNewGame {
    _statusLabel.text = @"New game is started...";
    TTMBoard *board = [[TTMBoard alloc] initWithSide:(int)_sideStepper.value];
    [_boardView drawBoard:[board copy]];

    _game = [[TTMGame alloc] initWithBoard:board];
    _game.delegate = self;
    [_game addPlayerToGame: _aiPlayer];
    [_game addPlayerToGame: _userPlayer];
    [_game startGame];
    
}

-(IBAction)newGameTouched:(id)sender {
    [self startNewGame];
}
-(IBAction)sizeValueChanged:(id)sender {
    [self startNewGame];
}

-(void)boardViewTappedWithGestureRecognizer:(UITapGestureRecognizer *)gestureRecognizer {
    if(gestureRecognizer.state == UIGestureRecognizerStateRecognized)
    {
        CGPoint point = [gestureRecognizer locationInView:gestureRecognizer.view];
        BoardView *boardView = (BoardView*)gestureRecognizer.view;
        [_userPlayer takeManualTurn: [boardView boardCoordinatesFromCGPoint:point] inGame:_game];
    }
}


-(void)game:(TTMGame *)game player:(TTMPlayer*) player mark:(TTMMark) mark tookTurnWithCoords:(TTMCoords) coords {
    [_boardView drawBoard:[game copyBoard]];

    _statusLabel.text = [NSString stringWithFormat:@"It's player's '%@' turn now.", NSStringWithTTMMark(TTMMarkOppositeToMark(mark))];
}


-(void)game:(TTMGame *)game player:(TTMPlayer*) player mark:(TTMMark) mark wonWithStartingCoords:(TTMCoords) coords endingCoords:(TTMCoords) coords {
    [_boardView drawBoard:[game copyBoard]];
    NSString *txt = [NSString stringWithFormat:@"Player '%@' won :)", NSStringWithTTMMark(mark)];
    if (mark==TTMMarkNULL) {
        txt = @"Its draw :(";
    }
    _statusLabel.text = [NSString stringWithFormat:@"%@ To start a new game press a button", txt];
}

@end

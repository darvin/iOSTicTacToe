//
//  TTMBoard.m
//  TicTacToeMinimax
//
//  Created by Sergey Klimov on 11/13/14.
//  Copyright (c) 2014 Sergey Klimov. All rights reserved.
//

#import "TTMBoard.h"


@implementation TTMBoard {
    TTMMark *_marks;
    
    BOOL _isGameFinished;
    TTMMark _winner;
    TTMCoords _winningCoordsStart;
    TTMCoords _winningCoordsEnd;
}
@synthesize size = _size;

-(id)initWithSide:(int)side {
    return [self initWithSide:side marks:NULL];
}

-(id)initWithSide:(int)side marks:(TTMMark *)marks {
    if (self=[super init]) {
        _size = TTMCoordsMake(side, side);
        _marks = malloc(_size.x*_size.y*sizeof(TTMMark));
        _winner = TTMMarkNULL;
        _winningCoordsEnd = _winningCoordsStart = TTMCoordsMake(-1, -1);
        _isGameFinished = NO; //just for style

        if (marks!=NULL) {
            for (int i=0; i<_size.x*_size.y; i++) {
                _marks[i] = marks[i];
            }
        } else {
            for (int i=0; i<_size.x*_size.y; i++) {
                _marks[i] = TTMMarkNULL;
            }
        }

    }
    return self;
}

-(NSString *)description {
    NSMutableString *result = [NSMutableString stringWithString:@"<TTMBoard: \n"];
    
    for (int y=0; y<_size.y; y++) {
        
        for (int x=0; x<_size.x; x++) {
            TTMCoords coords = TTMCoordsMake(x,y);
            TTMMark mark = [self markAtCoords:coords];
            NSString *markFormat = @" %@ ";
            if (TTMCoordsEqualToCoords(coords, _winningCoordsStart)||TTMCoordsEqualToCoords(coords, _winningCoordsEnd)) {
                markFormat = @"<%@>";
            }
            [result appendFormat:markFormat,NSStringWithTTMMark(mark)];
            
        }
        [result appendString:@"\n"];
    }
    
    [result appendString:@">"];
    
    return result;
}


-(id)copy {
    return [[TTMBoard alloc] initWithSide:_size.x marks:_marks];
}

-(void)dealloc {

    free(_marks);
}

-(int)_marksIndexForCoords:(TTMCoords)coords {
    if (coords.x<0||coords.x>_size.x||coords.y<0||coords.y>_size.y) {
        return -1;
    } else {
        return coords.x+coords.y*_size.y;
    }
}

-(BOOL)setMark:(TTMMark)mark atCoords:(TTMCoords)coords {
    if ([self _marksIndexForCoords:coords]==-1||[self markAtCoords:coords]!=TTMMarkNULL) {
        return NO;
    } else {
        _marks[[self _marksIndexForCoords:coords]] = mark;
        return YES;
    }
}
-(TTMMark)markAtCoords:(TTMCoords)coords {
    if ([self _marksIndexForCoords:coords]==-1) {
        return TTMMarkNULL;
    } else {
        return _marks[[self _marksIndexForCoords:coords]];
    }
}



-(void) _ensureWinnerIsCalculated {
    if (_isGameFinished) {
        return;
    }
    

    
    //There are alhorithmically better ways to check the winner (probably) but I'm too lazy for it. TTMMinMaxPlayer class is showcase of better alhorightms lol.
    TTMMark winningMark = TTMMarkNULL;
    
    
    
    for (int x=0; x<_size.x; x++) {
        winningMark = [self markAtCoords:TTMCoordsMake(x,0)];

        for (int y=0; y<_size.y; y++) {
            TTMCoords coords = TTMCoordsMake(x,y);
            if ([self markAtCoords:coords]!=winningMark) {
                winningMark = TTMMarkNULL;
                break;
            }
        }
        if (winningMark !=TTMMarkNULL) {
            _winner = winningMark;
            _winningCoordsStart = TTMCoordsMake(x, 0);
            _winningCoordsEnd = TTMCoordsMake(x, _size.y-1);
            _isGameFinished = YES;
            return;
        }
    }
    for (int y=0; y<_size.y; y++) {
        winningMark = [self markAtCoords:TTMCoordsMake(0,y)];
        
        for (int x=0; x<_size.x; x++) {
            TTMCoords coords = TTMCoordsMake(x,y);
            if ([self markAtCoords:coords]!=winningMark) {
                winningMark = TTMMarkNULL;
                break;
            }
        }
        if (winningMark !=TTMMarkNULL) {
            _winner = winningMark;
            _winningCoordsStart = TTMCoordsMake(0, y);
            _winningCoordsEnd = TTMCoordsMake(_size.x-1, y);
            _isGameFinished = YES;
            return;
        }
    }

    
    winningMark = [self markAtCoords:TTMCoordsMake(0,0)];

    for (int x=0; x<_size.x; x++) {
        TTMCoords coords = TTMCoordsMake(x,x);
        if ([self markAtCoords:coords]!=winningMark) {
            winningMark = TTMMarkNULL;
            break;
        }
    }
    if (winningMark !=TTMMarkNULL) {
        _winner = winningMark;
        _winningCoordsStart = TTMCoordsMake(0, 0);
        _winningCoordsEnd = TTMCoordsMake(_size.x-1, _size.y-1);
        _isGameFinished = YES;
        return;
    }

    winningMark = [self markAtCoords:TTMCoordsMake(_size.x-1,0)];
    
    for (int x=0; x<_size.x; x++) {
        TTMCoords coords = TTMCoordsMake(_size.x-1-x,x);
        if ([self markAtCoords:coords]!=winningMark) {
            winningMark = TTMMarkNULL;
            break;
        }
    }
    if (winningMark !=TTMMarkNULL) {
        _winner = winningMark;
        _winningCoordsStart = TTMCoordsMake(_size.x-1,0);
        _winningCoordsEnd = TTMCoordsMake(0, _size.y-1);
        _isGameFinished = YES;
        return;
    }
    if ([self isFull]) {
        _isGameFinished = YES;
        return;
    }
    
}

-(BOOL)isFull {
    for (int i=0; i<_size.x*_size.y; i++) {
        if (_marks[i]==TTMMarkNULL) {
            return NO;
        }
    }
    return YES;
}

-(TTMMark)winner {
    [self _ensureWinnerIsCalculated];
    return _winner;
}

-(BOOL)isGameFinished {
    [self _ensureWinnerIsCalculated];
    return _isGameFinished;
}

-(TTMCoords)winningCoordsStart {
    [self _ensureWinnerIsCalculated];
    return _winningCoordsStart;
}

-(TTMCoords)winningCoordsEnd {
    [self _ensureWinnerIsCalculated];
    return _winningCoordsEnd;
}

@end


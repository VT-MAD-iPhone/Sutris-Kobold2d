//
//  SutrisModel.h
//  Sutris
//
//  Created by William Mecklenburg on 9/20/12.
//  Copyright (c) 2012 William Mecklenburg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BoardCell.h"


@protocol SutrisModelDelegate <NSObject>
@required

- (void) updateActiveBlock;
- (void) updateSideQueue;
- (void) newActiveBlock;
- (void) lockInActiveBlockWithRow:(int) row andCol:(int) col;

@end

typedef enum
{
    empty,
    one,
    two,
    three,
    four,
    five,
    six,
    seven,
    eight,
    nine,
    star,
    invalid
} BoardValue;

typedef enum
{
    up,
    down,
    left,
    right
} Direction;

@interface SutrisModel : NSObject
{
    NSMutableArray *columnSets;
    NSMutableArray *rowSets;
    NSMutableArray *squareSets;
    NSMutableArray *sideQueue;
    NSTimer *blockTimer;
    id <SutrisModelDelegate> delegate;
}

@property (nonatomic, strong) NSMutableArray *sideQueue;
@property (nonatomic, strong) NSMutableArray *board;
@property (nonatomic, strong) BoardCell *activeBlock;
@property (retain) id delegate;

//@property

- (BOOL) initializeWithRows:(int) rows andCols:(int)cols;
- (BOOL) inputIsSafeWithRow:(int) row andCol:(int)col;
- (void) initializeHashSets;
- (int) width;
- (int) height;
- (void) setCellValueWithRow:(int) row andCol:(int) col andValue:(BoardValue) boardValue;
- (BoardValue) getCellValueWithRow:(int) row andCol:(int) col;
- (BOOL) placementIsValidForActiveBlock;
- (void) addNewBlockToSideQueue;
- (void) addBlockToGameFromSideQueue;
- (void) moveActiveBlockDown;
- (void) moveBlockWithSideDirection:(Direction) direction;
- (void) makeActiveBlockPermanent;
- (BOOL) checkValidMoveLocation:(Direction) direction;
- (void) startGame;
- (void) updateViewController;


@end

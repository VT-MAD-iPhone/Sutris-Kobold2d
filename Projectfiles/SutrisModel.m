//
//  SutrisModel.m
//  Sutris
//
//  Created by William Mecklenburg on 9/20/12.
//  Copyright (c) 2012 William Mecklenburg. All rights reserved.
//


//rows go from 0 to maxrows+extraspace-1, cols go from 0 - maxcols-1
#import "SutrisModel.h"

#define UPDATETIME 0.5f
#define UPDATEDIST 20.0f
#define SUDOKUSTART 4 //the first index of the sudoku board
#define SIDEQUEUELENGTH 3

//C array of ints to hold boardvalues
int MAXROWS, MAXCOLS, BIGSQUARES, EXTRASPACE, STARCHANCE;


@implementation SutrisModel

#pragma mark initialization code

/*
 * initializes the model with the given row and column values (should usually be 9,9)
 * returns success
 */

- (BOOL) initializeWithRows:(int)rows andCols:(int)cols
{
    if (rows%3 == 0 && cols%3 == 0) {
        //set the initial values
        EXTRASPACE = 4;
        MAXROWS = rows;
        MAXCOLS = cols;
        BIGSQUARES = (rows/3) * (cols/3);
        STARCHANCE = 3;
        
        sideQueue = [[NSMutableArray alloc] initWithCapacity:3];
        
        
        //creates the board
        self.board = [[NSMutableArray alloc] initWithCapacity: MAXROWS + EXTRASPACE];
        for (int i = 0; i < MAXROWS+EXTRASPACE; i++)
        {
            [self.board addObject:[[NSMutableArray alloc]initWithCapacity:MAXCOLS]];
        }
        
        //fills the board with empty cells
        for (int row = 0; row < MAXROWS+EXTRASPACE; row++)
        {
            for (int col = 0; col < MAXCOLS; col++)
            {
                [[self.board objectAtIndex:row] addObject:[[BoardCell alloc] initWithValue:empty]];
            }
        }
        
        [self initializeHashSets];
        return TRUE;
    }
    return FALSE;
    
}

/*
 * initialize the 3 hashsets that will be used for checking the sudoku position validity
 */
- (void) initializeHashSets
{
    columnSets = [[NSMutableArray alloc]init];
    rowSets    = [[NSMutableArray alloc]init];
    squareSets = [[NSMutableArray alloc]init];
    
    for (int cols = 0; cols < MAXCOLS; cols++)
    {
        [columnSets addObject:[[NSMutableSet alloc]init]];
    }
    for (int rows = 0; rows < MAXROWS; rows++)
    {
        [rowSets addObject:[[NSMutableSet alloc]init]];
    }
    for (int squares = 0; squares < BIGSQUARES; squares++)
    {
        [squareSets addObject:[[NSMutableSet alloc]init]];
    }
}

- (void) startGame
{
    //starts the game...
    for (int i = 0; i < SIDEQUEUELENGTH; i++) {
        [self addNewBlockToSideQueue];
    }
    [self addBlockToGameFromSideQueue];
}


#pragma mark motion/placement checkers

- (BOOL) placementIsValidForActiveBlock;
{
    if (self.activeBlock.row >= EXTRASPACE)
    {
        int squareIndex = [self squareIndexWithRow:self.activeBlock.row andCol:self.activeBlock.col];
        
        //check the 3 hashsets for the square
        BoardValue valueInQuestion = self.activeBlock.value;
        if ([[squareSets objectAtIndex:squareIndex] containsObject:[NSNumber numberWithInt:valueInQuestion]] ||
            [[columnSets objectAtIndex:self.activeBlock.col]         containsObject:[NSNumber numberWithInt:valueInQuestion]] ||
            [[rowSets objectAtIndex:self.activeBlock.row-EXTRASPACE] containsObject:[NSNumber numberWithInt:valueInQuestion]])
        {
            return FALSE;
        }
    }
    return TRUE;
}

- (BOOL) inputIsSafeWithRow:(int) row andCol:(int)col
{
    return (row >= 0 && row < MAXROWS+EXTRASPACE && col >= 0 && col < MAXCOLS);
}

- (BOOL) checkValidMoveLocation:(Direction) direction
{
    //check the space which you are trying to move to, if it is empty, return true, else return false
    switch (direction) {
        case down:
            if ([self getCellValueWithRow:self.activeBlock.row+1 andCol:self.activeBlock.col] == empty) {
                return true;
            }
            break;
        case left:
            if ([self getCellValueWithRow:self.activeBlock.row andCol:self.activeBlock.col-1] == empty) {
                return true;
            }
            break;
        case right:
            if ([self getCellValueWithRow:self.activeBlock.row andCol:self.activeBlock.col+1] == empty) {
                return true;
            }
            break;
        case up:
            if ([self getCellValueWithRow:self.activeBlock.row-1 andCol:self.activeBlock.col] == empty) {
                return true;
            }
            break;
        default:
            break;
    }
    
    return false;
}



#pragma mark sudoku getters, setters, and helpers
- (int) width
{
    return MAXCOLS;
}

- (int) height
{
    return EXTRASPACE + MAXROWS;
}

- (void) setCellValueWithRow:(int) row andCol:(int) col andValue:(BoardValue) boardValue
{
    if ([self inputIsSafeWithRow:row andCol:col]) {
        [((BoardCell *)[[self.board objectAtIndex:row] objectAtIndex:col]) setValue:boardValue];
    }
    
    
}

- (BoardValue) getCellValueWithRow:(int) row andCol:(int) col
{
    if ([self inputIsSafeWithRow:row andCol:col])
    {
        return [((BoardCell *)[[self.board objectAtIndex:row] objectAtIndex:col]) value];
    }
    else
    {
        return (BoardValue)invalid;
    }
    
}

- (int) squareIndexWithRow:(int) row andCol:(int)col
{
    row -= EXTRASPACE;
    /* calculate the square index according to this table
     _______
     |0|1|2|
     _______
     |3|4|5|
     _______
     |6|7|8|
     _______
     */
    return (row%9 - row%3) + (col%9 - col%3)/3;
}


- (void) setActiveBlockRow:(int)row andCol:(int)col
{
    [[self.board objectAtIndex:self.activeBlock.row] setObject:[[BoardCell alloc]initWithValue:empty] atIndex:self.activeBlock.col];
    [[self.board objectAtIndex:row] setObject:self.activeBlock atIndex:col];
    [self.activeBlock setRow:row];
    [self.activeBlock setCol:col];
}


#pragma mark side queue methods
- (void) addNewBlockToSideQueue
{
    //generate the value for the new block at random
    int newValue = (arc4random() % 9+STARCHANCE) + 1;
    
    if (newValue > star)
    {
        newValue = star;
    }
    
    [sideQueue insertObject:[[BoardCell alloc]initWithValue:newValue] atIndex:0];
}

- (void) addBlockToGameFromSideQueue
{
    //Planned for future: make sure the game doesn't give a block when there are 9 already on the field, as it will have nowhere to be put
    
    self.activeBlock = [sideQueue lastObject];
    [sideQueue removeLastObject];
    [self addNewBlockToSideQueue];
    [self setActiveBlockRow:0 andCol:4];
    
    [self startTimer];
    
    [[self delegate] newActiveBlock];
}

#pragma mark tetris methods
//moves the block down (adjusted for lag or something)
- (void) moveActiveBlockDown
{
    if ([self checkValidMoveLocation:down])
    {
        int row = self.activeBlock.row;
        [self setActiveBlockRow:row+1 andCol:self.activeBlock.col];
        [[self delegate] updateActiveBlock];
    }
    else
    {
        [self makeActiveBlockPermanent];
    }
    
}

- (void) moveBlockWithSideDirection:(Direction) direction
{
    //if it is okay to move the block left or right, move it so, otherwise don't do anything
    int col = self.activeBlock.col;
    
    if (direction == left && [self checkValidMoveLocation:direction])
    {
        [self setActiveBlockRow:self.activeBlock.row andCol:col-1];
        [[self delegate] updateActiveBlock];
        
    }
    else if (direction == right && [self checkValidMoveLocation:direction])
    {
        [self setActiveBlockRow:self.activeBlock.row andCol:col+1];
        [[self delegate] updateActiveBlock];
    }
}


/*
 * stops the active block from moving, making it a permanent fixture in the board array. also restarts the 'game loop'
 * so that another block will start falling
 */
- (void) makeActiveBlockPermanent
{
    //if the placement is valid, place it; if the placement is not valid, you lose
    if ([self placementIsValidForActiveBlock])
    {
        if (self.activeBlock.value != empty && self.activeBlock.value != star && self.activeBlock.value != invalid && self.activeBlock.row >= EXTRASPACE)
        {
            int squareIndex = [self squareIndexWithRow:self.activeBlock.row andCol:self.activeBlock.col];
            
            [[squareSets objectAtIndex:squareIndex]                    addObject:[NSNumber numberWithInt:self.activeBlock.value]];
            
            [[columnSets objectAtIndex:self.activeBlock.col]           addObject:[NSNumber numberWithInt:self.activeBlock.value]];
            
            [[rowSets objectAtIndex:(self.activeBlock.row-EXTRASPACE)] addObject:[NSNumber numberWithInt:self.activeBlock.value]];
        }
        [[self delegate] lockInActiveBlockWithRow:self.activeBlock.row-EXTRASPACE andCol:self.activeBlock.col];
    }
    else
    {
        [blockTimer invalidate];
        NSLog(@"LOSE");
        return;
    }
    [self addBlockToGameFromSideQueue];
    [blockTimer invalidate];
    
    
}

#pragma mark tetris discrete movement timer
- (void) startTimer
{
    // Create the timer object, moves the active block down every UPDATETIME seconds (discrete movement for that classic tetris feel 
    blockTimer = [NSTimer scheduledTimerWithTimeInterval:UPDATETIME target:self
                                                selector:@selector(moveActiveBlockDown) userInfo:nil repeats:YES];
}

#pragma mark notify the delegate to update itself based on the model changes
- (void) updateViewController
{
    [[self delegate] updateActiveBlock];
}

@end
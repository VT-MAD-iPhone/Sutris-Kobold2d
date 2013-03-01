//
//  ViewController.m
//  Sutris
//
//  Created by William Mecklenburg on 9/20/12.
//  Copyright (c) 2012 William Mecklenburg. All rights reserved.
//

#import "SutrisViewController.h"



@implementation SutrisViewController

int BLOCKHEIGHT, BLOCKWIDTH, HORIZ_OFFSET, VERT_OFFSET, HORIZ_START, VERT_START;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    
    //Allocate the model
    model = [[SutrisModel alloc]init];
    if ([model initializeWithRows:9 andCols:9])
    {
        [self setInitialArrays];
    }
    
    //Set the dimensions
    BLOCKHEIGHT = 25;
    BLOCKWIDTH = 30;
    HORIZ_OFFSET = 32;
    VERT_OFFSET = 26;
    HORIZ_START = 12;
    VERT_START = 94;
    
    [model setDelegate:self];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

- (IBAction)startGame:(id)sender {
    ((UIButton *)sender).hidden = TRUE;
    [model startGame];
}

- (void) setInitialArrays
{
    //set up the array of containers. references need to be stored for each block container so it can be spun
    
    //set up the array of blocks. references need to be stored for each block so it can be spun
    self.blocks = [[NSMutableArray alloc] initWithCapacity: 9];
    for (int i = 0; i < 9; i++)
    {
        [self.blocks addObject:[[NSMutableArray alloc]initWithCapacity:9]];
    }
    for (int i = 0; i < 9; i++) {
        for (int j = 0; j < 9; j++) {
            [[self.blocks objectAtIndex:i] addObject:@""];
        }
    }
    
    
}

#pragma mark SutrisModelDelegate methods
- (void) newActiveBlock
{
    
}

- (void) updateActiveBlock
{
    [self.activeBlock setFrame:CGRectMake(model.activeBlock.col*HORIZ_OFFSET+HORIZ_START,
                                          model.activeBlock.row*VERT_OFFSET+VERT_START,
                                          BLOCKWIDTH,
                                          BLOCKHEIGHT)];
    
}

- (void) updateSideQueue
{
    [[self.blocks objectAtIndex:model.activeBlock.row] setObject:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"SudokuCell.png"]] atIndex:model.activeBlock.col];
    
    [[[self.blocks objectAtIndex:model.activeBlock.row] objectAtIndex:model.activeBlock.col]
     setFrame:CGRectMake(model.activeBlock.col*HORIZ_OFFSET+HORIZ_START,
                         model.activeBlock.row*VERT_OFFSET+VERT_START,
                         BLOCKWIDTH,
                         BLOCKHEIGHT)];
}

- (void) lockInActiveBlockWithRow:(int) row andCol:(int) col
{
    [[self.blocks objectAtIndex:row] replaceObjectAtIndex:col withObject:self.activeBlock];
    /*[[[self.blocks objectAtIndex:row] objectAtIndex:col] setFrame:CGRectMake(col*HORIZ_OFFSET+HORIZ_START,
     row*VERT_OFFSET+VERT_START,
     BLOCKWIDTH,
     BLOCKHEIGHT)];*/
    NSLog(@"%@", [[self.blocks objectAtIndex:row] objectAtIndex:col]);
}

#pragma mark moveActiveBlock methods
- (IBAction)moveActiveBlockLeft:(id)sender
{
    [model moveBlockWithSideDirection:left];
}

- (IBAction)moveActiveBlockRight:(id)sender
{
    [model moveBlockWithSideDirection:right];
}

#pragma mark extra methods: highlight, flip, etc

- (void) flipButtonsInRow:(int) row
{
    
}

- (void) flipButtonsInCol:(int) col
{
    
}

- (void) flipButtonsInSquare:(int) square
{
    
}


- (IBAction)flipButtons:(id)sender
{
    for (int i = 0; i < 9; i++) {
        if ([[[self.blocks objectAtIndex:8] objectAtIndex:i] isKindOfClass:[UIImageView class]])
        {
            //flip code goes here
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:[[self.blocks objectAtIndex:8] objectAtIndex:i] cache:YES];
            [UIView setAnimationDelegate:self];
            [UIView setAnimationDuration:.5];
            [self.view addSubview:[[self.blocks objectAtIndex:8] objectAtIndex:i]];
            
            [UIView commitAnimations];
        }
        
    }
    
}

@end

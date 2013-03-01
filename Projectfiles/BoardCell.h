//
//  BoardCell.h
//  Sutris
//
//  Created by William Mecklenburg on 9/20/12.
//  Copyright (c) 2012 William Mecklenburg. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BoardCell : UIButton
{
    
}

@property int value;
@property int row;
@property int col;


- (id) initWithValue:(int) value;

@end

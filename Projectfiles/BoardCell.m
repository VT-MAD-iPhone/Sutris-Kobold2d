//
//  BoardCell.m
//  Sutris
//
//  Created by William Mecklenburg on 9/20/12.
//  Copyright (c) 2012 William Mecklenburg. All rights reserved.
//

#import "BoardCell.h"

@implementation BoardCell

- (id) initWithValue:(int) value
{
    self = [super init];
    if (self) {
        [self setValue:value];
        [self setRow:0];
        [self setCol:4];
    }
    return self;
}

@end

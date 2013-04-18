//
//  NSMutableArray+Queue.m
//  Queue
//
//  Created by David Cabrera on 2/10/13.
//  Copyright (c) 2013 David Cabrera. All rights reserved.
//
//
//

#import "NSMutableArray+Queue.h"

@implementation NSMutableArray (Queue)

// Add to the end of the queue
- (void) enqueue:(id)block
{
    // Automatically adds to the end of the queue
    [self addObject:block];
}

// Get the block at the front of the queue
- (id) dequeue
{
    // Checking that the queue isn't empty
    if ([self count] == 0)
    {
        return nil;
    }
    id firstBlock = [self objectAtIndex:0];
    
    [self removeObjectAtIndex:0];
    
    return firstBlock;
}

// Get the head of the queue
- (id) peek
{
    if ([self count] == 0)
    {
        return nil;
    }
    return [self objectAtIndex:0];
}
@end

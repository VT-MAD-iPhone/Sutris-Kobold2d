//
//  NSMutableArray+Queue.h
//  Queue
//
//  Created by David Cabrera on 2/10/13.
//  Copyright (c) 2013 David Cabrera. All rights reserved.
//
//
//  This is a special category of the NSMutableArray class which adds
//  queue methods to the mutable array. Enqueue at the back. Dequeue
//  at the front.
//

#import <Foundation/Foundation.h>
@interface NSMutableArray (Queue)

- (void)enqueue:(id)block;
- (id)dequeue;

@end

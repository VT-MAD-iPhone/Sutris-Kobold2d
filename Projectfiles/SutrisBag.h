/*
 *  Sutris
 *  SutrisBag.h
 *
 *  This file contains a bag data structure (sometimes known as a multiset) that should be used explicitly
 *  with the iOS game Sutris. This bag follows the following rules:
 *      
 *      1. When you make a request for a number from the bag, that number will always be valid.
 *      2. You can only draw a finite number of things from the bag. The bag will not overdraw.
 *      3. The bag is reusable and should not have to be instantiated more than once. The bag should be a singleton.
 *
 *  NOTE: The implementation for this class has not yet been completed, so some of these rules may be disobeyed!
 *
 *  (C)2013 Jonathan Ballands
 *  Made for the MAD club at Virginia Tech.
 */

#import <Foundation/Foundation.h>

@interface SutrisBag : NSObject
{
    @private
    
    NSMutableArray * occurances;
}

/*
 *  Requests that a number be pulled from the bag. This will be seemingly random, but the game logic will ensure that a valid
 *  number is always pulled.
 *
 *  Returns the number that the bag pulled. If nil is returned, then the bag was empty, or an error occurred (see terminal
 *  for error information).
 */
- (NSUInteger *) pullNumberFromBag;

/*
 *  Requests that a specific number be pulled from the bag.
 *
 *  Returns the number that you requested. If nil is returned, then the bag had no more instances of that number, the bag
 *  rejected your request because it would produce an invalid sequence of numbers drawn, or an error occured (see terminal
 *  for error information).
 */
//- (NSUInteger *) pullSpecificNumberFromBag: (int) request;

@end

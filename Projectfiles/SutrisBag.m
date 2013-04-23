/*
 *  Sutris
 *  SutrisBag.m
 *
 *  (C)2013 Jonathan Ballands
 *  Made for the MAD club at Virginia Tech.
 */

#import "SutrisBag.h"

@interface SutrisBool : NSObject
{
    // Nothing to declare...
}

@property BOOL value;

@end

@implementation SutrisBool

- (id) initWithValue: (BOOL) v
{
    self = [super init];
    
    if (self) {
        _value = v;
    }
    return self;
}

@end

@implementation SutrisBag

#pragma mark -
#pragma mark Constants

static int *const SIZE_OF_OCCURANCES = 81;

#pragma mark -
#pragma mark Lifecycle

- (id) init
{
    self = [super init];
    
    if (self) {
        // Initialize variables.
        occurances = [[NSMutableArray alloc]initWithCapacity: SIZE_OF_OCCURANCES];
        
        // Set all the values in the array.
        for (int i = 0 ; i < SIZE_OF_OCCURANCES ; i++) {
            occurances[i] = [[SutrisBool alloc] initWithValue: YES];
        }
    }
    return self;
}

#pragma mark -
#pragma mark User Methods

- (NSUInteger *) pullNumberFromBag
{    
    // Pick a number between 0 and 80, and see if it's valid.
    // TODO: There's an infinite loop here when the array is full of NO.
    int drawn;
    SutrisBool *chosen;
    do {
        drawn = arc4random() % 80;
        chosen = occurances[drawn];
    } while (![chosen value]);
    
    // Set the chosen SutrisBool to false.
    [chosen setValue: NO];
    
    return (drawn % 9) + 1;
}

/*- (NSUInteger *) pullSpecificNumberFromBag: (int) request
{
    // First, we need to create an array of valid numbers that we can pick from.
    
    // TODO: Make a dictionary of valid numbers.
    
}*/

@end

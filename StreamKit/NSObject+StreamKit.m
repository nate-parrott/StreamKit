//
//  NSObject+StreamKit.m
//  StreamKit
//
//  Created by Nate Parrott on 12/25/13.
//  Copyright (c) 2013 Nate Parrott. All rights reserved.
//

#import "NSObject+StreamKit.h"
#import "StreamKit.h"

@implementation NSObject (StreamKit)

-(SKGenerator*)generator {
    NSAssert([self conformsToProtocol:@protocol(NSFastEnumeration)], @"You tried to call -generator on '%@', which doesn't implement NSFastEnumeration (i.e. it doesn't support for..in syntax)", self);
    id<NSFastEnumeration> thisEnumeratableObject = (id)self;
    // NSFastEnumeration client code liberally plagiarized from https://www.mikeash.com/pyblog/friday-qa-2010-04-16-implementing-fast-enumeration.html
    NSMutableData* fastEnumState = [NSMutableData dataWithLength:sizeof(NSFastEnumerationState)];
    NSMutableArray* itemBuffer = [NSMutableArray new]; // we can't tell classes to only return one object, so we need some place to store extra objects until we can return them from the generator
    return [SKGenerator generatorWithBlock:^id(SKGenerator *generator) {
        if (itemBuffer.count==0) { // try to fill the buffer:
            NSFastEnumerationState* state = [fastEnumState mutableBytes];
            __unsafe_unretained id stackbuffer[16];
            state->itemsPtr = stackbuffer;
            NSUInteger count = [thisEnumeratableObject countByEnumeratingWithState:state objects:stackbuffer count:16];
            for (int i=0; i<count; i++) {
                [itemBuffer addObject:state->itemsPtr[i]];
            }
        }
        if (itemBuffer.count==0) {
            return nil;
        } else {
            id first = itemBuffer.firstObject;
            [itemBuffer removeObjectAtIndex:0];
            return first;
        }
    }];
}

-(SKGenerator*)mapFilter:(id(^)(id object))function {
    return [SKGenerator generatorWithInitialState:[self generator] block:^id(SKGenerator *generator) {
        id obj;
        while (obj = [generator.state nextObject]) {
            id mapped = function(obj);
            if (mapped) {
                return mapped;
            } // else: it's been filtered out
        }
        // we've reached the end:
        return nil;
    }];
}

-(id)fold:(id(^)(id left, id right))function {
    SKGenerator* g = [self generator];
    id value = [g nextObject];
    id next;
    while ((next = [g nextObject])) {
        value = function(value, next);
    }
    return value;
}

@end

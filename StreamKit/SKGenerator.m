//
//  SKGenerator.m
//  StreamKit
//
//  Created by Nate Parrott on 12/25/13.
//  Copyright (c) 2013 Nate Parrott. All rights reserved.
//

#import "SKGenerator.h"

@implementation SKGenerator

+(instancetype)generatorWithBlock:(id(^)(SKGenerator* generator))block {
    return [[SKGenerator alloc] initWithBlock:block];
}
+(instancetype)generatorWithInitialState:(id)state block:(id(^)(SKGenerator* generator))block {
    SKGenerator* g = [self generatorWithBlock:block];
    g.state = state;
    return g;
}
-(id)initWithBlock:(id(^)(SKGenerator* generator))block {
    self = [super init];
    _block = block;
    return self;
}
-(id)nextObject {
    return _block(self);
}
-(NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state objects:(__unsafe_unretained id [])buffer count:(NSUInteger)len {
    state->mutationsPtr = (__bridge void*)self;
    NSUInteger count = 0;
    id next = nil;
    while (count < len && (next = [self nextObject])) {
        buffer[count++] = next;
    }
    state->itemsPtr = buffer;
    return count;
}
-(NSArray*)allObjects {
    NSMutableArray* objects = [NSMutableArray new];
    id next = nil;
    while ((next = [self nextObject])) {
        [objects addObject:next];
    }
    return objects;
}

@end

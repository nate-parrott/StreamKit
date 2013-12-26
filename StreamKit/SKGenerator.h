//
//  SKGenerator.h
//  StreamKit
//
//  Created by Nate Parrott on 12/25/13.
//  Copyright (c) 2013 Nate Parrott. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SKGenerator : NSEnumerator {
    id (^_block)(SKGenerator* generator);
}

+(instancetype)generatorWithBlock:(id(^)(SKGenerator* generator))block;
+(instancetype)generatorWithInitialState:(id)state block:(id(^)(SKGenerator* generator))block;

// possible future direction:
// +(instancetype)generatorWithFastEnumerationBlock:(id(^)(SKGenerator* generator, __unsafe_unretained id buffer[], int max, int *count))block;

// 'state' can be used by the block function:
@property(strong)id state;

@end

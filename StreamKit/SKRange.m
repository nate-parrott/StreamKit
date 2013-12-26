//
//  SKRange.m
//  StreamKit
//
//  Created by Nate Parrott on 12/26/13.
//  Copyright (c) 2013 Nate Parrott. All rights reserved.
//

#import "StreamKit.h"

SKGenerator* SKRange(NSUInteger start, NSUInteger end) {
    __block NSUInteger i = start;
    return [SKGenerator generatorWithBlock:^id(SKGenerator *generator) {
        return i >= end? nil : @(i++);
    }];
}

SKGenerator* SKEndless() {
    __block NSUInteger i = 0;
    return [SKGenerator generatorWithBlock:^id(SKGenerator *generator) {
        return @(i++);
    }];
}

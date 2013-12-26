//
//  NSObject+StreamKit.h
//  StreamKit
//
//  Created by Nate Parrott on 12/25/13.
//  Copyright (c) 2013 Nate Parrott. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SKGenerator;

/*
 The following methods REQUIRE that the object implement NSFastEnumeration.
 */

@interface NSObject (StreamKit)

-(SKGenerator*)generator; // makes an NSFastEnumeration-compliant object from a generator

-(SKGenerator*)mapFilter:(id(^)(id object))function; // maps over an NSFastEnumeration-compliant object. return nil from the map function to remove that object from the stream entirely

-(id)fold:(id(^)(id left, id right))function;

@end

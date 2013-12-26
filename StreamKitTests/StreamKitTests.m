//
//  StreamKitTests.m
//  StreamKitTests
//
//  Created by Nate Parrott on 12/25/13.
//  Copyright (c) 2013 Nate Parrott. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "StreamKit.h"

@interface StreamKitTests : XCTestCase

@end

@implementation StreamKitTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample
{
    XCTAssert(1 == 1, @"1 != 1");
}

-(void)testGenerator {
    // this generator counts down to zero, then quit
    SKGenerator* g = [SKGenerator generatorWithInitialState:@5 block:^id(SKGenerator *generator) {
        int val = [generator.state integerValue];
        if (val < 0) {
            return nil;
        } else {
            generator.state = @(val-1);
            return @(val);
        }
    }];
    XCTAssertEqualObjects([g nextObject], @5, @"");
    XCTAssertEqualObjects([g nextObject], @4, @"");
    NSArray* rest = @[@3, @2, @1, @0];
    XCTAssertEqualObjects([g allObjects], rest, @"");
    
    // test fast enumeration:
    SKGenerator* g2 = [SKGenerator generatorWithInitialState:@"abcdef" block:^id(SKGenerator *generator) {
        if ([generator.state length]==0) {
            return nil;
        } else {
            NSString* firstLetter = [generator.state substringToIndex:1];
            generator.state = [generator.state substringFromIndex:1];
            return firstLetter;
        }
    }];
    NSMutableString* s = [NSMutableString new];
    for (id letter in g2) {
        [s appendString:letter];
    }
    XCTAssertEqualObjects(s, @"abcdef", @"");
}

-(void)testGeneratorFromEnumerator {
    NSArray* list = @[@"A", @"B", @"C"];
    NSArray* result = [[list generator] allObjects];
    XCTAssertEqualObjects(list, result, @"");
    
    // let's go super meta and build a generator from a generator from a generator:
    NSArray* original = @[@1, @2, @3, @4, @5];
    NSArray* metaResult = [[[[original generator] generator] generator] allObjects];
    XCTAssertEqualObjects(original, metaResult, @"");
}

-(void)testSKRange {
    NSArray* range = @[@12, @13, @14];
    XCTAssertEqualObjects(range, [SKRange(12, 15) allObjects], @"");
    
    SKGenerator* endless = SKEndless();
    XCTAssertEqualObjects([endless nextObject], @0, @"");
    XCTAssertEqualObjects([endless nextObject], @1, @"");
}

-(void)testMapFilter {
    // simple:
    NSArray* n = @[@(-2), @(-3), @(-4)];
    XCTAssertEqualObjects(n, [[SKRange(2, 5) mapFilter:^id(id object) {
        return @(-[object integerValue]);
    }] allObjects], @"");
    // simple filter:
    NSArray* odds = @[@1, @3, @5];
    XCTAssertEqualObjects(odds, [[SKRange(0, 6) mapFilter:^id(id object) {
        return ([object integerValue]%2)? object : nil;
    }] allObjects], @"");
}

-(void)testFold {
    // sum:
    NSArray* nums = @[@1, @2, @3];
    XCTAssertEqualObjects(@6, [nums fold:^id(id left, id right) {
        return @([left integerValue] + [right integerValue]);
    }], @"");
}

@end

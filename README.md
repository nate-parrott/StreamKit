# StreamKit

StreamKit lets you map, filter and fold over collections or arbitrary generators in Objective-C.

For example, concise mapping arrays is simple:

    NSArray* words = @[@"a", @"few", @"words"];
    id uppercased = [words mapFilter:^(id word) {return [word uppercaseString];}];
    for (NSString* word in uppercased) { NSLog(word); }

prints:

    A
    FEW
    WORDS

Filtering is just as simple: just return `nil` from the `mapFilter` method:

    NSArray* nums = @[@1, @2, @3, @4, @5];
    id oddNums = [nums mapFilter:^(id num) {
        return ([num integerValue]%2 == 1)? num : nil;
    }];
    for (NSNumber* num in oddNums) { NSLog(@"%i", [num integerValue); }

prints:

    1
    3
    5

`-mapFilter:` actually returns an `SKGenerator` object. They're sort of like `NSEnumerator` objects, or generators in Python. They hold a potentially infinite set of objects, which you can get at by calling their `-nextObject` method. (if they aren't infinite, they'll return `nil` eventually.)

Let's construct an infinite generator that counts numbers from 0 to infinity:

    __block i = 0;
    SKGenerator* endless = [SKGenerator generatorWithBlock:^(SKGenerator* generator) {
        return @(i++);
    }];

If we repeatedly call `[counter nextObject]`, we'll get 0, followed by 1, then 2, etc., forever.

A function to make this kind of generator is part of StreamKit. It's called `SKEndless()`, and let's use it to find the first number that's divisible by 2 and 7:

    for (NSNumber* i in SKEndless()) {
        if (i.intValue > 0 && i.intValue%2 == 0 && i.intValue%7 == 0) {
            NSLog(@"%i", i.intValue);
            break; // otherwise we'll continue forever.
        }
    }

What if we want to print out *all* the numbers divisible by 2 and 7 (or at least the first few thousand). We can make a generator that does it, by filtering that endless generator:

    SKGenerator* coolNumbers = [SKEndless() mapFilter:^(id i) {
        if (i.intValue > 0 && i.intValue%2 == 0 && i.intValue%7 == 0) {
            return i;
        } else {
            return nil;
        }
    }];


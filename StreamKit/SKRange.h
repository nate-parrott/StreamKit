//
//  SKRange.h
//  StreamKit
//
//  Created by Nate Parrott on 12/26/13.
//  Copyright (c) 2013 Nate Parrott. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SKGenerator;

SKGenerator* SKRange(NSUInteger start, NSUInteger end); // returns a generator from [start .. end-1], like the Python xrange() function

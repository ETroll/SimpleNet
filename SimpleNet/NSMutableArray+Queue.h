//
//  NSMutableArray+Queue.h
//  SimpleNet
//
//  Created by Karl Løland on 8/2/11.
//  Copyright 2011 Karl Syvert Løland. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableArray (QueueAdditions)
- (id) dequeue;
- (void) enqueue:(id)obj;
@end

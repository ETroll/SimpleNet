//
//  TestAppAppDelegate.h
//  TestApp
//
//  Created by Karl Løland on 8/4/11.
//  Copyright 2011 Altinett AS. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface TestAppAppDelegate : NSObject <NSApplicationDelegate> {
    NSWindow *_window;
}

@property (strong) IBOutlet NSWindow *window;

@end

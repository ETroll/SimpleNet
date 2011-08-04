//
//  SNNetwork.h
//  SimpleNet
//
//  Created by Karl Løland on 8/2/11.
//  Copyright 2011 Karl Syvert Løland. All rights reserved.
//

#import <Foundation/Foundation.h>


@class SNNetwork;

@protocol SNNetworkConnectionDelegate <NSObject>

@optional
- (void) didRecievePackage;
- (void) didFinishSendingPackage: (int) PackageID;
@required

@end

@interface SNNetwork : NSObject {
    id <SNNetworkConnectionDelegate> delegate;
}


@property (assign) id <SNNetworkConnectionDelegate> delegate;
@end

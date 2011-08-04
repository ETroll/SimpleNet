//
//  SNSocket.h
//  SimpleNet
//
//  Created by Karl Løland on 8/2/11.
//  Copyright 2011 Karl Syvert Løland. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SNSocket : NSObject {
    BOOL isRunning;
}
@property BOOL isRunning;

/*
unsigned int 	Socket_IsRunning(Socket* soc);

Socket*			Socket_CreateSocket();
unsigned int	Socket_Bind(Socket* soc, int nPort);
unsigned int	Socket_Listen(Socket* soc);
unsigned int	Socket_Accept(Socket* soc, int *fdToNewClient);
unsigned int	Socket_Connect(Socket* soc, char *chServer, int nPort);
void 			Socket_Disconnect(Socket* soc);

int 			Socket_Send(const Package* pPkg);
Package*		Socket_Receive(int fdRecieveFrom);
*/
@end

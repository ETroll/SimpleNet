//
//  SNSocket.h
//  SimpleNet
//
//  Created by Karl Løland on 8/2/11.
//  Copyright 2011 Karl Syvert Løland. All rights reserved.
//

#import <Foundation/Foundation.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <netdb.h>

#import "SNPackage.h"

@interface SNSocket : NSObject {
    BOOL isConnected;
    int port;
    
    @private
    int socketDescriptor;
    int maxPackageSize;
    int maxClients;
    int maxNetworkChunk;
}
@property (readonly) BOOL isConnected;
@property (readonly) int port;

/*
 
OLD v1.1 API:

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


- (BOOL) BindOnPort: (int) port;
- (BOOL) Listen;
- (BOOL) AcceptNewClient: (int*) fdToNewClient;
- (BOOL) ConnectoToServer: (NSString*) server onPort: (int) port;
- (void) Disconnect;
- (int) SendPackage: (SNPackage*) package;
- (SNPackage*) ReceivePackageFrom: (int) sender;


@end

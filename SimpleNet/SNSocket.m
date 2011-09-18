//
//  SNSocket.m
//  SimpleNet
//
//  Created by Karl Løland on 8/2/11.
//  Copyright 2011 Karl Syvert Løland. All rights reserved.
//

#import "SNSocket.h"

@implementation SNSocket

@synthesize isConnected;
@synthesize port;

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
        socketDescriptor = socket(PF_INET, SOCK_STREAM,0);
        isConnected = NO;
        port = -1;
    }
    
    return self;
}

- (BOOL) BindOnPort: (int) p {
    if(socketDescriptor != -1) {
        struct sockaddr_in my_addr;
		memset(&my_addr,0,sizeof(struct sockaddr_in));
		my_addr.sin_family = AF_INET;
		my_addr.sin_port = htons(p);
		my_addr.sin_addr.s_addr = htons(INADDR_ANY);
        port = p;
        
		if(bind(socketDescriptor,(struct sockaddr*)&my_addr, sizeof(struct sockaddr)) != -1) {
			return YES;
		}else {
			return NO;
		}
    }else {
        return NO;
    }
}
- (BOOL) Listen {
    if(socketDescriptor != -1) {
		//Setting the maximum length that the queue of pending connections may grow to 32
		if(listen(socketDescriptor, 32) == 0) {
			isConnected = YES;
		}
        return isConnected;
	}else {
        return NO;
	}
}
- (BOOL) AcceptNewClient: (int*) fdToNewClient {
    if(socketDescriptor != -1) {
		struct sockaddr_in client_addr;
		int nClientSize = sizeof(client_addr);
        
		*fdToNewClient = accept(socketDescriptor,(struct sockaddr*)&client_addr, (socklen_t*)&nClientSize);
        
		if(*fdToNewClient == -1) {
			return NO;
		}else {
			return YES;
		}
	}else {
        return NO;
	}
}
- (BOOL) ConnectoToServer: (NSString*) server onPort: (int) p {
    if(socketDescriptor != -1) {
		struct sockaddr_in saServerAdress;
		struct hostent *pHost;
        
		memset(&saServerAdress,0,sizeof(struct sockaddr_in));
		saServerAdress.sin_port = htons(p);
		saServerAdress.sin_family = AF_INET;
		saServerAdress.sin_addr.s_addr = inet_addr([server UTF8String]);
        
		if(saServerAdress.sin_addr.s_addr == INADDR_NONE) {
			pHost = gethostbyname([server UTF8String]);
			if(pHost != NULL) {
				saServerAdress.sin_addr.s_addr = ((struct in_addr*)pHost->h_addr)->s_addr;
			}else {
				return NO;
			}
		}
        
		if(connect(socketDescriptor, (struct sockaddr*)&saServerAdress, sizeof(struct sockaddr)) != -1) {
			isConnected = YES;
			return YES;
		}else {
			[self Disconnect];
            return NO;
		}
	}else {
        return NO;
	}
}
- (void) Disconnect {
    if(socketDescriptor != -1) {
        shutdown(socketDescriptor, SHUT_RDWR); //Maybe not really neccesary..
        close(socketDescriptor);
        isConnected = NO;
	}
}
- (int) SendPackage: (SNPackage*) package {
    unsigned int nSendt = 0;
	int n = 0;
	unsigned char checkBytes[5] = {0x01,0x02,0x03,0x04,0x05};
	unsigned int headerSize = (sizeof(unsigned int)*2) + sizeof(SimplePackage_Type) + 5;
	//int nSize = sizeof(Package) + pPkg->nLength + 5; //5 Checkbytes
	int nSize = headerSize + pPkg->nLength;
	
	if(nSize<= maxPackageSize) {
        
		//Serialize the data
		char* sendBuffer = (char*)malloc(nSize);
		memset(sendBuffer,0,nSize);
		//Serialized data structure:
		//[3 chkbytes,nLength,nType,nDestination,nSender, 2 chkbytes, pData]
		unsigned int tmpCounter = 0;
		memcpy(sendBuffer + tmpCounter,checkBytes,3);
		tmpCounter += 3;
		memcpy(sendBuffer + tmpCounter ,&pPkg->nLength,sizeof(unsigned int));
		tmpCounter += sizeof(unsigned int);
		memcpy(sendBuffer + tmpCounter ,&pPkg->nType,sizeof(SimplePackage_Type));
		tmpCounter += sizeof(SimplePackage_Type);
		memcpy(sendBuffer + tmpCounter ,&pPkg->nSender,sizeof(unsigned int));
		tmpCounter += sizeof(unsigned int);
		memcpy(sendBuffer + tmpCounter ,checkBytes+3,2);
		tmpCounter += 2;
		memcpy(sendBuffer + tmpCounter,pPkg->pData,pPkg->nLength);
        
        
        
		//Send the data
		while(nSendt < nSize) {
			if((nSize-nSendt) > SIMPLENET_MAX_NET) {
				n = send(pPkg->nDestination, sendBuffer+nSendt, MAX_NET,0);
			}else {
				n = send(pPkg->nDestination, sendBuffer+nSendt, nSize-nSendt, 0);
			}
			if(n == -1) {
				//An error happened, return gracefully.
				free(sendBuffer);
				return -1;
			}else {
				nSendt+=n;
			}
		}
		free(sendBuffer);
		return nSendt;
	}
	else {
		//Package was bigger than MAX_PACKAGE, could not send.
		return -1;
	}
}
- (SNPackage*) ReceivePackageFrom: (int) sender {
    
}

@end

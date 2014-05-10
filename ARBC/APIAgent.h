//
//  APIAgent.h
//  Jestr
//
//  Created by Árpád Kiss on 2014.04.27..
//  Copyright (c) 2014 Peabo Media LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking/AFNetworking.h"

@interface APIAgent : NSObject

+(APIAgent*) sharedAgent;

@property (nonatomic, readonly) NSString *apiURL;

-(void)postToEndpoint:(NSString*)endpoint
           withParams:(NSDictionary*)parameters
            onSuccess:(void(^)(id responseObject))successBlock
               onFail:(void(^)(NSError *error))failBlock;

-(void)getFromEndpoint:(NSString*)endpoint
            onSuccess:(void(^)(id responseObject))successBlock
               onFail:(void(^)(NSError *error))failBlock;

-(void)postToEndpoint:(NSString*)endpoint
           withParams:(NSDictionary*)parameters
            withImage:(UIImage *)image
              andName:(NSString *)name
            onSuccess: (void(^)(id responseObject))successBlock
               onFail: (void(^)(NSError *error))failBlock;
@end

//
//  APIAgent.m
//  Jestr
//
//  Created by Árpád Kiss on 2014.04.27..
//  Copyright (c) 2014 Peabo Media LLC. All rights reserved.
//

#import "APIAgent.h"

@implementation APIAgent {
    AFHTTPRequestOperationManager *_manager;
    NSString *_apiURL;
}

-(id)init{
    if(self = [super init]) {
        _apiURL = @"http://arbc.arpi.im";
        _manager = [AFHTTPRequestOperationManager manager];
        [_manager setRequestSerializer:[AFJSONRequestSerializer serializer]];
        [_manager setResponseSerializer:[AFJSONResponseSerializer serializer]];
    }
    return self;
}

-(void)postToEndpoint:(NSString*)endpoint
           withParams:(NSDictionary*)parameters
            onSuccess: (void(^)(id responseObject))successBlock
               onFail: (void(^)(NSError *error))failBlock {
    
    NSLog(@"%@",parameters.description);
    
    [_manager POST:[NSString stringWithFormat:@"%@/%@", _apiURL, endpoint] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        id json = [responseObject objectForKey:@"data"];
        
        if(!json) {
            NSLog(@"%@",operation.description);
            failBlock(responseObject);
        }
        
        successBlock(json);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",operation.description);
        failBlock(error);
    }];
}
-(void)postToEndpoint:(NSString*)endpoint
           withParams:(NSDictionary*)parameters
            withImage:(UIImage *)image
              andName:(NSString *)name
            onSuccess: (void(^)(id responseObject))successBlock
               onFail: (void(^)(NSError *error))failBlock {
    
    NSData *imageData = UIImageJPEGRepresentation(image, 1);
    
    NSString *fileName = [NSString stringWithFormat:@"%ld%c%c.jpg", (long)[[NSDate date] timeIntervalSince1970], arc4random_uniform(26) + 'a', arc4random_uniform(26) + 'a'];
    
    [_manager POST:[NSString stringWithFormat:@"%@/%@", _apiURL, endpoint]
        parameters:parameters
constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
    [formData appendPartWithFileData:imageData name:name fileName:fileName mimeType:@"image/jpeg"];
    }
           success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        id json = [responseObject objectForKey:@"data"];
        
               if([json isEqual: nil]) {
            NSLog(@"%@",operation.description);
            failBlock(nil);
        }
        
        successBlock(json);
        
    }
           failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",operation.description);
        failBlock(error);
    }];
    
}


-(void)getFromEndpoint:(NSString*)endpoint
             onSuccess:(void(^)(id responseObject))successBlock
                onFail:(void(^)(NSError *error))failBlock {
    
    NSLog(@"GET......");
    
    [_manager GET:[NSString stringWithFormat:@"%@/%@", _apiURL, endpoint] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        id json = [responseObject objectForKey:@"data"];
        
        if([json isEqual:nil]) {
            NSLog(@"%@",operation.description);
            failBlock(nil);
        }
        
        successBlock(json);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",operation.description);
        failBlock(error);
    }];
    
}

// singleton declaration

+(APIAgent*) sharedAgent {
    static id _sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[self alloc] init];
    });
    return _sharedInstance;
}

@end

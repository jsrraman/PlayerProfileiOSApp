//
//  PlayerProfileHTTPClient.m
//  PlayerProfile
//
//  Created by Rajaraman on 26/02/15.
//  Copyright (c) 2015 Rajaraman. All rights reserved.
//

#import "PlayerProfileApiDataProvider.h"
#import "AFHTTPSessionManager.h"

@implementation PlayerProfileApiDataProvider

// Create a singleton instance
+ (PlayerProfileApiDataProvider *)getInstance {
    
    static PlayerProfileApiDataProvider *playerProfileHTTPClient = nil;
    
    static dispatch_once_t onceToken;
    
    // This makes sure this is executed only once
    dispatch_once(&onceToken, ^{
        playerProfileHTTPClient = [[self alloc] initWithBaseURL:[NSURL URLWithString:PlayerProfileWebServicesBaseUrl]];
    });
    
    return playerProfileHTTPClient;
}

- (instancetype) initWithBaseURL:(NSURL *)url {
    
    self = [super initWithBaseURL:url];
    
    if (self) {
        self.requestSerializer = [AFJSONRequestSerializer serializer];
        self.responseSerializer = [AFJSONResponseSerializer serializer];
    }
    
    return self;
}

- (void)getCountryList {
 
    // Construct the actual URL string
    //NSString *actualUrlString = [NSString stringWithFormat:@"%@weather.php?format=json", BaseURLString];
    NSString *actualUrlString = [NSString stringWithFormat:@"%@%@", PlayerProfileWebServicesBaseUrl, getCountryListUrl];

    // Try getting the country list and based on the response call the delegate methods in the registrar
    [self GET:actualUrlString parameters:nil
            success: ^(NSURLSessionDataTask *task, id responseObject) {
                [self.delegate playerProfileApiDataProvider:self didSucceed:responseObject];
            }

            failure: ^(NSURLSessionDataTask *task, NSError *error) {
                [self.delegate playerProfileApiDataProvider:self didFailWithError:error];
            }];
}

@end
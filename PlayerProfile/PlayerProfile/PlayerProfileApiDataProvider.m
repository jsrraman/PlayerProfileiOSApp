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
    NSString *fullUrlString = [NSString stringWithFormat:@"%@%@", PlayerProfileWebServicesBaseUrl, getCountryListUrl];

//    // Try getting the country list and based on the response call the delegate methods in the registrar
//    [self GET:fullUrlString parameters:nil
//            success: ^(NSURLSessionDataTask *task, id responseObject) {
//                [self.delegate playerProfileAPIType:PlayerProfileApiGetCountryList didSucceed:responseObject];
//            }
//
//            failure: ^(NSURLSessionDataTask *task, NSError *error) {
//                [self.delegate didFailWithError:error];
//            }];
    
    [self getApiResponse:fullUrlString forPlayerProfileApiType:PlayerProfileApiGetCountryList];
}

- (void)getPlayerListForCountryId:(int)countryId {
    
    NSMutableString *fullUrlString = [NSMutableString stringWithFormat:@"%@%@", PlayerProfileWebServicesBaseUrl, getPlayerListUrl];
    [fullUrlString appendFormat:@"%d", countryId];
    
//    // Try getting the player list and based on the response call the delegate methods in the registrar
//    [self GET:fullUrlString parameters:nil
//      success: ^(NSURLSessionDataTask *task, id responseObject) {
//          [self.delegate playerProfileAPIType:PlayerProfileApiGetPlayerListForCountry didSucceed:responseObject];
//      }
//     
//      failure: ^(NSURLSessionDataTask *task, NSError *error) {
//          [self.delegate didFailWithError:error];
//      }];
    
    [self getApiResponse:fullUrlString forPlayerProfileApiType:PlayerProfileApiGetPlayerListForCountry];
}

- (void)scrapePlayerListForCountryId:(int)countryId forCountryName:(NSString *)countryName {
    
    NSMutableString *fullUrlString = [NSMutableString stringWithFormat:@"%@%@", PlayerProfileWebServicesBaseUrl, scrapePlayerListUrlPart1];
    [fullUrlString appendFormat:@"%d", countryId];
    [fullUrlString appendString:@"&"];
    [fullUrlString appendString:scrapePlayerListUrlPart2];
    [fullUrlString appendString:countryName];
    
    [self getApiResponse:fullUrlString forPlayerProfileApiType:PlayerProfileApiScrapePlayerListForCountry];
}

- (void) getApiResponse:(NSString *)fullUrlString forPlayerProfileApiType:(PlayerProfileApiType)apiType {
    
    // Try hitting the web services end point
    [self GET:fullUrlString parameters:nil
      success: ^(NSURLSessionDataTask *task, id responseObject) {
          [self.delegate playerProfileApiType:apiType didSucceed:responseObject];
      }
     
      failure: ^(NSURLSessionDataTask *task, NSError *error) {
          [self.delegate didFailWithError:error];
      }];
}

@end
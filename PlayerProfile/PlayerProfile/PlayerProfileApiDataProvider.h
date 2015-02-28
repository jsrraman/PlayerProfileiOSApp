//
//  PlayerProfileHTTPClient.h
//  PlayerProfile
//
//  Created by Rajaraman on 26/02/15.
//  Copyright (c) 2015 Rajaraman. All rights reserved.
//

#import "AFHTTPSessionManager.h"

static NSString* const PlayerProfileWebServicesBaseUrl = @"http://10.0.0.114:3000";
static NSString* const getCountryListUrl = @"/players/countries";
static NSString* const getPlayerListUrl = @"/players/country?countryId=";

static NSString* const scrapePlayerListUrlPart1 = @"/scrape/players/country?countryId=";
static NSString* const scrapePlayerListUrlPart2 = @"&name=";

// API list
typedef NS_ENUM(NSInteger, PlayerProfileApiType) {
    PlayerProfileApiGetCountryList,
    PlayerProfileApiScrapeCountryList,
    PlayerProfileApiGetPlayerListForCountry,
    PlayerProfileApiScrapePlayerListForCountry,
    PlayerProfileApiScrapePlayerProfileForPlayerID,
    PlayerProfileApiGetPlayerProfileForPlayerID
};

@protocol PlayerProfileApiDataProviderDelegate;

@interface PlayerProfileApiDataProvider : AFHTTPSessionManager

@property (nonatomic, weak) id <PlayerProfileApiDataProviderDelegate>delegate;

+ (PlayerProfileApiDataProvider *)getInstance;
- (instancetype)initWithBaseURL:(NSURL *)url;
- (void)getCountryList;
- (void)getPlayerListForCountryId:(int)countryId;
- (void)scrapePlayerListForCountryId:(int)countryId forCountryName:(NSString *)countryName;

@end

@protocol PlayerProfileApiDataProviderDelegate <NSObject>

-(void) playerProfileApiType:(PlayerProfileApiType)apiType didSucceed:(id)data;
-(void) didFailWithError:(NSError *)error;

@end
//
//  PlayerProfileHTTPClient.h
//  PlayerProfile
//
//  Created by Rajaraman on 26/02/15.
//  Copyright (c) 2015 Rajaraman. All rights reserved.
//

#import "AFHTTPSessionManager.h"

static NSString* const PlayerProfileWebServicesBaseUrl = @"http://192.168.1.102:3000";
static NSString* const getCountryListUrl = @"/players/countries";
static NSString* const getPlayerListUrl = @"/players/country?countryId=";
static NSString* const scrapePlayerListUrlPart1 = @"/scrape/players/country?countryId=";
static NSString* const scrapePlayerListUrlPart2 = @"&name=";
static NSString* const getPlayerProfileUrl = @"/players?playerId=";
static NSString* const scrapePlayerProfileUrl = @"/scrape/player?playerId=";

// API list
typedef NS_ENUM(NSInteger, PlayerProfileApiType) {
    PlayerProfileApiGetCountryList,
    PlayerProfileApiScrapeCountryList,
    PlayerProfileApiGetPlayerListForCountry,
    PlayerProfileApiScrapePlayerListForCountry,
    PlayerProfileApiScrapePlayerProfileForPlayerId,
    PlayerProfileApiGetPlayerProfileForPlayerId
};

@protocol PlayerProfileApiDataProviderDelegate;

@interface PlayerProfileApiDataProvider : AFHTTPSessionManager

@property (nonatomic, weak) id <PlayerProfileApiDataProviderDelegate>delegate;

+ (PlayerProfileApiDataProvider *)getInstance;
- (instancetype)initWithBaseURL:(NSURL *)url;
- (void)getCountryList;
- (void)getPlayerListForCountryId:(int)countryId;
- (void)scrapePlayerListForCountryId:(int)countryId forCountryName:(NSString *)countryName;
- (void)getPlayerProfileForPlayerId:(int)playerId;
- (void)scrapePlayerProfileForPlayerId:(int)playerId;

@end

@protocol PlayerProfileApiDataProviderDelegate <NSObject>

-(void) playerProfileApiType:(PlayerProfileApiType)apiType didSucceed:(id)data;
-(void) didFailWithError:(NSError *)error;

@end
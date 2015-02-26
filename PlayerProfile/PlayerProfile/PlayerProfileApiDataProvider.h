//
//  PlayerProfileHTTPClient.h
//  PlayerProfile
//
//  Created by Rajaraman on 26/02/15.
//  Copyright (c) 2015 Rajaraman. All rights reserved.
//

#import "AFHTTPSessionManager.h"

static NSString* const BaseURLString = @"http://www.raywenderlich.com/demos/weather_sample/";
static NSString* const PlayerProfileWebServicesBaseUrl = @"http://10.0.0.114:3000";
static NSString* const getCountryListUrl = @"/players/countries";

@protocol PlayerProfileApiDataProviderDelegate;

@interface PlayerProfileApiDataProvider : AFHTTPSessionManager

@property (nonatomic, weak) id <PlayerProfileApiDataProviderDelegate>delegate;

+ (PlayerProfileApiDataProvider *)getInstance;
- (instancetype)initWithBaseURL:(NSURL *)url;
- (void)getCountryList;

@end

@protocol PlayerProfileApiDataProviderDelegate <NSObject>

-(void) playerProfileApiDataProvider:(PlayerProfileApiDataProvider *)dataProvider didSucceed:(id)data;
-(void) playerProfileApiDataProvider:(PlayerProfileApiDataProvider *)dataProvider didFailWithError:(NSError *)error;

@end
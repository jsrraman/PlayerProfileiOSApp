//
//  Country.h
//  PlayerProfile
//
//  Created by Rajaraman on 26/02/15.
//  Copyright (c) 2015 Rajaraman. All rights reserved.
//

#import "JSONModel.h"

@protocol PlayerModel
@end

@interface PlayerModel : JSONModel

@property (nonatomic, assign) int countryId;
@property (nonatomic, assign) int playerId;
@property (nonatomic, strong) NSString* playerUrl;
@property (nonatomic, strong) NSString* name;
@property (nonatomic, strong) NSString<Optional>* thumbnailUrl;

@end
//
//  CountryListWSJSONRespModel.h
//  PlayerProfile
//
//  Created by Rajaraman on 26/02/15.
//  Copyright (c) 2015 Rajaraman. All rights reserved.
//

#import "JSONModel.h"
#import "PlayerModel.h"

@interface PlayerListWSJSONRespModel : JSONModel

@property (nonatomic, strong) NSString* status;
@property (nonatomic, strong) NSArray<PlayerModel>* result;

@end
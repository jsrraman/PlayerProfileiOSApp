//
//  Country.h
//  PlayerProfile
//
//  Created by Rajaraman on 26/02/15.
//  Copyright (c) 2015 Rajaraman. All rights reserved.
//

#import "JSONModel.h"

@protocol CountryModel
@end

@interface CountryModel : JSONModel

@property (nonatomic, assign) int countryId;
@property (nonatomic, strong) NSString* thumbnailUrl;
@property (nonatomic, strong) NSString* name;

@end

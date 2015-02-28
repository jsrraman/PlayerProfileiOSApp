//
//  CountryListWSJSONRespModel.h
//  PlayerProfile
//
//  Created by Rajaraman on 26/02/15.
//  Copyright (c) 2015 Rajaraman. All rights reserved.
//

#import "JSONModel.h"
#import "CountryModel.h"

@interface CountryListWSJSONRespModel : JSONModel

@property (nonatomic, strong) NSString* status;
@property (nonatomic, strong) NSArray<CountryModel>* result;

@end
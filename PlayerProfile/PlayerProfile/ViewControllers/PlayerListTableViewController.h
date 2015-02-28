//
//  PlayerListTableViewController.h
//  PlayerProfile
//
//  Created by Rajaraman on 25/02/15.
//  Copyright (c) 2015 Rajaraman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlayerProfileApiDataProvider.h"
#import "CountryModel.h"

@interface PlayerListTableViewController : UITableViewController <PlayerProfileApiDataProviderDelegate>
@property(nonatomic, strong) CountryModel *selCountryModel;
@end
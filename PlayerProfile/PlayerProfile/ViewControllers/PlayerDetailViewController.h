//
//  PlayerDetailViewController.h
//  PlayerProfile
//
//  Created by Rajaraman on 01/03/15.
//  Copyright (c) 2015 Rajaraman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlayerModel.h"
#import "PlayerProfileApiDataProvider.h"

@interface PlayerDetailViewController : UIViewController <PlayerProfileApiDataProviderDelegate>
@property(nonatomic, strong) PlayerModel *playerModel;
@end

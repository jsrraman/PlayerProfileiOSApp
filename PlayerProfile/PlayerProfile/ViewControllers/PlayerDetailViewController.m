//
//  PlayerDetailViewController.m
//  PlayerProfile
//
//  Created by Rajaraman on 01/03/15.
//  Copyright (c) 2015 Rajaraman. All rights reserved.
//

#import "PlayerDetailViewController.h"
#import "PlayerListWSJSONRespModel.h"
#import "ImageUtility.h"
#import "UIImageView+AFNetworking.h"

@interface PlayerDetailViewController ()
@property (strong, nonatomic) IBOutlet UIImageView *playerThumbnail;
@property (strong, nonatomic) IBOutlet UILabel *name;
@property (strong, nonatomic) IBOutlet UILabel *country;
@property (strong, nonatomic) IBOutlet UILabel *age;
@property (strong, nonatomic) IBOutlet UILabel *battingStyle;
@property (weak, nonatomic) IBOutlet UILabel *bowlingStyle;
@property (strong, nonatomic) PlayerProfileApiDataProvider *playerProfileApiDataProvider;
@end

@implementation PlayerDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //[self.playerThumbnail initWithImage:[UIImage imageNamed:@"placeholder.png"]];
    
    [self getPlayerProfileData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) getPlayerProfileData {
    self.playerProfileApiDataProvider = [PlayerProfileApiDataProvider getInstance];
    self.playerProfileApiDataProvider.delegate = self;
    
    [self.playerProfileApiDataProvider getPlayerProfileForPlayerId:self.playerModel.playerId];
}

-(void) populateUi {
    
    // Set the player thumbail image
    __weak UIImageView *imageView = self.playerThumbnail;
    
    NSURL *url = [NSURL URLWithString:self.playerModel.thumbnailUrl];
    NSURLRequest *imageRequest = [NSURLRequest requestWithURL:url];
    
    // Get the place holder image
    UIImage *placeHolderImage = [UIImage imageNamed:@"placeholder"];
    
    // Resize the image to fit into the UIImage frame width and height
    UIImage *resizedImage = [ImageUtility imageWithImage:placeHolderImage
                                        scaledToMaxWidth:imageView.frame.size.width
                                               maxHeight:imageView.frame.size.height];
    
    [imageView setImageWithURLRequest:imageRequest
                     placeholderImage:resizedImage
                              success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                  
                                  imageView.image = image;
                                  [imageView setNeedsLayout];
                                  
                              } failure:nil];
    
    
    // Set the player name
    self.name.text = [self getDefaultValueForAttribute:self.playerModel.name];
    
    // Country
    self.country.text = [self getDefaultValueForAttribute:self.playerModel.country];
    
    // Age
    self.age.text = [self getDefaultValueForAttribute:self.playerModel.age];
    
    // Batting Style
    self.battingStyle.text = [self getDefaultValueForAttribute:self.playerModel.battingStyle];
    
    // Bowling Style
    self.bowlingStyle.text = [self getDefaultValueForAttribute:self.playerModel.bowlingStyle];
}

-(NSString *) getDefaultValueForAttribute:(NSString *)attribute {
    
    NSString *value = @"NA";
    
    if ([attribute isEqualToString:@""])
        return value;
    else
        return attribute;
}

#pragma mark - PlayerProfileApiDataProvider delegate methods

-(void) playerProfileApiType:(PlayerProfileApiType)apiType didSucceed:(id)data {
    
    if (data == nil)
        return;
    
    switch(apiType) {
            
        case PlayerProfileApiGetPlayerProfileForPlayerId: {
            [self handleGetPlayerProfileApiResponse:data];
            break;
        }
            
        case PlayerProfileApiScrapePlayerProfileForPlayerId: {
            [self handleScrapePlayerProfileApiResponse:data];
            break;
        }
            
        default: {
            NSLog(@"Unexpected API...");
            break;
        }
    }
}

-(void) didFailWithError:(NSError *)error {
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message: [error localizedDescription] delegate:nil
                                              cancelButtonTitle: @"ok" otherButtonTitles:nil, nil];
    [alertView show];
}


// Handle Player profile API response
-(void) handleGetPlayerProfileApiResponse:(id)data {
    
    static BOOL playerProfileScrappedAlready = FALSE;
    
    // Get the data which is already in the dictionary format into CountryListWSJSONRespModel
    PlayerListWSJSONRespModel *playerListWSJSONRespModel = [[PlayerListWSJSONRespModel alloc] initWithDictionary:data error:nil];
    
    if ([playerListWSJSONRespModel.result count] == 0) {
        return;
    }
    
    // We are expecting, the result should have only the requested player profile detail, so get it
    self.playerModel = playerListWSJSONRespModel.result[0];
    
    // If there is no thumbnail available for this player, go scrap the full profile data first else update the view
    if (self.playerModel.thumbnailUrl == nil) {
        
        if (playerProfileScrappedAlready == FALSE) {
            [self.playerProfileApiDataProvider scrapePlayerProfileForPlayerId:self.playerModel.playerId];
        
            // For some players, thumbnail url seem to be not available even after scrapping, so we need to avoid recursive call
            // those cases
            playerProfileScrappedAlready = TRUE;
        }
        else {
            playerProfileScrappedAlready = FALSE;
            [self updateUi];
        }
    } else {
        [self updateUi];
    }
}


// Handle Player list API response
-(void) handleScrapePlayerProfileApiResponse:(id)data {
    [self.playerProfileApiDataProvider getPlayerProfileForPlayerId:self.playerModel.playerId];
}

-(void) updateUi {
    // Update the UI thread asynchronously
    dispatch_async(dispatch_get_main_queue(), ^{
        [self populateUi];
    });
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

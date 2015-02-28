//
//  CountryListTableViewController.m
//  PlayerProfile
//
//  Created by Rajaraman on 25/02/15.
//  Copyright (c) 2015 Rajaraman. All rights reserved.
//

#import "CountryListTableViewController.h"
#import "AFNetworking.h"
#import "UIImageView+AFNetworking.h"
#import "CountryListWSJSONRespModel.h"
#import "PlayerListTableViewController.h"
#import "ImageUtility.h"

@interface CountryListTableViewController ()

@property(nonatomic, strong) NSArray *countryModel;

@end

@implementation CountryListTableViewController

// This will be called multiple times inside cellForRowAtIndexPath: method, so
// keeping it static improves performance
static NSString *cellIdentifier = @"Country";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) initUI {
    // Try getting the country list
    PlayerProfileApiDataProvider *playerProfileApiDataProvider = [PlayerProfileApiDataProvider getInstance];
    playerProfileApiDataProvider.delegate = self;
    
    [playerProfileApiDataProvider getCountryList];
}

#pragma mark - PlayerProfileApiDataProvider delegate methods

-(void) playerProfileApiType:(PlayerProfileApiType)apiType didSucceed:(id)data {
    
    if (data == nil)
        return;
    
    switch(apiType) {
            
        case PlayerProfileApiGetCountryList: {
            [self handleGetCountryListAPIResponse:data];
            break;
        }
            
        case PlayerProfileApiScrapeCountryList: {
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

// Handle Country list API response
-(void) handleGetCountryListAPIResponse:(id)data {
    // Get the data which is already in the dictionary format into CountryListWSJSONRespModel
    CountryListWSJSONRespModel *countryListWSJSONRespModel = [[CountryListWSJSONRespModel alloc] initWithDictionary:data error:nil];
    
    // Get the country list
    self.countryModel = countryListWSJSONRespModel.result;
    
    // Update the UI thread asynchronously
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

// Return the number of rows in the table view
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (!self.countryModel) {
        return 0;
    } else {
        return [self.countryModel count];
    }
}

// Configure the individual table cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
   
    // Get the row object from countryModel array list
    CountryModel *countryModel = self.countryModel[indexPath.row];
    
    // Because this is a custom designed cell, you can no longer use UITableViewCell’s textLabel and detailTextLabel properties
    // to put text into the labels. These properties refer to labels that aren’t on this cell anymore; they are only valid
    // for the standard cell types. Instead, you will use tags to find the labels as below.
    // Country Thumbnail URL
    __weak UIImageView *imageView = (UIImageView *)[cell viewWithTag:100];
    
    NSURL *url = [NSURL URLWithString:countryModel.thumbnailUrl];
    NSURLRequest *imageRequest = [NSURLRequest requestWithURL:url];
    
    // Get the place holder image
    UIImage *placeHolderImage = [UIImage imageNamed:@"placeholder"];
    
    // Resize the image to fit into the UIImage frame width and height
    UIImage *resizedImage = [ImageUtility imageWithImage:placeHolderImage
                                        scaledToMaxWidth:imageView.frame.size.width
                                               maxHeight:imageView.frame.size.height];
    
    // Create a weak reference for the table view cell to avoid strong reference inside the block. Read below for more understanding
    // A block forms a strong reference to variables it captures. If you use  self within a block,
    // the block forms a strong reference to self, so if  self also has a strong reference to the block (which it typically does), a strong
    // reference cycle results. To avoid the cycle, you need to create a weak (or __block) reference to self outside the block, as in the
    // example above.
    __weak UITableViewCell *weakCell = cell;
    
    [imageView setImageWithURLRequest:imageRequest
                          placeholderImage:resizedImage
                                   success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                   
                                       imageView.image = image;
                                       [weakCell setNeedsLayout];
                                       
                                   } failure:nil];
  
    // Country name
    UILabel *label = (UILabel *)[cell viewWithTag:101];
    label.text = countryModel.name;
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([segue.identifier isEqualToString:@"showPlayerList"]) {
        // Get the indexPath from tableview
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        
        // Get the relevant entity object from the selected row index
        CountryModel *countryModel = [self.countryModel objectAtIndex:indexPath.row];
        
        // Pass the selected country model to the PlayerListTableViewController
        // Note: PlayerListTableViewController is embedded inside navigation view controller, so access accordingly as below
        UINavigationController *uiNavigationController = (UINavigationController *)segue.destinationViewController;
        
        // The view controller at the top of the stack is player list table view controller
        PlayerListTableViewController *playerListTableViewController = (PlayerListTableViewController *)
                                                                                [uiNavigationController topViewController];
        
        playerListTableViewController.selCountryModel = countryModel;
    }
}

@end
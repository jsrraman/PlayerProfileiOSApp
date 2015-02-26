//
//  CountryListTableViewController.m
//  PlayerProfile
//
//  Created by Rajaraman on 25/02/15.
//  Copyright (c) 2015 Rajaraman. All rights reserved.
//

#import "CountryListTableViewController.h"
#import "AFNetworking.h"
#import "NSDictionary+weather.h"
#import "NSDictionary+weather_package.h"
#import "UIImageView+AFNetworking.h"

//static NSString * const BaseURLString = @"http://www.raywenderlich.com/demos/weather_sample/";

@interface CountryListTableViewController ()
@property(strong) NSDictionary *weather;
@end

@implementation CountryListTableViewController

// This will be called multiple times inside cellForRowAtIndexPath: method, so
// keeping it static improves performance
static NSString *cellIdentifier = @"Country";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    PlayerProfileApiDataProvider *playerProfileApiDataProvider = [PlayerProfileApiDataProvider getInstance];
    playerProfileApiDataProvider.delegate = self;
    
    [playerProfileApiDataProvider getCountryList];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - PlayerProfileApiDataProvider delegate methods

-(void) playerProfileApiDataProvider:(PlayerProfileApiDataProvider *)dataProvider didSucceed:(id)data {
    self.weather = (NSDictionary *)data;
    [self.tableView reloadData];
}

-(void) playerProfileApiDataProvider:(PlayerProfileApiDataProvider *)dataProvider didFailWithError:(NSError *)error {
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message: [error localizedDescription] delegate:nil
                                              cancelButtonTitle: @"ok" otherButtonTitles:nil, nil];
    [alertView show];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 2;
}

// Return the number of rows in the table view
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    // Check whether we have received the proper JSON response object
    if (!self.weather) {
        return 0;
    }
    
    switch (section) {
        case 0 : {
            return 1;
        }
            
        case 1 : {
            NSArray *upcomingWeather = [self.weather upcomingWeather];
            return [upcomingWeather count];
        }
            
        default:
            return 0;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    
    NSDictionary *weather = nil;
    
    switch (indexPath.section) {
        case 0: {
            weather = [self.weather currentCondition];
            break;
        }
            
        case 1: {
            NSArray *upcomingWeather = [self.weather upcomingWeather];
            weather = upcomingWeather[indexPath.row];
        }
            
        default:
            break;
    }
    
    // Because this is a custom designed cell, you can no longer use UITableViewCell’s textLabel and detailTextLabel properties
    // to put text into the labels. These properties refer to labels that aren’t on this cell anymore; they are only valid
    // for the standard cell types. Instead, you will use tags to find the labels as below.

    // Country Thumbnail URL
    __weak UIImageView *imageView = (UIImageView *)[cell viewWithTag:100];

    NSURL *url = [NSURL URLWithString:weather.weatherIconURL];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    UIImage *placeHolderImage = [UIImage imageNamed:@"placeholder"];
    
    // Create a weak reference for the table view cell to avoid strong reference inside the block. Read below for more understanding
    // A block forms a strong reference to variables it captures. If you use  self within a block,
    // the block forms a strong reference to self, so if  self also has a strong reference to the block (which it typically does), a strong
    // reference cycle results. To avoid the cycle, you need to create a weak (or __block) reference to self outside the block, as in the
    // example above.
    __weak UITableViewCell *weakCell = cell;
    
    [imageView setImageWithURLRequest:request
                          placeholderImage:placeHolderImage
                                   success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                       
                                       imageView.image = image;
                                       [weakCell setNeedsLayout];
                                       
                                   } failure:nil];
  
    // Country name
    UILabel *label = (UILabel *)[cell viewWithTag:101];
    label.text = [weather weatherDescription];
    
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

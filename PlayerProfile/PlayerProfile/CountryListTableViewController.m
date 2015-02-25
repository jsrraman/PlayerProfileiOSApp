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

static NSString * const BaseURLString = @"http://www.raywenderlich.com/demos/weather_sample/";

@interface CountryListTableViewController ()
@property(strong) NSDictionary *weather;
@end

@implementation CountryListTableViewController

// This will be called multiple times inside cellForRowAtIndexPath: method, so
// keeping it static improves performance
static NSString *cellIdentifier = @"Country";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [self loadCountryList];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) loadCountryList {
    
    // Construct the actual URL string
    NSString *actualUrlString = [NSString stringWithFormat:@"%@weather.php?format=json", BaseURLString];
    
    // Construct the URL object
    NSURL *url = [NSURL URLWithString:actualUrlString];
    
    // Construct the NSURLRequest object
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    // Create an HTTP request using AFNetworking API
    AFHTTPRequestOperation *reqOp = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    // The response will be JSON, so set the serializer accordingly
    reqOp.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [reqOp setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
         self.weather = (NSDictionary *)responseObject;
         [self.tableView reloadData];
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
         UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message: [error localizedDescription] delegate:nil cancelButtonTitle: @"ok" otherButtonTitles:nil, nil];
         
         [alertView show];
     }];
    
    // Start the HTTP request asynchronously
    [reqOp start];
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
    
    // Set the cell's label
    cell.textLabel.text = [weather weatherDescription];
    
    NSURL *url = [NSURL URLWithString:weather.weatherIconURL];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    UIImage *placeHolderImage = [UIImage imageNamed:@"placeholder"];
    
    // Create a weak reference for the table view cell to avoid strong reference inside the block. Read below for more understanding
    // A block forms a strong reference to variables it captures. If you use  self within a block,
    // the block forms a strong reference to self, so if  self also has a strong reference to the block (which it typically does), a strong
    // reference cycle results. To avoid the cycle, you need to create a weak (or __block) reference to self outside the block, as in the
    // example above.
    __weak UITableViewCell *weakCell = cell;
   
    [cell.imageView setImageWithURLRequest:request
                          placeholderImage:placeHolderImage
                                   success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                       
                                       weakCell.imageView.image = image;
                                       [weakCell setNeedsLayout];
                                       
                                   } failure:nil];
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

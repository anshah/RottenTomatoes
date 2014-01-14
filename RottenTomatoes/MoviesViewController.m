//
//  MoviesViewController.m
//  RottenTomatoes
//
//  Created by Ankit Nitin Shah on 1/13/14.
//  Copyright (c) 2014 yahoo. All rights reserved.
//

#import "MoviesViewController.h"
#import "Movie.h"
#import "MovieViewController.h"

@interface MoviesViewController ()

@property (strong,nonatomic) NSArray* moviesList;

@end

@implementation MoviesViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    //Load data from Rotten Tomatoes to MovieList array
    NSString *url = @"http://api.rottentomatoes.com/api/public/v1.0/lists/dvds/top_rentals.json?apikey=g9au4hv6khv6wzvzgt55gpqs";
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        id object = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        NSLog(@"%@", object);
        
        NSMutableArray* mutableMovieList = [[ NSMutableArray alloc ] initWithCapacity: 5];
        for(id mv in [object valueForKey:@"movies"]){
            Movie* movie = [[Movie alloc] initWithRottenTomatoesData:mv];
            [mutableMovieList addObject: movie];
        }
        self.moviesList = [NSArray arrayWithArray:mutableMovieList];
        [self.tableView reloadData];
    }];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.moviesList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Movie* rowMovie = [self.moviesList objectAtIndex:indexPath.row];
    
    static NSString *CellIdentifier = @"MovieCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];

    // Configure the cell...
    UIImageView* uiImgView = (UIImageView*)[cell viewWithTag:0];
    NSURL *url = [NSURL URLWithString: rowMovie.postersThumbnail];
    /*NSData *data = [NSData dataWithContentsOfURL:url];
    UIImage *img = [[UIImage alloc] initWithData:data];
    [uiImgView setImage:img];
     */
    
    //if cached thumbnail, display it else load data asynchornously and request for refresh
    if(rowMovie.thumbnailData){
        UIImage *img = [[UIImage alloc] initWithData:rowMovie.thumbnailData];
        [uiImgView setImage:img];
    }else{
        NSURLRequest* request = [NSURLRequest requestWithURL:url];
        [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
            rowMovie.thumbnailData = data;
            [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationNone];
        }];
    }
    
    UILabel* titleLabel = (UILabel*)[cell viewWithTag:1];
    titleLabel.text =rowMovie.title;

    UILabel* descLabel = (UILabel*)[cell viewWithTag:2];
    descLabel.text =rowMovie.synopsis;

    UILabel* castsLabel = (UILabel*)[cell viewWithTag:3];
    castsLabel.text = [rowMovie.abridged_cast componentsJoinedByString:@", "];
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation
 */

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.

    NSIndexPath* selectedIndex = [self.tableView indexPathForCell:sender];
    Movie* selectedMovie = [self.moviesList objectAtIndex: selectedIndex.row];

    MovieViewController *movieViewController = [segue destinationViewController];
    movieViewController.title = selectedMovie.title;
    movieViewController.movie = selectedMovie;
}

 
@end

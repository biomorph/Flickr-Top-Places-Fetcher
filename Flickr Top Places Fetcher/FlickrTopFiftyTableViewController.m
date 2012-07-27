//
//  FlickrTopFiftyTableViewController.m
//  Flickr Top Places Fetcher
//
//  Created by Ravi Alla on 7/26/12.
//  Copyright (c) 2012 Ravi Alla. All rights reserved.
//

#import "FlickrTopFiftyTableViewController.h"
#import "FlickrFetcher.h"
#import "FlickrImageViewController.h"

@interface FlickrTopFiftyTableViewController ()
@end

@implementation FlickrTopFiftyTableViewController

@synthesize topPlace=_topPlace;
@synthesize topPhotos = _topPhotos;

- (IBAction)refresh:(id)sender
{
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [spinner startAnimating];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:spinner];
    
    dispatch_queue_t downloadQueue = dispatch_queue_create("flickr top photos downloader", NULL);
    dispatch_async(downloadQueue, ^{
        NSArray *topPhotos = [FlickrFetcher photosInPlace:self.topPlace maxResults:50];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.navigationItem.rightBarButtonItem = sender;
            self.topPhotos = topPhotos;

        });
    });
    dispatch_release(downloadQueue);
}

- (void)setTopPlace:(NSDictionary *)topPlace {
    if ([topPlace isKindOfClass:[NSDictionary class]] && (_topPlace != topPlace)) {
        _topPlace = topPlace;
        [self.tableView reloadData];
    }
    
}
- (void)setTopPhotos:(NSArray *)topPhotos
{
    if ([topPhotos isKindOfClass:[NSArray class]] && (_topPhotos = topPhotos)) {
        _topPhotos = topPhotos;
        [self.tableView reloadData];
    }
    
}



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
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

#pragma mark - Table view data source




- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return [self.topPhotos count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Top Places Top 50";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    
    NSString *title = [[self.topPhotos objectAtIndex:indexPath.row] objectForKey:FLICKR_PHOTO_TITLE];
    if(title &&[title length]>0) cell.textLabel.text = title;
    else cell.textLabel.text = @"Unknown";
    
NSString *subtitle = [[self.topPhotos objectAtIndex:indexPath.row]valueForKeyPath:FLICKR_PHOTO_DESCRIPTION];
    if (subtitle && [subtitle length]) cell.detailTextLabel.text = subtitle;
    else cell.detailTextLabel.text =@"Unknown";
    
    return cell;
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Show Selected Image"]){
        NSIndexPath *photoIndex = [self.tableView indexPathForCell:sender];
        NSDictionary *photoInformation = [self.topPhotos objectAtIndex:photoIndex.row];
        NSURL *imageURL = [FlickrFetcher urlForPhoto:photoInformation format:FlickrPhotoFormatLarge];
        NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
        [segue.destinationViewController setImageData:imageData];
        NSString *title = [[self.topPhotos objectAtIndex:photoIndex.row] objectForKey:FLICKR_PHOTO_TITLE];
        [segue.destinationViewController setImageTitle:title];
        //NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    }
}
@end

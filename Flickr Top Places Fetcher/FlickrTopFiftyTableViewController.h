//
//  FlickrTopFiftyTableViewController.h
//  Flickr Top Places Fetcher
//
//  Created by Ravi Alla on 7/26/12.
//  Copyright (c) 2012 Ravi Alla. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FlickrTopFiftyTableViewController : UITableViewController
@property (nonatomic,strong) NSDictionary *topPlace;
@property (nonatomic,strong) NSArray *topPhotos;


@end

//
//  FlickrImageViewController.m
//  Flickr Top Places Fetcher
//
//  Created by Ravi Alla on 7/26/12.
//  Copyright (c) 2012 Ravi Alla. All rights reserved.
//

#import "FlickrImageViewController.h"

@interface FlickrImageViewController () <UIScrollViewDelegate>
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;

@end

@implementation FlickrImageViewController
@synthesize imageView;
@synthesize scrollView;
@synthesize imageData = _imageData;
@synthesize imageTitle = _imageTitle;

- (void)setImageData:(NSData *)imageData
{
    if (_imageData !=imageData) {
        _imageData = imageData;
}
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.scrollView.delegate = self;
    self.navigationItem.title = self.imageTitle;
    self.imageView.image = [UIImage imageWithData:self.imageData];
    self.scrollView.contentSize=self.imageView.image.size;
    //self.imageView.frame = CGRectMake(0, 0, self.imageView.image.size.width, self.imageView.image.size.height);
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    CGRect scrollViewRect;
    scrollViewRect.size=  self.scrollView.bounds.size;
    scrollViewRect.origin=self.scrollView.contentOffset;
    [self.scrollView zoomToRect:scrollViewRect animated:YES];
}

- (UIView *) viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}


- (void)viewDidUnload
{
    [self setImageView:nil];
    [self setScrollView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

@end

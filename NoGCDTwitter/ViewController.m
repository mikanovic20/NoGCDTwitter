//
//  ViewController.m
//  NoGCDTwitter
//
//  Created by mikanovic on 2013/04/11.
//  Copyright (c) 2013 mikanovic20. All rights reserved.
//

#import "ViewController.h"
#import "TwitterWrapper.h"

@interface ViewController ()
{
    NSArray *_timeLine;
}
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [TwitterWrapper homeTimeLine:^(NSArray *timeLine){
        _timeLine = timeLine;
        [self.tableView performSelectorOnMainThread:@selector(reloadData)
                                         withObject:nil
                                      waitUntilDone:NO];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIImage *)getImage:(NSString *)url
{
    NSMutableURLRequest *request =[NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];

    NSHTTPURLResponse *response;
    NSError *error = nil;
    
    NSData *imageData = [NSURLConnection sendSynchronousRequest:request
                                              returningResponse:&response
                                                          error:&error];
    if (imageData && response.statusCode == 200) {
        return [UIImage imageWithData:imageData];
    } else {
        NSLog(@"NSURLConnection error = %@, status = %d", error, response.statusCode);
        return nil;
    }
}

#pragma TableView Delegate Methods

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return [_timeLine count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TweetCell"
                                                            forIndexPath:indexPath];
    
    NSDictionary *tweet = _timeLine[indexPath.row];
    
    cell.textLabel.text = tweet[@"text"];
    cell.detailTextLabel.text = tweet[@"user"][@"name"];
    cell.imageView.image = [self getImage:tweet[@"user"][@"profile_image_url"]];
    
    return cell;
}

@end

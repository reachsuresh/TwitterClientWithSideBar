//
//  HomeViewController.m
//  TwitterClient
//
//  Created by Vinayakumar Kolli on 2/7/15.
//  Copyright (c) 2015 Vinayakumar Kolli. All rights reserved.
//

#import "HomeViewController.h"
#import "TweetTableViewCell.h"
#import "TwitterClient.h"
#import "Tweet.h"
#import "TweetPostViewController.h"
#import "TweetDetailsViewController.h"
#import "ProfilePageViewController.h"

@interface HomeViewController () <UITableViewDataSource, UITableViewDelegate, TweetCellDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableDictionary *data;
@property (nonatomic, strong) NSArray *tweets;
- (void)refreshTable :(UIRefreshControl *) refreshControl;
@property (nonatomic, strong) NSString *currentScreenName;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"TweetTableViewCell" bundle:nil] forCellReuseIdentifier:@"TweetTableViewCell"];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.title = @"twitter";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"New" style:UIBarButtonItemStylePlain target:self action:@selector(onCreateNewTweet)];
    [self fetchTweets];
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc]init];
    [self.tableView addSubview:refreshControl];
    [refreshControl addTarget:self action:@selector(refreshTable:) forControlEvents:UIControlEventValueChanged];
    // Do any additional setup after loading the view from its nib.
}

- (void)clickOnImage {
    
    NSLog(@"Coming Here MKD!");
    ProfilePageViewController *pvc = [[ProfilePageViewController alloc] init];

    [self.navigationController pushViewController:pvc animated:YES];

}

- (void)refreshTable :(UIRefreshControl *) refreshControl {
    [self fetchTweets];
    [refreshControl endRefreshing];
}

- (void)fetchTweets {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params setObject:[NSNumber numberWithInt:20]  forKey:@"count"];
    
    
    [[TwitterClient getInstance] GET:@"1.1/statuses/home_timeline.json" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Obtained Home Timelines %@", responseObject);
        self.tweets = [Tweet tweetsWithArray:responseObject];
        for (Tweet *tweet in self.tweets) {
            NSLog(@"Data is %@", tweet.text);
            
        }
        
        [self.tableView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Failed to get timelines");
        
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TweetDetailsViewController *tdvc = [[TweetDetailsViewController alloc]init];
    Tweet *tweet = [self.tweets objectAtIndex:indexPath.row];
    [tdvc setData:tweet];
    
    [self.navigationController pushViewController:tdvc animated:YES];

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    TweetTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"TweetTableViewCell"];
    Tweet *tweet = [self.tweets objectAtIndex:indexPath.row];
    NSLog(@"text %@", tweet.text);
    cell.desc.text = tweet.text;
    cell.name.text = tweet.user.name;
    cell.tagLine.text = [NSString stringWithFormat:@"@%@",tweet.user.screenName];
    
    dispatch_async(dispatch_get_global_queue(0,0), ^{
        NSData * data = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString:tweet.user.profileImageUrl]];
        if ( data == nil )
            return;
        dispatch_async(dispatch_get_main_queue(), ^{
            // WARNING: is the cell still using the same data by this point??
            cell.image.image = [UIImage imageWithData: data];
        });
    });
    NSDate *now = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"H s"];
    NSString *timeDiff = [formatter stringFromDate:tweet.createdDate];
    
    cell.date.text = [NSString stringWithFormat:@"%@ ago", timeDiff];
    
    UITapGestureRecognizer *imageTapRec = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapImage:)];
    
    [cell.image addGestureRecognizer:imageTapRec];
    [cell.image setUserInteractionEnabled:YES];
    imageTapRec.numberOfTapsRequired = 1;
    
    
    return cell;
    

}

- (void)onTapImage: (UIGestureRecognizer *)gestureRecognizer
{
    UIView *parentCell = gestureRecognizer.view.superview;
    
    while (![parentCell isKindOfClass:[UITableViewCell class]]) {   // iOS 7 onwards the table cell hierachy has changed.
        parentCell = parentCell.superview;
    }
    
    UIView *parentView = parentCell.superview;
    
    while (![parentView isKindOfClass:[UITableView class]]) {   // iOS 7 onwards the table cell hierachy has changed.
        parentView = parentView.superview;
    }
    
    
    UITableView *tableView = (UITableView *)parentView;
    NSIndexPath *indexPath = [tableView indexPathForCell:(UITableViewCell *)parentCell];
    
    ProfilePageViewController *pvc = [[ProfilePageViewController alloc] init];
    
    Tweet *tweet = [self.tweets objectAtIndex:indexPath.row];
    
    [pvc setUserId:tweet.user.id];
    [pvc setScreenNameFromParent:tweet.user.screenName];
    [self.navigationController pushViewController:pvc animated:YES];
    
    NSLog(@"indexPath = %@", indexPath);
}

- (void)onCreateNewTweet {
    NSLog(@"for creating new tweet");
    TweetPostViewController *tpvc = [[TweetPostViewController alloc] init];
    [self.navigationController pushViewController:tpvc animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tweets.count;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

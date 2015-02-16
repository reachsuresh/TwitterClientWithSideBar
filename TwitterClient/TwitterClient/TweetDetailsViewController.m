//
//  TweetDetailsViewController.m
//  TwitterClient
//
//  Created by Vinayakumar Kolli on 2/8/15.
//  Copyright (c) 2015 Vinayakumar Kolli. All rights reserved.
//


#import "TweetDetailsViewController.h"
#import "Tweet.h"
#import "TwitterClient.h"


@interface TweetDetailsViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *screenName;
@property (weak, nonatomic) IBOutlet UILabel *tweetText;
@property (weak, nonatomic) IBOutlet UILabel *createDate;
@property (weak, nonatomic) IBOutlet UILabel *FavCount;
@property (weak, nonatomic) IBOutlet UILabel *retweetCount;
@property (nonatomic, strong) Tweet *tweet;
@property (weak, nonatomic) IBOutlet UIImageView *favourite;
@property (nonatomic, assign) bool isFollowed;
@end

@implementation TweetDetailsViewController

- (void)setData: (Tweet *)tweet {
    self.tweet = tweet;

}

- (void)imageViewDidTapped:(UIGestureRecognizer *)aGesture {
    NSLog(@"iv tapped");
    UITapGestureRecognizer *tapGesture = (UITapGestureRecognizer *)aGesture;
    
    UIImageView *tappedImageView = (UIImageView *)[tapGesture view];
    
    switch (tappedImageView.tag) {
        case 0:
            NSLog(@"UIImageView 1 was tapped");
            break;
        case 1:
            NSLog(@"UIImageView 2 was tapped");
            break;
        default:
            break;
    }
}

- (IBAction)onTapOfFavourite:(id)sender {
    NSLog(@"Coming to fav");
}

-(void)handleSingleTap:(UIGestureRecognizer*)sender{
    NSLog(@"coming inside tap");
    if(self.isFollowed != true){
        
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        
        [params setObject:self.tweet.tweet_id  forKey:@"id"];
        
        
        [[TwitterClient getInstance] POST:@"1.1/favorites/create.json" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"Did favourite %@", responseObject);
            NSData *favdata = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://g.twimg.com/dev/documentation/image/favorite_on.png"]];
            self.favourite.image = [UIImage imageWithData:favdata];
            
            self.isFollowed = true;
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Failed to post fav action");
            
        }];
        
    }

}

- (void)viewDidLoad {
    self.isFollowed = false;
    UITapGestureRecognizer *singleFingerTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    singleFingerTap.numberOfTapsRequired = 1;
    [self.favourite addGestureRecognizer:singleFingerTap];
    [super viewDidLoad];
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.tweet.user.profileImageUrl]];
    self.image.image = [UIImage imageWithData:data];
    self.name.text = self.tweet.user.name;
    self.screenName.text = [NSString stringWithFormat:@"@%@",self.tweet.user.screenName];
    int rc = self.tweet.user.retweetCount;
    self.retweetCount.text = [NSString stringWithFormat:@"%d retweets",rc];
    int fc = self.tweet.user.favCount;
    self.FavCount.text = [NSString stringWithFormat:@"%d favourites",fc];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"d M y, H:m a"];
    NSString *date = [formatter stringFromDate:self.tweet.createdDate];
    NSLog(@"date is %@ and date from data is %@",date, self.tweet.createdDate);
    self.createDate.text = date;
    
    self.tweetText.text = self.tweet.text;
    
    NSData *favdata = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://g.twimg.com/dev/documentation/image/favorite.png"]];
    self.favourite.image = [UIImage imageWithData:favdata];
    [self.favourite setUserInteractionEnabled:YES];
    // Do any additional setup after loading the view from its nib.
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

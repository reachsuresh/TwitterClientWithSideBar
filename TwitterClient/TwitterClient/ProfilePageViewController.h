//
//  ProfilePageViewController.h
//  TwitterClient
//
//  Created by Vinayakumar Kolli on 2/14/15.
//  Copyright (c) 2015 Vinayakumar Kolli. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"

@interface ProfilePageViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImage;
@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *screenName;
@property(nonatomic, strong) NSString *screenNameFromParent;
@property(nonatomic, strong) NSNumber * userId;
@property(nonatomic, strong) User *user;

@property (weak, nonatomic) IBOutlet UIView *menuView;
- (void)onCustomPan:(UIPanGestureRecognizer *)panGestureRecognizer;
@property (weak, nonatomic) IBOutlet UITableView *menuTableView;
@property(nonatomic, strong) NSArray *menuItems;
@property (weak, nonatomic) IBOutlet UILabel *followerCount;
@property (weak, nonatomic) IBOutlet UILabel *TweetCount;
@property (weak, nonatomic) IBOutlet UILabel *followingCount;
@property (weak, nonatomic) IBOutlet UILabel *latestTweet;
@property(nonatomic,strong) NSString *latestTweetText;
- (void) setWidthForLabel : (UILabel *)label withWidthFactor: (double)widthFactor;
@end

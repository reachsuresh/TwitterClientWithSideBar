//
//  TweetDetailsViewController.h
//  TwitterClient
//
//  Created by Vinayakumar Kolli on 2/8/15.
//  Copyright (c) 2015 Vinayakumar Kolli. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tweet.h"

@interface TweetDetailsViewController : UIViewController

- (void)setData: (Tweet *)tweet;
- (IBAction)onTapOfFavourite:(id)sender;

@end

//
//  Tweet.h
//  TwitterClient
//
//  Created by Vinayakumar Kolli on 2/7/15.
//  Copyright (c) 2015 Vinayakumar Kolli. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

@interface Tweet : NSObject


@property (nonatomic, strong) NSString * text;
@property (nonatomic, strong) NSDate * createdDate;
@property (nonatomic, strong) User *user;
@property (nonatomic, strong) NSString *tweet_id;

+ (NSArray *)tweetsWithArray: (NSArray *)array;

- (id)initWithDictionary : (NSDictionary *)dictionary;

@end

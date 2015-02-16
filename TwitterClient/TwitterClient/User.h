//
//  User.h
//  TwitterClient
//
//  Created by Vinayakumar Kolli on 2/7/15.
//  Copyright (c) 2015 Vinayakumar Kolli. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface User : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *profileImageUrl;
@property (nonatomic, strong) NSString *screenName;
@property (nonatomic, strong) NSString *tagLine;
@property (nonatomic, assign) NSInteger favCount;
@property (nonatomic, strong) NSDate * createdDate;
@property (nonatomic, assign) NSInteger retweetCount;
@property (nonatomic, assign) NSNumber *id;
@property (nonatomic, strong) NSString *backgroundImageUrl;
@property (nonatomic, strong) NSString *tweetCount;
@property (nonatomic, strong) NSString *followerCount;
@property (nonatomic, strong) NSString *followingCount;

- (id)initWithDictionary : (NSDictionary *)dictionary;


+ (User *)currentUser;
+ (void) setCurrentUser:(User *)currentUser;

@end

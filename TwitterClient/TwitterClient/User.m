//
//  User.m
//  TwitterClient
//
//  Created by Vinayakumar Kolli on 2/7/15.
//  Copyright (c) 2015 Vinayakumar Kolli. All rights reserved.
//

#import "User.h"

@interface User ()

@property (nonatomic, strong) NSDictionary *dictionary;



@end

@implementation User

NSString *userDataKey = @"userDataKey";
static User *_currentUser = nil;



- (id)initWithDictionary : (NSDictionary *)dictionary {
    self = [super init];
    
    if(self) {
        self.dictionary = dictionary;
        self.name = dictionary[@"name"];
        self.screenName = dictionary[@"screen_name"];
        self.profileImageUrl = dictionary[@"profile_image_url"];
        self.backgroundImageUrl = dictionary[@"profile_background_image_url"];
        self.tagLine = dictionary[@"description"];
        self.favCount = [dictionary[@"favourites_count"] integerValue];
        self.retweetCount = [dictionary[@"retweet_count"] integerValue];
        self.id = [NSNumber numberWithInt:dictionary[@"id"]];
        
        self.tweetCount = dictionary[@"listed_count"];
        self.followerCount = dictionary[@"followers_count"];
        self.followingCount = dictionary[@"friends_count"];
        
    }
    
    
    return self;
}



+ (User *)currentUser {
    if(_currentUser == nil){
    
        NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:userDataKey];
        if(data != nil){
        
            NSDictionary * dictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
            _currentUser = [[User alloc] initWithDictionary:dictionary];
        }
    
    }
    
    
    return _currentUser;
}

+ (void) setCurrentUser:(User *)currentUser {
    _currentUser = currentUser;
    
    if(currentUser != nil) {
    
        NSData *data = [NSJSONSerialization dataWithJSONObject:currentUser.dictionary options:0 error:NULL];
        
        [[NSUserDefaults standardUserDefaults] setObject:data forKey:userDataKey];
        
    }
    else {
      
        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:userDataKey];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
}


@end

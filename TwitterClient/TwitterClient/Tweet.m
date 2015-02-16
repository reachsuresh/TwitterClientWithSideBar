//
//  Tweet.m
//  TwitterClient
//
//  Created by Vinayakumar Kolli on 2/7/15.
//  Copyright (c) 2015 Vinayakumar Kolli. All rights reserved.
//

#import "Tweet.h"

@implementation Tweet

+ (NSArray *)tweetsWithArray: (NSArray *)array {
    NSMutableArray *tweets = [NSMutableArray array];
                             
    for (NSDictionary *dictionary in array) {
        [tweets addObject:[[Tweet alloc] initWithDictionary:dictionary]];
    }
    
    return tweets;

}

- (id)initWithDictionary : (NSDictionary *)dictionary {
    self = [super init];
    
    if(self) {
        self.text = dictionary[@"text"];
        self.tweet_id = dictionary[@"id_str"];
        
        self.user = [[User alloc]initWithDictionary:dictionary[@"user"]];
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        
        formatter.dateFormat = @"EEE dd MM HH:mm:s Z y";
        
        
        
        self.createdDate = [formatter dateFromString:dictionary[@"created_at"]];
        
    }
    
    return self;
}

@end

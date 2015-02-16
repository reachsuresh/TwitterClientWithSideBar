//
//  TwitterClient.m
//  TwitterClient
//
//  Created by Vinayakumar Kolli on 2/7/15.
//  Copyright (c) 2015 Vinayakumar Kolli. All rights reserved.
//

#import "TwitterClient.h"
#import "Tweet.h"

NSString * const twitterConsumerKey = @"GrWNLBkEw84MRuzM8fFTGRQwE";
NSString * const twitterCOnsumerSecret = @"k8giY9kzJhqN9n61TUHmrWoLeANc230nXIBP1TTsAZMvqjJJU1";
NSString * const twitterURL = @"https://api.twitter.com";

@interface TwitterClient()

@property (nonatomic,strong) void (^loginCompletion)(User *user, NSError *error);

@end

@implementation TwitterClient

+ (TwitterClient *) getInstance {
    
    static TwitterClient *instance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        if(instance == nil){
            instance = [[TwitterClient alloc] initWithBaseURL:[NSURL URLWithString:twitterURL] consumerKey:twitterConsumerKey consumerSecret:twitterCOnsumerSecret];
        }
        
        
    });
    
    return instance;
    
    
}

- (void)openURL:(NSURL *)url {
    [[TwitterClient getInstance] fetchAccessTokenWithPath:@"oauth/access_token" method:@"POST" requestToken:[BDBOAuth1Credential credentialWithQueryString:url.query]  success:^(BDBOAuth1Credential *accessToken) {
        NSLog(@"Got the access token");
        
        [[TwitterClient getInstance].requestSerializer saveAccessToken:accessToken];
        
        [[TwitterClient getInstance] GET:@"1.1/account/verify_credentials.json" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"Got User credentials %@", responseObject);
            User *user = [[User alloc] initWithDictionary:responseObject];
            [User setCurrentUser:user];
            NSLog(@"User object is %@", user.name);
            self.loginCompletion(user, nil);
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Failed to verify credentials");
            self.loginCompletion(nil, error);
        }];
        
        
    } failure:^(NSError *error) {
        NSLog(@"Did not get the access token");
        
    }];

}


- (void)loginWithCompletion:(void(^)(User *user, NSError *error)) completion {

    self.loginCompletion = completion;

    [self.requestSerializer removeAccessToken];
    
    [self fetchRequestTokenWithPath:@"oauth/request_token" method:@"GET" callbackURL:[NSURL URLWithString:@"twitterappdemo://oauth"] scope:nil success:^(BDBOAuth1Credential *requestToken) {
        NSLog(@"Got the request token");
        
        NSURL *authUrl = [NSURL URLWithString:[NSString stringWithFormat:@"https://api.twitter.com/oauth/authorize?oauth_token=%@", requestToken.token]];
        
        [[UIApplication sharedApplication] openURL:authUrl];
        
        
    } failure:^(NSError *error) {
        NSLog(@"Failed to get the request");
        self.loginCompletion(nil, error);
    }];
    

    
    
}


@end

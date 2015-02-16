//
//  TwitterClient.h
//  TwitterClient
//
//  Created by Vinayakumar Kolli on 2/7/15.
//  Copyright (c) 2015 Vinayakumar Kolli. All rights reserved.
//

#import "BDBOAuth1RequestOperationManager.h"
#import "User.h"

@interface TwitterClient : BDBOAuth1RequestOperationManager

+ (TwitterClient *) getInstance;

- (void)loginWithCompletion:(void(^)(User *user, NSError *error))completion;



- (void)openURL:(NSURL *)url;
@end

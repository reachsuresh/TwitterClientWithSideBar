//
//  TweetPostViewController.m
//  TwitterClient
//
//  Created by Vinayakumar Kolli on 2/8/15.
//  Copyright (c) 2015 Vinayakumar Kolli. All rights reserved.
//

#import "TweetPostViewController.h"
#import "User.h"
#import "TwitterClient.h"
#import "HomeViewController.h"

@interface TweetPostViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *userImage;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *tagline;
@property (weak, nonatomic) IBOutlet UITextField *tweetText;

- (void)onTweet;
@end

@implementation TweetPostViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    User *user = [User currentUser];
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:user.profileImageUrl]];
    self.userImage.image = [UIImage imageWithData:data];
    self.name.text = user.name;
    self.tagline.text = user.tagLine;

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Tweet" style:UIBarButtonItemStylePlain target:self action:@selector(onTweet)];
    // Do any additional setup after loading the view from its nib.
}

- (void)onTweet {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params setObject:self.tweetText.text forKey:@"status"];
    
    
    [[TwitterClient getInstance] POST:@"1.1/statuses/update.json" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Posted Tweet %@", responseObject);
        HomeViewController *hvc = [[HomeViewController alloc] init];
        [self.navigationController pushViewController:hvc animated:YES];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Failed to post");
        
    }];
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

- (IBAction)onDeselectKeyboard:(id)sender {
    [self.view endEditing:YES];
    
}
@end

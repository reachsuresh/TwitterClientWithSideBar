//
//  LoginViewController.m
//  TwitterClient
//
//  Created by Vinayakumar Kolli on 2/7/15.
//  Copyright (c) 2015 Vinayakumar Kolli. All rights reserved.
//

#import "LoginViewController.h"
#import "TwitterClient.h"

@interface LoginViewController ()
- (IBAction)clickButton:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *button;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
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

- (IBAction)clickButton:(id)sender {
      [[TwitterClient getInstance] loginWithCompletion:^(User *user, NSError *error) {
          if(user != nil){
          NSLog(@"LoggedIN");
              NSLog(@"Welcome to User %@", user.name);
      }
      else {
          NSLog(@"Failed to Login with error %@", error);
      }
      }];
}
@end

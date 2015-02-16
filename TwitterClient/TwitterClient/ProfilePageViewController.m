//
//  ProfilePageViewController.m
//  TwitterClient
//
//  Created by Vinayakumar Kolli on 2/14/15.
//  Copyright (c) 2015 Vinayakumar Kolli. All rights reserved.
//

#import "ProfilePageViewController.h"
#import "TwitterClient.h"
#import "Tweet.h"
#import "MenuItemsTableViewCell.h"
#import "HomeViewController.h"
#import "TweetPostViewController.h"

@interface ProfilePageViewController () <UITableViewDataSource, UITableViewDelegate>

@end

@implementation ProfilePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self fetchUserDetails];
    [self.menuView setFrame:CGRectMake(-self.menuView.frame.size.width,self.menuView.frame.origin.y, self.menuView.frame.size.width, self.menuView.frame.size.height)];
    

    
    self.view.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
    
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(onCustomPan:)];
    [self.view addGestureRecognizer:panGestureRecognizer];
    [self.view addSubview:self.menuView];
    
    
    [self.menuTableView registerNib:[UINib nibWithNibName:@"MenuItemsTableViewCell" bundle:nil] forCellReuseIdentifier:@"MenuItemsTableViewCell"];
    
    self.menuTableView.rowHeight = 64;
    self.menuTableView.delegate = self;
    self.menuTableView.dataSource = self;
    self.menuItems = [NSArray arrayWithObjects:@"Home Timelines", @"Profile Link", @"Post Tweet", nil];
    
    
    
    // Do any additional setup after loading the view from its nib.
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] init];
    
    return view;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"Preparing Cell at %ld and height of view is %f", (long)indexPath.row, tableView.contentSize.height);
    MenuItemsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MenuItemsTableViewCell"];
    
    cell.label.text = self.menuItems[indexPath.row];
    
    return cell;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UIViewController *vc;
    MenuItemsTableViewCell *cell = (MenuItemsTableViewCell *)[self.menuTableView cellForRowAtIndexPath:indexPath];
    
    switch(indexPath.row){
        case 0 :
            vc = [[HomeViewController alloc] init]; break;
        case 1 : [self hideMenuView];
            break;
        case 2 :
            vc = [[TweetPostViewController alloc] init]; break;
    }
    [self.navigationController pushViewController:vc animated:YES];


}

- (void) hideMenuView {
    [UIView animateWithDuration:0.5 delay:0.01 options:0 animations:^{
        [self.menuView setFrame:CGRectMake(-self.menuView.frame.size.width,self.menuView.frame.origin.y, self.menuView.frame.size.width, self.view.frame.size.height)];

    } completion:^(BOOL finished) {
        //Do nothing
    }];
}

- (void) showMenuView {
    [UIView animateWithDuration:0.5 delay:0.01 options:0 animations:^{
        [self.menuView setFrame:CGRectMake(0,self.menuView.frame.origin.y, self.menuView.frame.size.width, self.view.frame.size.height)];
        
    } completion:^(BOOL finished) {
        //Do nothing
    }];
}

- (void) renderDetails {
    self.title = self.user.name;
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.user.backgroundImageUrl]];
    self.backgroundImage.image = [UIImage imageWithData:data];

//    CGRect rect = CGRectMake(0.0, 0.0, self.backgroundImage.frame.size.width + 100, self.view.frame.size.height);
//    // UIGraphicsBeginImageContext(rect.size);
//    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 1.0);
//    [self.backgroundImage.image drawInRect:rect];
//    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    
//    self.backgroundImage.image = img;
    
    
    data = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.user.profileImageUrl]];
    self.profileImage.image = [UIImage imageWithData:data];
    
    self.userName.text = self.user.name;
    self.screenName.text = [NSString stringWithFormat:@"@%@",self.user.screenName];
    
    [self setWidthForLabel:self.TweetCount withWidthFactor:4];
    [self setWidthForLabel:self.followerCount withWidthFactor:4];
        [self setWidthForLabel:self.followingCount withWidthFactor:4];
    self.TweetCount.text = [NSString stringWithFormat:@"%@ Tweets",self.user.tweetCount];
    self.followingCount.text = [NSString stringWithFormat:@"%@ Following",self.user.followingCount];
    self.followerCount.text = [NSString stringWithFormat:@"%@ Followers", self.user.followerCount];
    [self.latestTweet setFont:[UIFont fontWithName:@"Arial" size:18.0]];
    CGRect frame = CGRectMake(self.latestTweet.frame.origin.x, self.latestTweet.frame.origin.y, 300, 100);
    self.latestTweet.frame = frame;
    self.latestTweet.text = [NSString stringWithFormat:@"Latest Tweet\n %@", self.latestTweetText];
    
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView didHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    // Add your Colour.
    MenuItemsTableViewCell *cell = (MenuItemsTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    [self setCellColor:[UIColor colorWithRed:0 green:0 blue:1 alpha:0.8] ForCell:cell];  //highlight colour
}

- (void)tableView:(UITableView *)tableView didUnhighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    // Reset Colour.
    MenuItemsTableViewCell *cell = (MenuItemsTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    [self setCellColor:[UIColor colorWithWhite:0.961 alpha:1.000] ForCell:cell]; //normal color
    
}

- (void)setCellColor:(UIColor *)color ForCell:(UITableViewCell *)cell {
    cell.contentView.backgroundColor = color;
    cell.backgroundColor = color;
}

- (void) setWidthForLabel : (UILabel *)label withWidthFactor:(double) widthFactor {
    //label.frame.size.height;
    
    CGRect frame = CGRectMake(label.frame.origin.x, label.frame.origin.y, self.view.frame.size.width / widthFactor, 100);
    label.frame = frame;

}

- (void)fetchUserDetails {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params setObject:self.screenNameFromParent  forKey:@"screen_name"];
    [params setObject:self.userId forKey:@"user_id"];
    
    
    [[TwitterClient getInstance] GET:@"1.1/users/show.json" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //NSLog(@"Obtained User Profile Details %@", responseObject);
        self.user = [[User alloc] initWithDictionary:responseObject];
        NSLog(@"profile user obj %@", self.user.name);
         [self renderDetails];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Failed to get timelines");
        
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

- (void)onCustomPan:(UIPanGestureRecognizer *)panGestureRecognizer {
    CGPoint point = [panGestureRecognizer locationInView:self.view];
    CGPoint velocity = [panGestureRecognizer velocityInView:self.view];
    NSLog(@"The width of the view is %f", self.menuView.frame.size.width);
    int threshold = 50;
    if (panGestureRecognizer.state == UIGestureRecognizerStateBegan) {
        NSLog(@"the position of view at the beginning %f", self.menuView.frame.origin.x);
        
        
        
        
    } else if (panGestureRecognizer.state == UIGestureRecognizerStateChanged) {
        NSLog(@"the position of view %f", self.menuView.frame.origin.x);
        if(velocity.x > 0){
        
            if(self.menuView.frame.origin.x < 0){
                [self.menuView setFrame:CGRectMake(self.menuView.frame.origin.x + point.x * 0.25, self.menuView.frame.origin.y, self.menuView.frame.size.width, self.menuView.frame.size.height)];
            }
        }
        else {

            if(self.menuView.frame.origin.x + self.menuView.frame.size.width > 0){
                [self.menuView setFrame:CGRectMake(self.menuView.frame.origin.x - point.x * 0.025, self.menuView.frame.origin.y, self.menuView.frame.size.width, self.menuView.frame.size.height)];
            }
        }
        
        
    } else if (panGestureRecognizer.state == UIGestureRecognizerStateEnded) {
        NSLog(@"the position of view at the end %f", self.menuView.frame.origin.x);
        
        if(velocity.x > 0){
            if(self.menuView.frame.origin.x > -self.menuView.frame.size.width + threshold){
                [self showMenuView];
            }
            else {
                [self hideMenuView];
            }
        }
        else if (velocity.x < 0){
            if(self.menuView.frame.origin.x < (self.menuView.frame.size.width - threshold)){
                [self hideMenuView];
            }
            else {
                [self showMenuView];
            }
        }
        
    }
}


@end

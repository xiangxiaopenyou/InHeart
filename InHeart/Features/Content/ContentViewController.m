//
//  ContentViewController.m
//  InHeart
//
//  Created by 项小盆友 on 16/9/10.
//  Copyright © 2016年 项小盆友. All rights reserved.
//

#import "ContentViewController.h"
#import "ContentCell.h"

#import <UIImage-Helpers.h>

@interface ContentViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) UIView *searchView;
@property (strong, nonatomic) UITextField *searchTextField;

@end

@implementation ContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self addNavigationTitleView];
}
- (UIView *)searchView {
    if (!_searchView) {
        _searchView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 60, 32)];
        _searchView.layer.masksToBounds = YES;
        _searchView.layer.cornerRadius = 4.0;
        _searchView.backgroundColor = kRGBColor(0, 0, 0, 0.5);
        
        UIImageView *searchImage = [[UIImageView alloc] initWithFrame:CGRectMake(10, 6, 20, 20)];
        searchImage.backgroundColor = [UIColor greenColor];
        [_searchView addSubview:searchImage];
        
        [_searchView addSubview:self.searchTextField];
        
    }
    return _searchView;
}
- (UITextField *)searchTextField {
    if (!_searchTextField) {
        _searchTextField = [[UITextField alloc] initWithFrame:CGRectMake(30, 0, SCREEN_WIDTH - 90, 32)];
        _searchTextField.backgroundColor = [UIColor clearColor];
        _searchTextField.placeholder = kSearchPlaceholder;
        [_searchTextField setValue:[UIColor redColor] forKeyPath:@"_placeholderLabel.textColor"];
    }
    return _searchTextField;
}
- (void)addNavigationTitleView {
    self.navigationItem.titleView = self.searchView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableView Delegate DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return (kCollectionCellItemHeight + 10) * 5.0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ContentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Content" forIndexPath:indexPath];
    return cell;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

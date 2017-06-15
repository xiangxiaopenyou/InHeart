//
//  NewsViewController.m
//  InHeart
//
//  Created by 项小盆友 on 2017/6/12.
//  Copyright © 2017年 项小盆友. All rights reserved.
//

#import "NewsViewController.h"
#import "NewsTopCell.h"

@interface NewsViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIScrollView *contentScrollView;
@property (strong, nonatomic) UITableView *topTableView;

@property (strong, nonatomic) NSMutableArray *topArray;
@property (assign, nonatomic) NSInteger selectedIndex;

@end

@implementation NewsViewController

#pragma mark - view controller
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _selectedIndex = 0;
    [self addTopTableView];
    [self addContentTableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - private methods
- (void)addTopTableView {
    [self.topView addSubview:self.topTableView];
    self.topArray = [@[@"推荐", @"养生", @"睡眠障碍", @"焦虑症", @"测试1", @"测试2", @"测试3", @"测试4"] mutableCopy];
    [self.topTableView reloadData];
}
- (void)addContentTableView {
    for (NSInteger i = 0; i < self.topArray.count; i ++) {
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH * i, 0, SCREEN_WIDTH, CGRectGetHeight(self.contentScrollView.frame)) style:UITableViewStylePlain];
        tableView.backgroundColor = [UIColor clearColor];
        tableView.tag = 1000 + i;
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.separatorInset = UIEdgeInsetsZero;
        tableView.separatorColor = kHexRGBColorWithAlpha(0xe5e5e5, 1);
        [self.contentScrollView addSubview:tableView];
    }
    self.contentScrollView.contentSize = CGSizeMake(self.topArray.count * SCREEN_WIDTH, 0);
}
- (CGFloat)positionXOfSelectedRow:(NSInteger)row {
    CGFloat posionX = 0;
    for (NSInteger i = 0; i <= row; i ++) {
        NSString *temp = self.topArray[i];
        CGSize size;
        if (i == _selectedIndex) {
            size = [temp sizeWithAttributes:@{NSFontAttributeName : kSystemFont(16)}];
        } else {
            size = [temp sizeWithAttributes:@{NSFontAttributeName : kSystemFont(14)}];
        }
        posionX += size.width + 20.f;
    }
    return posionX;
}
- (void)refreshTopTableViewPosition:(NSIndexPath *)indexPath {
    CGFloat currentPositionX = [self positionXOfSelectedRow:indexPath.row];
    if (currentPositionX >= SCREEN_WIDTH - 120.f) {
        [self.topTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
    } else {
        [self.topTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
    _selectedIndex = indexPath.row;
    [self.topTableView reloadData];
}

#pragma mark - table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return tableView == self.topTableView ? self.topArray.count : 5;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.topTableView) {
        NSString *titleString = self.topArray[indexPath.row];
        CGSize size;
        if (indexPath.row == _selectedIndex) {
            size = [titleString sizeWithAttributes:@{NSFontAttributeName : kSystemFont(16)}];
        } else {
            size = [titleString sizeWithAttributes:@{NSFontAttributeName : kSystemFont(14)}];
        }
        return size.width + 20.f;
    } else {
        return 100;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.topTableView) {
        static NSString *identifier = @"NewsTopCell";
        NewsTopCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[NewsTopCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.contentView.transform = CGAffineTransformMakeRotation(M_PI / 2.0);
        cell.titleLabel.text = self.topArray[indexPath.row];
        if (indexPath.row == _selectedIndex) {
            cell.isSelected = YES;
        } else {
            cell.isSelected = NO;
        }
        return cell;
    } else {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.backgroundColor = (tableView.tag - 1000) % 2 == 0 ? [UIColor greenColor] : [UIColor redColor];
        return cell;
    }
}

#pragma mark - table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.topTableView) {
        [self refreshTopTableViewPosition:indexPath];
        [self.contentScrollView setContentOffset:CGPointMake(SCREEN_WIDTH * _selectedIndex, 0) animated:NO];
    }
}

#pragma mark - scroll view delegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView == self.contentScrollView) {
        NSInteger index = scrollView.contentOffset.x / SCREEN_WIDTH;
        [self refreshTopTableViewPosition:[NSIndexPath indexPathForRow:index inSection:0]];
    }
}

#pragma mark - getters
- (UITableView *)topTableView {
    if (!_topTableView) {
        _topTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 45, SCREEN_WIDTH) style:UITableViewStylePlain];
        _topTableView.center = CGPointMake(SCREEN_WIDTH / 2.0, 22.5);
        _topTableView.transform = CGAffineTransformMakeRotation(- M_PI / 2.0);
        _topTableView.backgroundColor = [UIColor clearColor];
        _topTableView.delegate = self;
        _topTableView.dataSource = self;
        _topTableView.showsVerticalScrollIndicator = NO;
        _topTableView.showsHorizontalScrollIndicator = NO;
        _topTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _topTableView;
}
- (NSMutableArray *)topArray {
    if (_topArray) {
        _topArray = [NSMutableArray arrayWithObjects:@"推荐", @"养生", @"睡眠障碍", @"焦虑症", @"测试1", @"测试2", @"测试3", @"测试4", nil];
    }
    return _topArray;
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

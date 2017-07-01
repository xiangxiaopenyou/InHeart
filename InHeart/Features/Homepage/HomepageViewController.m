//
//  HomepageViewController.m
//  InHeart
//
//  Created by 项小盆友 on 2017/5/27.
//  Copyright © 2017年 项小盆友. All rights reserved.
//

#import "HomepageViewController.h"
#import "MyDoctorsViewController.h"

#import <UIImage-Helpers.h>
#import <SDCycleScrollView.h>

@interface HomepageViewController ()<UITableViewDelegate, UITableViewDataSource, SDCycleScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UIView *topContentView;

@property (strong, nonatomic) SDCycleScrollView *cycleView;


@end

@implementation HomepageViewController

#pragma mark - view controller
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.topContentView addSubview:self.cycleView];
    [self.cycleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.topContentView);
    }];
    self.cycleView.imageURLStringsGroup = @[ @"http://img1.3lian.com/img013/v4/57/d/4.jpg"
                                                   , @"http://img1.3lian.com/img013/v4/57/d/7.jpg"
                                                   , @"http://img1.3lian.com/img013/v4/57/d/6.jpg",
                                                   @"http://img1.3lian.com/img013/v4/57/d/8.jpg",
                                                   @"http://img1.3lian.com/img013/v4/57/d/2.jpg"
                                                   ];
}
- (void)viewWillAppear:(BOOL)animated {
    [self.cycleView adjustWhenControllerViewWillAppera];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IBAction
- (IBAction)itemsAction:(id)sender {
    UIButton *button = (UIButton *)sender;
    if (button.tag == 100) {
        MyDoctorsViewController *doctorListViewController = [[UIStoryboard storyboardWithName:@"Homepage" bundle:nil] instantiateViewControllerWithIdentifier:@"MyDoctors"];
        [self.navigationController pushViewController:doctorListViewController animated:YES];
    }
}

#pragma mark - table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath.row == 0 ? 40.f : 70.f;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        static NSString *identifier = @"MoreDoctorsCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    } else {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        return cell;
    }
}

#pragma mark - Getters
- (SDCycleScrollView *)cycleView {
    if (!_cycleView) {
        _cycleView = [[SDCycleScrollView alloc] init];
        _cycleView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
        _cycleView.autoScrollTimeInterval = 5.0;
        _cycleView.currentPageDotColor = NAVIGATIONBAR_COLOR;
        _cycleView.pageDotColor = [UIColor whiteColor];
        _cycleView.delegate = self;
    }
    return _cycleView;
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

//
//  InterrogationViewController.m
//  InHeart
//
//  Created by 项小盆友 on 16/9/18.
//  Copyright © 2016年 项小盆友. All rights reserved.
//

#import "InterrogationViewController.h"
#import "LoginViewController.h"
#import "ExpertDetailViewController.h"
#import "FilterDoctorsResultTableViewController.h"

#import "DoctorCell.h"

#import "DoctorModel.h"
#import "CityModel.h"
#import "ProvinceModel.h"
#import "ContentTypeModel.h"

#import <ChineseString.h>
#import <MJRefresh.h>

@interface InterrogationViewController ()<UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIView *viewOfTopTab;
@property (weak, nonatomic) IBOutlet UIButton *areaButton;
@property (weak, nonatomic) IBOutlet UIButton *doctorsButton;
@property (weak, nonatomic) IBOutlet UIButton *diseaseButton;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewWidth;
@property (weak, nonatomic) IBOutlet UITableView *areaTableView;
@property (weak, nonatomic) IBOutlet UITableView *diseaseTableView;
@property (weak, nonatomic) IBOutlet UITableView *doctorsTableView;

@property (strong, nonatomic) UILabel *tipLabel;

@property (copy, nonatomic) NSArray *areasArray;
@property (copy, nonatomic) NSArray *areasIndexArray;
@property (copy, nonatomic) NSArray *provincesArray;
@property (copy, nonatomic) NSArray *diseaseArray;
@property (copy, nonatomic) NSArray *diseaseIndexArray;

@property (strong, nonatomic) NSMutableArray *doctorsArray;
@property (assign, nonatomic) NSInteger paging;

@end

@implementation InterrogationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"interrogation_search"] style:UIBarButtonItemStylePlain target:self action:@selector(searchSelector)];
    [self.viewOfTopTab addSubview:self.tipLabel];
    
    self.contentViewWidth.constant = SCREEN_WIDTH * 3.0;
    self.areaTableView.tableFooterView = [UIView new];
    self.diseaseTableView.tableFooterView = [UIView new];
    [self.doctorsTableView setMj_header:[MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _paging = 1;
        [self fetchDoctors];
    }]];
    [self.doctorsTableView setMj_footer:[MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self fetchDoctors];
    }]];
    self.doctorsTableView.mj_footer.hidden = YES;
    
    _paging = 1;
    [self fetchDoctors];
    [self fetchDiseases];
    [self fetchAreas];
    
}

#pragma mark - Getters
- (UILabel *)tipLabel {
    if (!_tipLabel) {
        _tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH / 6.0 - 27, 43, 54, 2)];
        _tipLabel.backgroundColor = NAVIGATIONBAR_COLOR;
    }
    return _tipLabel;
}
- (NSMutableArray *)doctorsArray {
    if (!_doctorsArray) {
        _doctorsArray = [[NSMutableArray alloc] init];
    }
    return _doctorsArray;
}

#pragma mark - private methods
- (void)updateTipLabelFrame:(CGFloat)positionX {
    [UIView animateWithDuration:0.2 animations:^{
        self.tipLabel.frame = CGRectMake(positionX, 43, 54, 2);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Requests
- (void)fetchDoctors {
    XLShowHUDWithMessage(nil, self.view);
    [DoctorModel fetchDoctorsList:nil region:nil disease:nil paging:@(_paging) handler:^(id object, NSString *msg) {
        [self.doctorsTableView.mj_header endRefreshing];
        [self.doctorsTableView.mj_footer endRefreshing];
        if (object) {
            XLDismissHUD(self.view, NO, YES, nil);
            NSArray *resultArray = [object copy];
            if (_paging == 1) {
                self.doctorsArray = [resultArray mutableCopy];
            } else {
                NSMutableArray *tempArray = [self.doctorsArray mutableCopy];
                [tempArray addObjectsFromArray:resultArray];
                self.doctorsArray = [tempArray mutableCopy];
            }
            GJCFAsyncMainQueue(^{
                [self.doctorsTableView reloadData];
                if (resultArray.count < 10) {
                    [self.doctorsTableView.mj_footer endRefreshingWithNoMoreData];
                    self.doctorsTableView.mj_footer.hidden = YES;
                } else {
                    _paging += 1;
                    self.doctorsTableView.mj_footer.hidden = NO;
                }
            });
        } else {
            XLDismissHUD(self.view, YES, NO, msg);
        }
    }];
}
- (void)fetchDiseases {
    [DoctorModel fetchDiseasesList:^(id object, NSString *msg) {
        if (object) {
            NSArray *tempArray = [object copy];
            NSMutableArray *tempMutableArray = [[NSMutableArray alloc] init];
            NSMutableArray *tempIndexArray = [[NSMutableArray alloc] init];
            for (NSDictionary *tempDictionary in tempArray) {
                NSArray *tempDiseasesArray = [ContentTypeModel setupWithArray:tempDictionary[@"array"]];
                [tempMutableArray addObject:tempDiseasesArray];
                [tempIndexArray addObject:tempDictionary[@"letter"]];
            }
            self.diseaseIndexArray = [tempIndexArray copy];
            self.diseaseArray = [tempMutableArray copy];
            GJCFAsyncMainQueue(^{
                [self.diseaseTableView reloadData];
            });
        }
    }];
}
- (void)fetchAreas {
    [DoctorModel fetchAreasList:^(id object, NSString *msg) {
        if (object) {
            self.provincesArray = [object copy];
            GJCFAsyncMainQueue(^{
                [self.areaTableView reloadData];
            });
        }
    }];
}

#pragma mark - UIScrollView Delegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView == self.scrollView) {
        if (scrollView.contentOffset.x <= 0) {
            [self doctorsButtonClick:nil];
        } else if (scrollView.contentOffset.x > 0 && scrollView.contentOffset.x <= SCREEN_WIDTH) {
            [self diseaseButtonClick:nil];
        } else {
            [self areaButtonClick:nil];
        }
    }
}
#pragma mark - UITableView Delegate DataSource
- (NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    if (tableView == self.diseaseTableView) {
        return self.diseaseIndexArray;
    } else{
        return nil;
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (tableView == self.areaTableView) {
        return self.provincesArray.count;
    } else if (tableView == self.diseaseTableView) {
        return self.diseaseIndexArray.count;
    } else {
        return 1;
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.areaTableView) {
        ProvinceModel *provinceModel = self.provincesArray[section];
        return provinceModel.array.count;
    } else if (tableView == self.diseaseTableView) {
        return [self.diseaseArray[section] count];
    } else {
        return self.doctorsArray.count;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.areaTableView) {
        static NSString *identifier = @"AreaCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
        ProvinceModel *provinceModel = self.provincesArray[indexPath.section];
        NSArray *tempArray = [provinceModel.array copy];
        CityModel *tempModel = [CityModel yy_modelWithDictionary:tempArray[indexPath.row]];
        cell.textLabel.text = [NSString stringWithFormat:@"%@", tempModel.name];
        cell.textLabel.font = XJSystemFont(13);
        cell.textLabel.textColor = XJHexRGBColorWithAlpha(0x323232, 1.0);
        return cell;
    } else if (tableView == self.diseaseTableView) {
        static NSString *identifier = @"DiseaseCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
        NSArray *tempArray = [self.diseaseArray[indexPath.section] copy];
        ContentTypeModel *tempModel = tempArray[indexPath.row];
        cell.textLabel.text = [NSString stringWithFormat:@"%@", tempModel.name];
        cell.textLabel.font = XJSystemFont(13);
        cell.textLabel.textColor = XJHexRGBColorWithAlpha(0x323232, 1.0);
        return cell;
    } else {
        static NSString *identifier = @"DoctorCell";
        DoctorCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setupContentWith:self.doctorsArray[indexPath.row]];
        return cell;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.areaTableView || tableView == self.diseaseTableView) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        if (tableView == self.diseaseTableView) {
            NSArray *tempArray = [self.diseaseArray[indexPath.section] copy];
            ContentTypeModel *tempModel = tempArray[indexPath.row];
            FilterDoctorsResultTableViewController *filterResultViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"FilterDoctors"];
            filterResultViewController.diseaseString = tempModel.name;
            filterResultViewController.filterType = 1;
            [self.navigationController pushViewController:filterResultViewController animated:YES];
        } else {
            ProvinceModel *provinceModel = self.provincesArray[indexPath.section];
            NSArray *tempArray = [provinceModel.array copy];
            CityModel *tempModel = [CityModel yy_modelWithDictionary:tempArray[indexPath.row]];
            FilterDoctorsResultTableViewController *filterResultViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"FilterDoctors"];
            filterResultViewController.cityCode = tempModel.code;
            filterResultViewController.cityName = tempModel.name;
            filterResultViewController.filterType = 2;
            [self.navigationController pushViewController:filterResultViewController animated:YES];
        }
    } else {
        ExpertDetailViewController *expertDetailController = [self.storyboard instantiateViewControllerWithIdentifier:@"ExpertDetail"];
        expertDetailController.doctorModel = self.doctorsArray[indexPath.row];
        [self.navigationController pushViewController:expertDetailController animated:YES];
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.doctorsTableView) {
        CGFloat height = 241.0;
        DoctorModel *tempModel = self.doctorsArray[indexPath.row];
        if (XLIsNullObject(tempModel.signature)) {
            height += 15;
        } else {
            CGSize mottoSize = XLSizeOfText(tempModel.signature, SCREEN_WIDTH - 155, XJSystemFont(12));
            height += mottoSize.height;
        }
        return height;
    } else {
        return 43.0;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (tableView == self.areaTableView || tableView == self.diseaseTableView) {
        return 21.0;
    } else {
        return 0;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [UIView new];
    headerView.backgroundColor = XJRGBColor(240, 240, 240, 1.0);
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 100, 21)];
    if (tableView == self.areaTableView) {
         ProvinceModel *provinceModel = self.provincesArray[section];
        label.text = [NSString stringWithFormat:@"%@", provinceModel.name];
    } else {
        label.text = self.diseaseIndexArray[section];
    }
    label.textColor = XJHexRGBColorWithAlpha(0xAAAAAA, 1.0);
    label.font = XJSystemFont(12);
    [headerView addSubview:label];
    return headerView;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - Action & Selector
- (IBAction)areaButtonClick:(id)sender {
    if (!self.areaButton.selected) {
        self.areaButton.selected = YES;
        self.diseaseButton.selected = NO;
        self.doctorsButton.selected = NO;
        [self updateTipLabelFrame:5.0 * SCREEN_WIDTH / 6.0 - 27];
        [self.scrollView setContentOffset:CGPointMake(SCREEN_WIDTH * 2, 0) animated:YES];
        if (!self.areasArray || self.areasArray.count == 0) {
            [self fetchAreas];
        }
    }
}
- (IBAction)diseaseButtonClick:(id)sender {
    if (!self.diseaseButton.selected) {
        self.areaButton.selected = NO;
        self.diseaseButton.selected = YES;
        self.doctorsButton.selected = NO;
        [self updateTipLabelFrame:SCREEN_WIDTH / 2.0 - 27];
        [self.scrollView setContentOffset:CGPointMake(SCREEN_WIDTH, 0) animated:YES];
        if (!self.diseaseArray || self.diseaseArray.count == 0) {
            [self fetchDiseases];
        }
    }
}
- (IBAction)doctorsButtonClick:(id)sender {
    if (!self.doctorsButton.selected) {
        self.areaButton.selected = NO;
        self.diseaseButton.selected = NO;
        self.doctorsButton.selected = YES;
        [self updateTipLabelFrame:SCREEN_WIDTH / 6.0 - 27];
        [self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
        if (!self.doctorsArray || self.doctorsArray.count == 0) {
            [self .doctorsTableView.mj_header beginRefreshing];
        }
    }
}
- (void)searchSelector {
    FilterDoctorsResultTableViewController *filterResultViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"FilterDoctors"];
    filterResultViewController.filterType = 3;
    [self.navigationController pushViewController:filterResultViewController animated:YES];
}

@end

//
//  FilterDoctorsResultTableViewController.m
//  InHeart
//
//  Created by 项小盆友 on 16/11/14.
//  Copyright © 2016年 项小盆友. All rights reserved.
//

#import "FilterDoctorsResultTableViewController.h"
#import "ExpertDetailViewController.h"

#import "DoctorCell.h"

#import "DoctorModel.h"

#import <MJRefresh.h>

@interface FilterDoctorsResultTableViewController ()<UIGestureRecognizerDelegate, UITextFieldDelegate>

@property (strong, nonatomic) UIView *searchView;
@property (strong, nonatomic) UITextField *searchTextField;

@property (strong, nonatomic) NSMutableArray *doctorsArray;
@property (assign, nonatomic) NSInteger paging;

@end

@implementation FilterDoctorsResultTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    switch (self.filterType) {
        case 1:{
            self.title = [NSString stringWithFormat:@"%@", self.diseaseString];
        }
            break;
        case 2:{
            self.title = [NSString stringWithFormat:@"%@", self.cityName];
        }
            break;
        case 3:{
            self.navigationItem.titleView = self.searchView;
            [self.searchTextField becomeFirstResponder];
        }
            break;
            
        default:
            break;
    }
    
    [self.tableView setMj_header:[MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _paging = 1;
        [self fetchDoctors:self.searchTextField.text];
    }]];
    [self.tableView setMj_footer:[MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self fetchDoctors:self.searchTextField.text];
    }]];
    self.tableView.mj_footer.hidden = YES;
    
    _paging = 1;
    [self fetchDoctors:nil];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.searchTextField resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Getters
- (UIView *)searchView {
    if (!_searchView) {
        _searchView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 60, 30)];
        _searchView.layer.masksToBounds = YES;
        _searchView.layer.cornerRadius = 4.0;
        _searchView.backgroundColor = kRGBColor(255, 255, 255, 0.5);
        UIImageView *searchImage = [[UIImageView alloc] initWithFrame:CGRectMake(20, 6, 18, 18)];
        searchImage.image = [UIImage imageNamed:@"content_search"];
        [_searchView addSubview:searchImage];
        [_searchView addSubview:self.searchTextField];
        
    }
    return _searchView;
}
- (UITextField *)searchTextField {
    if (!_searchTextField) {
        _searchTextField = [[UITextField alloc] initWithFrame:CGRectMake(44, 0, SCREEN_WIDTH - 104, 30)];
        _searchTextField.backgroundColor = [UIColor clearColor];
        _searchTextField.placeholder = kSearchPlaceholder;
        _searchTextField.font = kSystemFont(13);
        _searchTextField.returnKeyType = UIReturnKeySearch;
        _searchTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        [_searchTextField setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
        _searchTextField.delegate = self;
    }
    return _searchTextField;
}
- (NSMutableArray *)doctorsArray {
    if (!_doctorsArray) {
        _doctorsArray = [[NSMutableArray alloc] init];
    }
    return _doctorsArray;
}

#pragma mark - Request
- (void)fetchDoctors:(NSString *)keyword {
    XLShowHUDWithMessage(nil, self.view);
    [DoctorModel fetchDoctorsList:keyword region:self.cityCode disease:self.diseaseString paging:@(_paging) handler:^(id object, NSString *msg) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
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
            [self.tableView reloadData];
            if (resultArray.count < 10) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
                self.tableView.mj_footer.hidden = YES;
            } else {
                _paging += 1;
                self.tableView.mj_footer.hidden = NO;
            }
        } else {
            XLDismissHUD(self.view, YES, NO, msg);
        }
    }];
}

#pragma mark - UITextField Delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (XLIsNullObject(textField.text)) {
        XLShowThenDismissHUD(NO, @"请先输入关键字", self.view);
    } else {
        _paging = 1;
        [self fetchDoctors:textField.text];
        [textField resignFirstResponder];
    }
    return YES;
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.doctorsArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"DoctorCell";
    DoctorCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setupContentWith:self.doctorsArray[indexPath.row]];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = 241.0;
    DoctorModel *tempModel = self.doctorsArray[indexPath.row];
    if (XLIsNullObject(tempModel.signature)) {
        height += 15;
    } else {
        CGSize mottoSize = XLSizeOfText(tempModel.signature, SCREEN_WIDTH - 155, kSystemFont(12));
        height += mottoSize.height;
    }
    return height;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ExpertDetailViewController *expertDetailController = [self.storyboard instantiateViewControllerWithIdentifier:@"ExpertDetail"];
    expertDetailController.doctorModel = self.doctorsArray[indexPath.row];
    [self.navigationController pushViewController:expertDetailController animated:YES];
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end

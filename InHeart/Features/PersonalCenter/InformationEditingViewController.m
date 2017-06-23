//
//  InformationEditingViewController.m
//  InHeart
//
//  Created by 项小盆友 on 2017/6/19.
//  Copyright © 2017年 项小盆友. All rights reserved.
//

#import "InformationEditingViewController.h"
#import "InformationEditingCell.h"

@interface InformationEditingViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) UIBarButtonItem *rightItem;

@end

@implementation InformationEditingViewController

#pragma mark - view controller
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _rightItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(saveAction)];
    switch (self.type) {
        case XJInformationTypeName:{
            self.title = @"姓名";
            self.navigationItem.rightBarButtonItem = _rightItem;
        }
            break;
        case XJInformationTypeSex:
            self.title = @"性别";
            self.navigationItem.rightBarButtonItem = nil;
            break;
        case XJInformationTypeAge:{
            self.title = @"年龄";
            self.navigationItem.rightBarButtonItem = _rightItem;
        }
            break;
        default:
            break;
    }
    _rightItem.enabled = NO;
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    UITextField *textField = (UITextField *)[self.tableView viewWithTag:101];
    switch (self.type) {
        case XJInformationTypeName:{
            [textField becomeFirstResponder];
        }
            break;
        case XJInformationTypeSex:
            break;
        case XJInformationTypeAge:{
            textField.keyboardType = UIKeyboardTypeNumberPad;
            [textField becomeFirstResponder];
        }
            break;
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IBAction
- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)saveAction {
}
- (void)textFieldDidChanged:(UITextField *)textField {
    _rightItem.enabled = YES;
}

#pragma mark - table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.type == XJInformationTypeSex ? 2 : 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"InformationEditingCell";
    InformationEditingCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    cell.selectionStyle = self.type == XJInformationTypeSex ? UITableViewCellSelectionStyleDefault : UITableViewCellSelectionStyleNone;
    cell.textField.enabled = self.type == XJInformationTypeSex ? NO : YES;
    [cell.textField addTarget:self action:@selector(textFieldDidChanged:) forControlEvents:UIControlEventEditingChanged];
    return cell;
}

#pragma mark - table view delegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 12.f;
}

#pragma mark - getters

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

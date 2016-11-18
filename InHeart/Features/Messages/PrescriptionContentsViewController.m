//
//  PrescriptionContentsViewController.m
//  InHeart
//
//  Created by 项小盆友 on 16/11/16.
//  Copyright © 2016年 项小盆友. All rights reserved.
//

#import "PrescriptionContentsViewController.h"
#import "AdviceCell.h"
#import "PrescriptionContentCell.h"

#import "PrescriptionModel.h"
#import "ContentModel.h"

#import <GJCFUitils.h>

@interface PrescriptionContentsViewController ()<UITableViewDelegate, UITableViewDataSource, UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) UITextView *textView;
@property (strong, nonatomic) PrescriptionModel *model;

@end

@implementation PrescriptionContentsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self fetchPrescriptionContents];
    
//    UIMenuItem *menuItem1 = [[UIMenuItem alloc]initWithTitle:@"选择" action:@selector(select:)];
//    UIMenuItem *menuItem2 = [[UIMenuItem alloc]initWithTitle:@"全选" action:@selector(selectAll:)];
//    UIMenuItem *menuItem3 = [[UIMenuItem alloc]initWithTitle:@"选择" action:@selector(copy:)];
//    
//    UIMenuController *menuController = [UIMenuController sharedMenuController];
//    [menuController setMenuItems:@[menuItem1, menuItem2, menuItem3]];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UITextView *)textView {
    if (!_textView) {
        _textView = [[UITextView alloc] init];
        _textView.font = kSystemFont(14);
        _textView.textColor = TABBAR_TITLE_COLOR;
        _textView.showsVerticalScrollIndicator = NO;
        _textView.scrollEnabled = NO;
        _textView.delegate = self;
        _textView.inputView = [[UIView alloc] initWithFrame:CGRectZero];
        _textView.editable = NO;
    }
    return _textView;
}

#pragma mark - Requests
- (void)fetchPrescriptionContents {
    [SVProgressHUD show];
    [PrescriptionModel fetchPrescriptionContents:self.prescriptionId handler:^(id object, NSString *msg) {
        if (object) {
            [SVProgressHUD dismiss];
            self.model = [object copy];
            GJCFAsyncMainQueue(^{
                [self.tableView reloadData];
            });
        } else {
            XLShowThenDismissHUD(NO, msg);
        }
    }];
}

#pragma mark - UITextView Delegate

#pragma mark - UITableView Delegate DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.model ? 2 : 0;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.model ? 1 : 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        CGSize size = XLSizeOfText(self.model.suggestion, SCREEN_WIDTH - 30, kSystemFont(14));
        return size.height + 40;
    } else {
        NSArray *tempArray = [self.model.contents copy];
        if (tempArray.count == 0) {
            return 0;
        } else {
            NSInteger interger = (tempArray.count - 1) / 2 + 1;
            return interger * (kCollectionCellItemHeight + 10) + 10;
        }
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        AdviceCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AdviceCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.contentView addSubview:self.textView];
        self.textView.text = [NSString stringWithFormat:@"%@", self.model.suggestion];
        CGSize size = XLSizeOfText(self.model.suggestion, SCREEN_WIDTH - 30, kSystemFont(14));
        self.textView.frame = CGRectMake(15, 10, SCREEN_WIDTH - 30, size.height + 20);
        return cell;
    } else {
        PrescriptionContentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PrescriptionContentCell" forIndexPath:indexPath];
        NSArray *tempArray = [self.model.contents copy];
        NSArray *contentsArray = [[ContentModel class] setupWithArray:tempArray];
        [cell setupContents:contentsArray];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 36.0;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 36)];
    headerView.backgroundColor = MAIN_BACKGROUND_COLOR;
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 100, 36)];
    headerLabel.font = kSystemFont(15);
    headerLabel.textColor = MAIN_TEXT_COLOR;
    headerLabel.text = section == 0 ? @"医嘱" : @"内容";
    [headerView addSubview:headerLabel];
    return headerView;
}
- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    if (action == @selector(copy:)) {
        if (self.textView.selectedRange.length > 0) {
            return YES;
        }
    } else if (action == @selector(select:) || action == @selector(selectAll:)) {
        if (self.textView.selectedRange.length == 0) {
            return YES;
        }
    }
    return NO;
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

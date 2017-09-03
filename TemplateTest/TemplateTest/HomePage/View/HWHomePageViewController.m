//
//  HWHomePangeViewController.m
//  TemplateTest
//
//  Created by 杨庆龙 on 2017/7/25.
//  Copyright © 2017年 caijingpeng.haowu. All rights reserved.
//

#import "HWHomePageViewController.h"
#import "HPTReservationNumCell.h"
#import "HPTReservationPeopleCell.h"
#import "DashLineView.h"
#import "HPFReserverPeopleCell.h"
#import "HomePageViewModel.h"
#import "HPSiderbar.h"

#define kRemoveDashLine(super) \
        DashLineView *dashLine = [super viewWithTag:100];\
        if(dashLine) [dashLine removeFromSuperview];

#define kAddDashLine(super, offsetL, offsetR) \
        DashLineView *dashLine = [super viewWithTag:100];\
        if (!dashLine) {\
            dashLine = [[DashLineView alloc]initWithLineHeight:1 space:0.6 direction:Horizontal strokeColor:UIColorFromRGB(0xcccccc)];\
            [super addSubview:dashLine];\
            dashLine.tag = 100;\
            [dashLine mas_makeConstraints:^(MASConstraintMaker *make) {\
                make.left.equalTo(super).with.offset(kRate((offsetL)));\
                make.right.equalTo(super).with.offset(kRate(-(offsetR)));\
                make.height.mas_equalTo(kRate(1));\
                make.bottom.equalTo(super);\
            }];\
        }

@interface HWHomePageViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *listView;
@property (nonatomic, strong) HomePageViewModel *viewModel;
@property (nonatomic, strong) HPSiderbar *sidebarView;
@end

@implementation HWHomePageViewController
@dynamic viewModel;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.listView = [[UITableView alloc]initWithFrame:(CGRect){CGPointZero,self.view.width,self.view.height-(64+49)} style:UITableViewStyleGrouped];
    self.listView.dataSource = self;
    self.listView.delegate = self;
    self.listView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self addSubview:self.listView];
    
    self.sidebarView = [[HPSiderbar alloc]initWithSolidLength:kRate(280/2.0) dashedLength:kRate(132/2.0) dashedLineLength:kRate(3) dashedSapce:kRate(2)];
    [self.listView addSubview:self.sidebarView];
    
//    self.sidebarView.backgroundColor = [UIColor redColor];
}

// 数据
- (void)bindViewModel {
    [super bindViewModel];
    
    [[self.listView rac_signalForSelector:@selector(reloadData)]subscribeNext:^(id x) {
        if (self.viewModel.reserverPeoples.count) {
            NSInteger sectionOneCount = [self tableView:self.listView numberOfRowsInSection:0];
            NSInteger sectionTwoCount = [self tableView:self.listView numberOfRowsInSection:1];
            CGFloat startHeight = 0;
            CGFloat totalHeight = 0;
            for (int i=0; i<sectionOneCount; i++) {
                CGFloat currentHeight = [self tableView:self.listView heightForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
                startHeight += currentHeight;
            }
            totalHeight = startHeight += [self tableView:self.listView heightForFooterInSection:0]+[self tableView:self.listView heightForHeaderInSection:1];
            
            for (int j=0; j<sectionTwoCount; j++) {
                CGFloat currentHeight = [self tableView:self.listView heightForRowAtIndexPath:[NSIndexPath indexPathForRow:j inSection:1]];
                totalHeight += currentHeight;
            }
            CGFloat offsetY = kRate(45);
            self.sidebarView.frame = CGRectMake(0, startHeight+offsetY, kRate(55), totalHeight-startHeight-2*offsetY);
            [self.sidebarView.reloadCommand execute:self.viewModel.reserverPeoples];
        }
    }];
    @weakify(self);
    if (self.viewModel.requestCommand) {
        [[self.viewModel.requestCommand execute:nil]subscribeError:^(id x) {
            @strongify(self);
            [self.listView reloadData];
        }];
    }
    
    /*
    */
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return section==0?0.000000001:kRate(35);
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return section==0?(self.viewModel.reserverPeoples.count==0?0.0000001:kRate(10)):0.0000001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:
            return indexPath.row==0?kRate(290/2.0):kRate(190/2.0);
            break;
            
        default:
            return kRate(104);
            break;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.viewModel.reserverPeoples.count==0?1:2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return section==0?3:self.viewModel.reserverPeoples.count;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if(section == 0) return nil;
    UIView *headView = [[UIView alloc]init];
    
    UILabel *titleLabel = [UILabel new];
    UIView *signView = [UIView new];
    [headView addSubview:titleLabel];
    [headView addSubview:signView];
    
    signView.frame = CGRectMake(kRate(15), kRate(15), kRate(4), kRate(18));
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(signView.mas_right).with.offset(kRate(6));
        make.centerY.equalTo(signView);
    }];
    
    signView.layer.backgroundColor = CD_MainColor.CGColor;
    signView.layer.cornerRadius = signView.width/2.0;
    titleLabel.text = kHomePage_TITLE2;
    titleLabel.font = FONT(TF14);
    headView.backgroundColor = COLOR_FFFFFF;
    [headView drawTopLine];
    
    return headView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:
            switch (indexPath.row) {
                case 0:
                {// 今日预约状况
                    NSString *cellId = @"HPTReservationNumCell";
                    HPTReservationNumCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
                    if (cell == nil) {
                        cell = [[HPTReservationNumCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
                    }
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    kAddDashLine(cell, 15, 15);
                    return cell;
                }
                    break;
                    
                default:
                {// 今日病人
                    NSString *cellId = @"HPTReservationPeopleCell";
                    HPTReservationPeopleCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
                    if (cell == nil) {
                        cell = [[HPTReservationPeopleCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
                    }
                    kAddDashLine(cell, 15, 15);
                    return cell;
                }
                    break;
            }
            break;
            
        default:
        {
            NSString *cellId = @"HPFReserverPeopleCell";
            HPFReserverPeopleCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
            if (cell == nil) {
                cell = [[HPFReserverPeopleCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
            }
            kAddDashLine(cell, 156/2.0, 15);
            cell.signal = [RACSignal return:@[[self.viewModel.reserverPeoples objectAtIndex:indexPath.row]]];
            return cell;
        }
            break;
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

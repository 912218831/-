//
//  HWPeopleCenterViewController.m
//  TemplateTest
//
//  Created by 杨庆龙 on 2017/7/25.
//  Copyright © 2017年 caijingpeng.haowu. All rights reserved.
//

#import "HWPeopleCenterViewController.h"
#import "HWPeopleCenterViewModel.h"
#import "HWLoginViewController.h"
#import "HWPeopleCenterHeadView.h"
#import "HWPeopleCenterCell.h"
#import "SetPasswordViewModel.h"

@interface HWPeopleCenterViewController ()<UIScrollViewDelegate>
@property (nonatomic, strong) HWPeopleCenterViewModel *viewModel;
@property (nonatomic, strong) UIScrollView *listView;
@property (nonatomic, strong) HWPeopleCenterHeadView *headView;
@property (nonatomic, strong) UILabel *titleLabel;
@end

@implementation HWPeopleCenterViewController
@dynamic viewModel;


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:true animated:true];
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    self.listView.contentInset = UIEdgeInsetsZero;
}

- (void)bindViewModel {
    [super bindViewModel];
    [self.viewModel bindViewWithSignal];
    
    [self.viewModel.requestSignal subscribeError:^(id x) {
        [self.headView.headerImageView sd_setImageWithURL:self.viewModel.headImageUrl];
        self.headView.phoneLabel.text = self.viewModel.userPhone;
        self.headView.nameLabel.text = self.viewModel.userName;
    }];
}

- (void)configContentView {
    [super configContentView];
    
    @weakify(self);
    
    self.listView = [[UIScrollView alloc]initWithFrame:self.bounds];
    self.listView.delegate = self;
    self.listView.contentSize = self.bounds.size;
    self.listView.alwaysBounceVertical = true;
    [self addSubview:self.listView];
    self.listView.backgroundColor = CD_LIGHT_BACKGROUND;
    
    self.headView = [[HWPeopleCenterHeadView alloc]init];
    self.headView.frame = CGRectMake(0, 0, self.listView.width, kRate(249));
    [self.listView addSubview:self.headView];
    
    HWPeopleCenterCell *cell = [[HWPeopleCenterCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellId"];
    cell.frame = CGRectMake(0, kRate(249), self.listView.width, kRate(176));
    [self.listView addSubview:cell];
    @weakify(cell);
    [[cell rac_signalForSelector:@selector(touchesBegan:withEvent:)]subscribeNext:^(RACTuple *x) {
        @strongify(cell,self);
        UIEvent *event = x.last;
        UITouch *touch = event.allTouches.anyObject;
        CGPoint eventPoint = [touch locationInView:cell];
        BOOL eventContain = CGRectContainsPoint(kSetPasswordControlRect(cell), eventPoint);
        if (eventContain) {
            // 跳转到设置密码页面
            SetPasswordViewModel *vm = [SetPasswordViewModel new];
            vm.phoneNumberStr = self.viewModel.userPhone;
            [[ViewControllersRouter shareInstance]pushViewModel:vm animated:true];
        }
    }];
    
    self.titleLabel = [UILabel new];
    self.titleLabel.backgroundColor = [UIColor clearColor];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.font = BOLDFONT(19);
    self.titleLabel.textColor = COLOR_FFFFFF;
    self.titleLabel.text = @"设置";
    [self addSubview:self.titleLabel];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).with.offset(20);
        make.left.right.equalTo(self.contentView);
        make.height.mas_equalTo(44);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end

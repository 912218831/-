//
//  HPTReservationNumCell.m
//  TemplateTest
//
//  Created by HW on 17/9/3.
//  Copyright © 2017年 caijingpeng.haowu. All rights reserved.
//

#import "HPTReservationNumCell.h"
#import "DashLineView.h"

@interface HPTReservationNumCell ()
@property (nonatomic, strong) UIView *signView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) DashLineView *dashLine;
@end

@implementation HPTReservationNumCell

- (void)initSubViews {
    self.signView = [UIView new];
    [self addSubview:self.signView];
    
    self.titleLabel = [UILabel new];
    [self addSubview:self.titleLabel];
    
    self.waitAffirmBtn = [[DoubleLabelButton alloc]initWithTopHeight:kRate(54/2.0) spaceY:kRate(10)];
    [self addSubview:self.waitAffirmBtn];
    
    self.reserveredBtn = [[DoubleLabelButton alloc]initWithTopHeight:kRate(54/2.0) spaceY:kRate(10)];
    [self addSubview:self.reserveredBtn];
    
    self.dashLine = [[DashLineView alloc]initWithLineHeight:1 space:0 direction:Vertical strokeColor:UIColorFromRGB(0xcccccc)];
    [self addSubview:self.dashLine];
}

- (void)layoutSubViews {
    self.signView.frame = CGRectMake(kRate(15), kRate(16), kRate(4), kRate(18));
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.signView);
        make.left.equalTo(self.signView.mas_right).with.offset(kRate(6));
    }];
    [self.waitAffirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self).with.offset(-kScreenWidth/4.0);
        make.bottom.equalTo(self).with.offset(-kRate(66/2.0));
        make.height.mas_equalTo(kRate(102/2.0));
    }];
    
    [self.reserveredBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self).with.offset(kScreenWidth/4.0);
        make.bottom.equalTo(self.waitAffirmBtn);
        make.height.equalTo(self.waitAffirmBtn);
    }];
    
    [self.dashLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).with.offset(kRate(124/2.0));
        make.bottom.equalTo(self).with.offset(-kRate(66/2.0));
        make.width.mas_equalTo(kRate(1));
        make.centerX.equalTo(self);
    }];
    
    self.dashLine.backgroundColor = [UIColor clearColor];
}

- (void)initDefaultConfigs {
    self.signView.layer.cornerRadius = self.signView.width/2.0;
    self.signView.layer.backgroundColor = CD_MainColor.CGColor;
    
    self.titleLabel.text = kHomePage_TITLE1;
    self.titleLabel.font = FONT(TF14);
    self.titleLabel.textColor = CD_Text;
    
    self.waitAffirmBtn.topLabel.text = @"";
    self.waitAffirmBtn.bottomLabel.text = @"待确认预约";
    self.reserveredBtn.topLabel.text = @"";
    self.reserveredBtn.bottomLabel.text = @"已预约";
    
}

- (void)bindSignal {
    @weakify(self);
    [self.waitAffirmSignal subscribeNext:^(id x) {
        @strongify(self);
        self.waitAffirmBtn.topLabel.text = x;
    }];
    [self.reserveredSignal subscribeNext:^(id x) {
        @strongify(self);
        self.reserveredBtn.topLabel.text = x;
    }];
}

@end

//
//  HPFReserverPeopleCell.h
//  TemplateTest
//
//  Created by HW on 17/9/3.
//  Copyright © 2017年 caijingpeng.haowu. All rights reserved.
//

#import "BaseListViewCell.h"
#import "HPReserverPeopleModel.h"

@interface HPFReserverPeopleCell : BaseListViewCell
@property (nonatomic, strong) RACSignal *signal;
@property (nonatomic, strong) RACCommand *tapCommand;
@end

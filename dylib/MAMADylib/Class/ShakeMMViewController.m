//
//  ShakeMMViewController.m
//  testHookDylib
//
//  Created by 朱德坤 on 2019/1/10.
//  Copyright © 2019 DKJone. All rights reserved.
//

#import "ShakeMMViewController.h"
#import <objc/objc-runtime.h>
#import "ShakeMMHelper.h"
#import "ShakeMMHelperConfig.h"

@interface MMTabBarController : UITabBarController
- (void)showTabBar;
- (void)hideTabBar;
@end

@interface ShakeMMViewController ()
<
UITableViewDataSource,
UITableViewDelegate
>

@property (nonatomic, strong) UITableView   *tableView;

@end

@implementation ShakeMMViewController

-(instancetype)init{
    if (self = [super init]) {
//        helper = [[objc_getClass("MMUIViewController") alloc] init];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"助手";
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = [ShakeMMHelper leftNavigationItem];
    
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:_tableView];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    UIView *footerView = [[UIView alloc] init];
    footerView.backgroundColor=[UIColor clearColor];
    [_tableView setTableFooterView:footerView];
    
    
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];

}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

-(void)dealloc{
    self.tableView.delegate = nil;
    self.tableView.dataSource = nil;
}

#pragma mark --TableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString* reuseIdentifierCell0 = @"cell0";
    static NSString* reuseIdentifierCell1 = @"cell1";
    static NSString* reuseIdentifierCell2 = @"cell2";
    
    if (indexPath.row == 0) {
        
        UITableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:reuseIdentifierCell0];
        if (cell == nil) {
            cell= [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifierCell0];
    
            cell.textLabel.text = @"后台运行(耗电)";
            UISwitch *switch1 = [[UISwitch alloc] initWithFrame:CGRectMake(300, 13, 0, 0)];
            [cell.contentView addSubview:switch1];
            switch1.on = [ShakeMMHelperConfig shared].canBgRunning;
            [switch1 addTarget:self action:@selector(changeBgRunSwich:) forControlEvents:UIControlEventValueChanged];
        }
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell;
    }
    else if (indexPath.row == 1) {
        
        UITableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:reuseIdentifierCell1];
        if (cell == nil) {
            cell= [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifierCell1];
            
            cell.textLabel.text = @"选择语音";
            UISegmentedControl *segment = [[UISegmentedControl alloc] initWithItems:@[@"百度",@"原生"]];
            segment.frame = CGRectMake(200, 13, 150, 30);
            if ([ShakeMMHelperConfig shared].speakType == ShakeMMHelperConfigSpeakTypeBaiDu) {
                segment.selectedSegmentIndex = 0;
            }else if ([ShakeMMHelperConfig shared].speakType == ShakeMMHelperConfigSpeakTypeAV){
                segment.selectedSegmentIndex = 1;
            }
            [cell.contentView addSubview:segment];
            [segment addTarget:self action:@selector(changeSpeakSwich:) forControlEvents:UIControlEventValueChanged];
        }
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell;
    }
    else if (indexPath.row == 2) {
        
        UITableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:reuseIdentifierCell2];
        if (cell == nil) {
            cell= [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifierCell2];
            
            cell.textLabel.text = @"前台红包播报";
            UISwitch *switch1 = [[UISwitch alloc] initWithFrame:CGRectMake(300, 13, 0, 0)];
            [cell.contentView addSubview:switch1];
            switch1.on = [ShakeMMHelperConfig shared].activeRedBaoPlay;
            [switch1 addTarget:self action:@selector(changeActiveRedBaoPlaySwich:) forControlEvents:UIControlEventValueChanged];
        }
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell;
    }
    
    
    return [UITableViewCell new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
        return 57;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

}

#pragma mark - Action
-(void)changeBgRunSwich:(UISwitch *)switchView
{
    if (switchView.isOn)
    {
        switchView.on = NO;
        [ShakeMMHelperConfig shared].canBgRunning = NO;
    }
    else
    {
        switchView.on = YES;
        [ShakeMMHelperConfig shared].canBgRunning = YES;
    }
}
-(void)changeSpeakSwich:(UISegmentedControl *)speakSegment
{
    [ShakeMMHelperConfig shared].speakType = speakSegment.selectedSegmentIndex;
}
-(void)changeActiveRedBaoPlaySwich:(UISwitch *)switchView
{
    if (switchView.isOn)
    {
        switchView.on = NO;
        [ShakeMMHelperConfig shared].activeRedBaoPlay = NO;
    }
    else
    {
        switchView.on = YES;
        [ShakeMMHelperConfig shared].activeRedBaoPlay = YES;
    }
}



//
//// 没法设置父类，设置消息转发以调用相关类方法
//- (MMUIViewController *) forwardingTargetForSelector:(SEL)aSelector {
//    if ([helper respondsToSelector:aSelector]) {
//        return helper;
//    }
//    return nil;
//}




@end

//
//  AppHeader.h
//  AppHeader
//
//  Created by weiliang.sun on 16/10/11.
//  Copyright © 2016年 weiliang.soon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface BaseMsgContentViewController : UIViewController

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath ;
- (void)onDoubleClick;

@end


@interface ChatTableViewCell : UITableViewCell
@property (nonatomic,strong) UIView *cellView;
@end


@interface TextStyle : NSObject
@property (nonatomic,strong) NSString *nsContent;
@end

@interface TextMessageViewModel : NSObject
@property (nonatomic,strong) NSMutableArray *contentTextStyles;
@end


@interface TextMessageCellView : UIView
@property (nonatomic,strong) TextMessageViewModel *viewModel;
//双击
- (void)onDoubleTapTranslateView:(id)arg1;
@end






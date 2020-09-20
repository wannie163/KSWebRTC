//
//  KSChatController.h
//  Telegraph
//
//  Created by saeipi on 2020/8/17.
//

#import "KSSuperController.h"
#import "KSConfigure.h"
#import "KSCallState.h"

@interface KSChatController : KSSuperController

/// 进入通话页面
/// @param type 通话类型
/// @param callState 通话状态
/// @param isCaller 是否创建呼叫（主叫）
/// @param room 房间号
/// @param target 跳转控制器
+ (void)callWithType:(KSCallType)type callState:(KSCallStateMaintenance)callState isCaller:(BOOL)isCaller room:(int)room target:(UIViewController *)target;

@end

//
//  qqAdvice.m
//  qqAdvice_plugin
//
//  Created by EadkennyChan on 16/9/14.
//  Copyright © 2016年 EadkennyChan. All rights reserved.
//

#import "QQAdvice.h"
#import <TencentOpenAPI/QQApiInterfaceObject.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>

@interface QQAdvice ()

@end

@implementation QQAdvice

- (void)openQQ:(CDVInvokedUrlCommand*)command
{
#ifdef DEBUG
    NSLog(@"qqAdvice plugin call succeed. write by zwchen");
#endif
    NSString *strQQ;
    if([command.arguments count] > 0)
    {
        strQQ = [command argumentAtIndex:0 withDefault:[NSNull null]];
    }
    TencentOAuth *tencentOAuth = [[TencentOAuth alloc] initWithAppId:@"1105693226" andDelegate:self];
    tencentOAuth.redirectURI = @"www.qq.com";
    
    if (strQQ.length == 0)
        strQQ = @"1090928206";
    QQApiWPAObject *wpaObj = [QQApiWPAObject objectWithUin:strQQ];
    SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:wpaObj];
    QQApiSendResultCode sent = [QQApiInterface sendReq:req];
    
    CDVPluginResult *resultPlugin;
    NSString *strMsg = [self handleSendResult:sent];
    if (strMsg.length > 0)
    {
        resultPlugin = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    }
    else
    {
        resultPlugin = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:strMsg];
    }
    [self sendPluginResult:resultPlugin to:command.callbackId];
}

- (NSString *)handleSendResult:(QQApiSendResultCode)sendResult
{
    NSString *strMsg;
    switch (sendResult)
    {
        case EQQAPIAPPNOTREGISTED:
        {
            strMsg = @"App未注册";
            break;
        }
        case EQQAPIMESSAGECONTENTINVALID:
        case EQQAPIMESSAGECONTENTNULL:
        case EQQAPIMESSAGETYPEINVALID:
        {
            strMsg = @"发送参数错误";
            break;
        }
        case EQQAPIQQNOTINSTALLED:
        {
            strMsg = @"未安装手Q";
            break;
        }
        case EQQAPIQQNOTSUPPORTAPI:
        {
            strMsg = @"API接口不支持";
            break;
        }
        case EQQAPISENDFAILD:
        {
            strMsg = @"发送失败";
            break;
        }
//        case EQQAPIVERSIONNEEDUPDATE:
//        {
//            strMsg = @"当前QQ版本太低，需要更新";
//            break;
//        }
        default:
        {
            strMsg = nil;
            break;
        }
    }
    return strMsg;
}

@end

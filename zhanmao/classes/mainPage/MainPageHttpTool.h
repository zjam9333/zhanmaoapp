//
//  MainPageHttpTool.h
//  zhanmao
//
//  Created by bangju on 2017/11/15.
//  Copyright © 2017年 bangju. All rights reserved.
//

#import "ZZHttpTool.h"
#import "ExhibitionModel.h"
#import "MainMsgModel.h"

@interface MainPageHttpTool : ZZHttpTool

+(void)getCustomShowingListByType:(NSInteger)type cache:(BOOL)cache success:(void(^)(NSArray* result))success failure:(void(^)(NSError* error))failure;

+(void)getCustomShowingCaseListByCid:(NSInteger)cid cache:(BOOL)cache success:(void(^)(NSArray* result))success failure:(void(^)(NSError* error))failure;

+(void)getNewExhibition:(void(^)(ExhibitionModel* exh))success cache:(BOOL)cache failure:(void(^)(NSError* error))failure;

+(void)getNewMessagesPage:(NSInteger)page pageSize:(NSInteger)pagesize cached:(BOOL)cache success:(void(^)(NSArray* result))success failure:(void(^)(NSError* error))failure;

@end

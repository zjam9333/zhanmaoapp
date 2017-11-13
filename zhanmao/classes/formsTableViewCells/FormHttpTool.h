//
//  FormHttpTool.h
//  zhanmao
//
//  Created by bangju on 2017/11/9.
//  Copyright © 2017年 bangju. All rights reserved.
//

#import "ZZHttpTool.h"
#import "BaseFormStepsModel.h"

@interface FormHttpTool : ZZHttpTool

+(void)getCustomTableListByType:(NSInteger)type success:(void (^)(BaseFormStepsModel* step))success failure:(void (^)(NSError *err))failure;

+(void)postCustomTableListByType:(NSInteger)type params:(NSDictionary*)params success:(void (^)(BOOL result, NSString* msg))success failure:(void(^)(NSError* err))failure;

@end

//
//  NSObject+AsrManger.h
//  Runner
//
//  Created by Ade on 2019/11/1.
//  Copyright © 2019年 The Chromium Authors. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (AsrManger)
typedef void (^AsrCallback)(NSString* message);
+(instancetype)initWith:(AsrCallback)success failure:
(AsrCallback)failure;
-(void)start;
-(void)stop;
-(void)cancel;

@end


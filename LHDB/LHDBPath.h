//
//  LHDBPath.h
//  LHDBDemo
//
//  Created by 3wchina01 on 16/2/26.
//  Copyright © 2016年 李浩. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LHDBPath : NSObject

@property (nonatomic,strong) NSString* dbPath;

+ (instancetype)instanceManagerWith:(NSString*)dbPath;

@end

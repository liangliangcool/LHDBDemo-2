//
//  Model.h
//  ChatView
//
//  Created by 李浩 on 16/1/8.
//  Copyright © 2016年 吴朋. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UIImage;
@interface Model : NSObject

@property (nonatomic,strong) NSString* name;

@property (nonatomic,assign) int age;

@property (nonatomic,strong) UIImage* image;

@property (nonatomic,strong) NSDate* date;

@property (nonatomic,strong) NSDictionary* message;

@property (nonatomic,strong) NSData* data;
@end

//
//  ViewController.m
//  LHDBDemo
//
//  Created by 李浩 on 16/1/9.
//  Copyright © 2016年 李浩. All rights reserved.
//

#import "ViewController.h"
#import "LHDB.h"
#import "Model.h"
#import "Cat.h"

@interface ViewController ()
@property (nonatomic,strong) NSMutableData* data;

@end

@implementation ViewController
{
    LHDBQueue* queue;
}

- (NSMutableData*)data
{
    if (!_data) {
        _data = [NSMutableData data];
    }
    return _data;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /*
     LHDB是基于底层sqlite3框架,完全对象存储的数据库操作库;
     目前之前类型：NSString,NSNumber,各种基本类型,NSData,NSDate,UIImage,NSArray(目前只支持存放字符串和NSNumber对象),NSDictionary(目前只支持存放字符串和NSNumber对象);
     */
    
    /*
     LHDB内部两种调用方式：
     一种是非队列执行,就是普通执行无法保证在多线程环境下数据库锁住问题；
     另一种就是队列执行,所有执行任务都会在一个唯一的队列中执行，完全保证在一个时间内只会有一个线程操作数据库；
     */
    
    /*
     LHModelStateMent.h :这个类是对封装sql语句;
     LHDataBaseExecute.h :所有的数据库操作都由这个类完成;
     LHPredicate.h :用来确定要操作的范围和查询的排序规则,类似NSPredicate;
     LHDBQueue.h :封装一层队列,保证数据库的线程安全;
     NSObject+LHModelOperation.h :用于解析model;
     LHDBPath.h :用于确定操作的数据库路劲,在没有初始化此对象之前LHDB默认一个数据库路径,如果在使用过程中需要切换数据库,需要使用此类的单例确定数据库路径;
     NSObject+LHDB.h :使用类别,所有外部需要操作数据库都要使用这个类中的方法;
     */
    
    
    /*
        下面所有操作的数据库路径都是类别中默认的，如果需要切换数据库路径
     */
    
    //LHDBPath* path = [LHDBPath instanceManagerWith: yourPath ];
    
    /*
     普通操作(无队列操作)
     */

    //建表   表名:"Model"  字段名就是类中的属性名;
    [Model createTable];
    
    //如果在一个已经存在的表中增加字段 现在对Model增加age字段
    [Model addColum:@"age"];
    
    //构建一个Model对象,然后插入数据库
    Model* saveModel = [[Model alloc] init];
    saveModel.name = @"张三";
    saveModel.date = [NSDate date];
    saveModel.message = @{@"name":@"张三",@"身高":[NSNumber numberWithInt:180]};
    saveModel.image = [UIImage imageNamed:@"123@2x"];
    [saveModel save];
    
    //查询Model表中name = 张三的数据
    LHPredicate* predicate = [LHPredicate predicateWithFormat:@"name = '%@'",@"张三"];//注意 如果是%@ 需要在%@旁边加'';
    NSArray* selectArray1 = [Model selectWithPredicate:predicate];
    NSLog(@"selectArray1 = %@",selectArray1);
    
    //如果查询结果需要排序
    LHPredicate* predicate1 = [LHPredicate predicateWithFormat:@"name = '%@'",@"张三"];
    predicate1.sortString = @"name asc";//对name进行升序"desc"降序
    NSArray* selectArray2 = [Model selectWithPredicate:predicate1];
    NSLog(@"selectArray2 = %@",selectArray2);
    
    //将Model中name = 张三的数据更新
    LHPredicate* updatePredicate = [LHPredicate predicateWithFormat:@"name = '%@'",@"张三"];
    Model* updateModel = [[Model alloc] init];
    updateModel.name = @"李四";
    updateModel.message = @{@"name":@"李四",@"身高":[NSNumber numberWithInt:190]};
    [updateModel updateWithPredicate:updatePredicate];
    //查询Model表中所有的数据
    NSArray* updateArray = [Model selectWithPredicate:nil];
    NSLog(@"updateArray = %@",updateArray);
    
    //删除数据
    LHPredicate* deletePredicate = [LHPredicate predicateWithFormat:@"name = ‘李四’"];
    [Model deleteWithPredicate:deletePredicate];
    
    
    
    /*
     inQueue执行 线程安全
     */
    //建表
    [Cat inQueueCreateTable];//异步
    
    //插入
    Cat* cat = [[Cat alloc] init];
    cat.name = @"汤姆";
    cat.array = @[@"1",@"2",@"3"];//数组和字典目前只支持存放字符串和NSNumber
    
    [cat inQueueSave];
    
    [Cat inQueueSelectWithPredicate:nil result:^(NSArray *resultArray) {
        NSLog(@"inqueue = %@",resultArray);
    }];
    //更新
    Cat* cat2 = [[Cat alloc] init];
    cat2.name = @"小花";
    cat2.array = nil;
    LHPredicate* inqueuePredicate = [LHPredicate predicateWithString:@"name = '汤姆'"];
    [cat2 inQueueUpdateWithPredicate:inqueuePredicate];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

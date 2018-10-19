//
//  ViewController.m
//  GCD_Demo
//
//  Created by 左晓东 on 2018/10/19.
//  Copyright © 2018年 左晓东. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    dispatch_queue_t seriorQuene = dispatch_queue_create("com.seriorQueue", DISPATCH_QUEUE_SERIAL);
    dispatch_queue_t concurrentQueue = dispatch_queue_create("concurrentQueue", DISPATCH_QUEUE_CONCURRENT);
    dispatch_queue_t mainQuene = dispatch_get_main_queue();
    dispatch_queue_t globalQueue = dispatch_get_global_queue(0, 0);
    NSLog(@"任务开始 %@",[NSThread currentThread]);
    
    //同步 串行  在主线程中按照顺序执行。
    //这里，如果seriorQueue 换成 mainQueue 则会造成死锁 崩溃
    __block int x = 1;
    dispatch_sync(seriorQuene, ^{
        x++;
        NSLog(@"%d = %@",x,[NSThread currentThread]);
    });
    dispatch_sync(seriorQuene, ^{
        x++;
        NSLog(@"%d = %@",x,[NSThread currentThread]);
    });
    dispatch_sync(seriorQuene, ^{
        x++;
        NSLog(@"%d = %@",x,[NSThread currentThread]);
    });
    NSLog(@"x =%d",x);
    // 同步串行
    
    
    //同步并行  所有任务都只能在主线程中执行,函数在执行时，必须按照代码的书写顺序一行一行地执行完才能继续.在这里即便是并行队列，任务可以同时执行，但是由于只存在一个主线程，所以没法把任务分发到不同的线程去同步处理，其结果就是只能在主线程里按顺序挨个挨个执行了.
    //        dispatch_sync(concurrentQueue, ^{
    //            NSLog(@"1 = %@",[NSThread currentThread]);
    //        });
    //    dispatch_sync(concurrentQueue, ^{
    //       NSLog(@"2 = %@",[NSThread currentThread]);
    //    });
    //    dispatch_sync(concurrentQueue, ^{
    //        NSLog(@"3 = %@",[NSThread currentThread]);
    //    });
    //同步并行
    
    
    // 异步串行  异步执行意味可以开启新线程，任务可以先绕过不执行，回过头来再执行。串行队列必须按照顺序执行。两者结合的结果就是 : 开启一个新的线程，函数在执行时，先打印 任务开始  再按照顺序执行队列中的任务  任务结束的打印 会在某一时刻执行
    //     dispatch_async(seriorQuene, ^{
    //          NSLog(@"1 = %@",[NSThread currentThread]);
    //     });
    //    dispatch_async(seriorQuene, ^{
    //        NSLog(@"2 = %@",[NSThread currentThread]);
    //    });
    //    dispatch_async(seriorQuene, ^{
    //        NSLog(@"3 = %@",[NSThread currentThread]);
    //    });
    //异步串行
    
    
    //异步并行  异步执行意味着，可以开启新的线程，任务可以先绕过不执行，回头再来执行，并行队列意味着，任务之间不需要排队，且具有同时被执行的“权利”，两者结合: 开了三个新线程,这三个任务是同时执行的，没有先后
    //    dispatch_async(concurrentQueue, ^{
    //       NSLog(@"1 = %@",[NSThread currentThread]);
    //    });
    //    dispatch_async(concurrentQueue, ^{
    //        NSLog(@"2 = %@",[NSThread currentThread]);
    //    });
    //    dispatch_async(concurrentQueue, ^{
    //        NSLog(@"3 = %@",[NSThread currentThread]);
    //    });
    //异步并行
    
    //同步主队列 线程阻塞 死锁 崩溃
    //        dispatch_sync(mainQuene, ^{
    //            NSLog(@"1 = %@",[NSThread currentThread]);
    //        });
    //    dispatch_sync(mainQuene, ^{
    //       NSLog(@"2 = %@",[NSThread currentThread]);
    //    });
    //    dispatch_sync(mainQuene, ^{
    //       NSLog(@"3 = %@",[NSThread currentThread]);
    //    });
    //同步主队列
    
    //异步主队列 同异步串行，但是当前队列为主线程
    //    dispatch_async(mainQuene, ^{
    //        NSLog(@"1 = %@",[NSThread currentThread]);
    //    });
    //    dispatch_async(mainQuene, ^{
    //       NSLog(@"2 = %@",[NSThread currentThread]);
    //    });
    //    dispatch_async(mainQuene, ^{
    //       NSLog(@"3 = %@",[NSThread currentThread]);
    //    });
    //异步主队列
    
    //全局异步并行  系统创建的 默认的并行队列
    //    for (int i = 0; i<10; i++) {
    //        dispatch_async(globalQueue, ^{
    //            NSLog(@"%d = %@",i,[NSThread currentThread]);
    //        });
    //    }
    //全局并行
    
    //线程通信
    //    dispatch_async(globalQueue, ^{
    //        for (int i = 0; i<5; i++) {
    //            NSLog(@"子线程 处理==%d",i);
    //        }
    //        dispatch_async(mainQuene, ^{
    //            NSLog(@"主线程 刷新");
    //        });
    //    });
    
    
    //dispatch barrer 栅栏
    //    for (int i = 0; i<10; i++) {
    //        dispatch_async(globalQueue, ^{
    //            NSLog(@"%d = %@",i,[NSThread currentThread]);
    //        });
    //        if (i==4) {
    //            dispatch_barrier_async(globalQueue, ^{
    //                NSLog(@"栅栏 %@",[NSThread currentThread]);
    //            });
    //        }
    //    }
    
    
    //延迟执行
    //    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    //        NSLog(@"延迟3秒 执行");
    //    });
    
    
    //队列组
    //    dispatch_group_t groupQueue = dispatch_group_create();
    //    dispatch_group_async(groupQueue, globalQueue, ^{
    //        NSLog(@"异步 队列组1");
    //    });
    //    dispatch_group_async(groupQueue, globalQueue, ^{
    //        NSLog(@"异步 队列组2");
    //    });
    //    dispatch_group_async(groupQueue, globalQueue, ^{
    //        NSLog(@"异步 队列组3");
    //    });
    //
    //dispatch_group_notify(groupQueue, mainQuene, ^{
    //    NSLog(@"执行主队列");
    //});
    NSLog(@"任务结束  %@",[NSThread currentThread]);
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

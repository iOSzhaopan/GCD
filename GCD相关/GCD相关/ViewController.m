//
//  ViewController.m
//  GCD相关
//
//  Created by miaolin on 16/6/8.
//  Copyright © 2016年 赵攀. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self apply];
}

- (void)apply {
    dispatch_apply(10, dispatch_get_global_queue(0, 0), ^(size_t index) {
        NSLog(@"----%zu", index);
    });
}

/**
 *  延迟
 */
- (void)after {
    NSLog(@"-------");
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSLog(@"执行-----%@", [NSThread currentThread]);
    });
}

/**
 *  队列组
 */
- (void)group {
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_group_async(group, queue, ^{
        NSLog(@"1------%@", [NSThread currentThread]);
    });
    dispatch_group_async(group, queue, ^{
        NSLog(@"2------%@", [NSThread currentThread]);
    });
    dispatch_group_notify(group, queue, ^{
        NSLog(@"2------%@", [NSThread currentThread]);
        dispatch_sync(dispatch_get_main_queue(), ^{
            NSLog(@"2------%@", [NSThread currentThread]);
        });
    });
}

/**
 *  围栏: 注意不能放在全局并发队列
 */
- (void)barrier {
    dispatch_queue_t queue = dispatch_queue_create("xxxx", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(queue, ^{
        NSLog(@"1------%@", [NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"2------%@", [NSThread currentThread]);
    });
    dispatch_barrier_async(queue, ^{
        NSLog(@"barrier-------");
    });
    dispatch_async(queue, ^{
        NSLog(@"3------%@", [NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"4------%@", [NSThread currentThread]);
    });
}

/**
 * 异步函数 + 并发队列
 */
- (void)asyncConcurrent {
    //全局并发队列
    //如果自己创建并发队列
    //dispatch_queue_t queue = dispatch_queue_create("zp.com.queue", DISPATCH_QUEUE_CONCURRENT);
    NSLog(@"---------begin");
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSLog(@"1------%@", [NSThread currentThread]);
    });
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSLog(@"2------%@", [NSThread currentThread]);
    });
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSLog(@"3------%@", [NSThread currentThread]);
    });
    NSLog(@"---------end");
}

/**
 *  异步函数 + 串行队列: 可以开线程，但是是按照顺序执行的(如果串行队列是主队列，则不开线程)
 */
- (void)asyncSerial {
    NSLog(@"---------begin");
    //自己创建的串行队列
    dispatch_queue_t queue = dispatch_queue_create("zp.com.queue", DISPATCH_QUEUE_SERIAL);
//    dispatch_queue_t queue = dispatch_get_main_queue();
    dispatch_async(queue, ^{
        NSLog(@"1------%@", [NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"2------%@", [NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"3------%@", [NSThread currentThread]);
    });
    NSLog(@"---------end");
}

- (void)syncConcurrent {
    NSLog(@"---------begin");
//    dispatch_queue_t queue = dispatch_queue_create("zp.com.queue", DISPATCH_QUEUE_CONCURRENT);
//    dispatch_queue_t queue = dispatch_get_main_queue();
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_sync(queue, ^{
        NSLog(@"1------%@", [NSThread currentThread]);
    });
    dispatch_sync(queue, ^{
        NSLog(@"2------%@", [NSThread currentThread]);
    });
    dispatch_sync(queue, ^{
        NSLog(@"3------%@", [NSThread currentThread]);
    });
    NSLog(@"---------end");
}

- (void)syncSerial {
    NSLog(@"---------begin");
    dispatch_queue_t queue = dispatch_queue_create("zp.com.queue", DISPATCH_QUEUE_SERIAL);
    dispatch_sync(queue, ^{
        NSLog(@"1------%@", [NSThread currentThread]);
    });
    dispatch_sync(queue, ^{
        NSLog(@"2------%@", [NSThread currentThread]);
    });
    dispatch_sync(queue, ^{
        NSLog(@"3------%@", [NSThread currentThread]);
    });
    NSLog(@"---------end");
}

@end

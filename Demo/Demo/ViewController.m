//
//  ViewController.m
//  Demo
//
//  Created by SL🐰鱼子酱 on 15/6/14.
//  Copyright © 2015年 SL. All rights reserved.
//

#import "ViewController.h"
#import "SLRollingImagesView.h"

@interface ViewController ()

@property (strong, nonatomic) NSArray * imageURLs;

@end

@implementation ViewController

- (NSArray *)imageURLs {
    if (!_imageURLs) {
        NSMutableArray * arrayM = [NSMutableArray arrayWithCapacity:6];
        for (NSInteger num = 0; num < 6; num++) {
            
            NSURL * url = [NSURL URLWithString:[NSString stringWithFormat:@"http://www.52772577.com/content/images/2015/05/wallpaper/%@.jpg", @(num)]];
            
            [arrayM addObject:url];
        }
        _imageURLs = arrayM.copy;
    }
    return _imageURLs;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSArray * details = @[@"星空", @"星河", @"星辰", @"星相", @"星宿", @"星斗"];
    
//## 1

    SLRollingImagesView * rolling = [SLRollingImagesView sl_rollingViewWithFrame:CGRectMake(0, 0, 375, 200) collectionViewLayout:^(UICollectionViewFlowLayout *layout) {
        
        
    } withReferences:^(SLRollingParameter * para) {
        
        para.loop = YES;
        para.showPageIndicator = YES;
        para.timing = YES;
        para.duration = 4.0;
        
    } withImageURLs:self.imageURLs andShowImageDetails:details];
    
    [self.view addSubview:rolling];

    
//## 2

    
//    SLRollingImagesView * rolling = [SLRollingImagesView sl_rollingViewWithFrame:CGRectMake(0, 0, 375, 200) andImageURLs:self.imageURLs andShowImageDetails:details];
//    
//    [self.view addSubview:rolling];

    
//## 3

//    SLRollingImagesView * rolling = [SLRollingImagesView sl_rollingViewWithFrame:CGRectMake(0, 0, 375, 200) andImageURLs:self.imageURLs];
//    
//    [self.view addSubview:rolling];
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
//
//  SLRollingImagesView.m
//  Demo
//
//  Created by SL🐰鱼子酱 on 15/6/14.
//  Copyright © 2015年 SL. All rights reserved.
//

#import "SLRollingImagesView.h"
#import "SLRollingImagesCell.h"
#import "UIImageView+WebCache.h"

@interface SLRollingImagesView () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (strong, nonatomic) NSArray * imageURLs;
@property (strong, nonatomic) NSArray * details;

@property (assign, nonatomic) NSInteger imageIndex;

@property (assign, nonatomic) NSInteger autoChangeImageIndex;

@property (weak, nonatomic) UIPageControl * pageControl;

@property (assign, nonatomic) CGRect pageControlFrame;

@property (strong, nonatomic) CADisplayLink * link;


@end


@implementation SLRollingImagesView

static  NSString * cellID = @"SLRIV";

+ (instancetype)sl_rollingViewWithFrame:(CGRect)frame andImageURLs:(NSArray *)imageURLs {
    return [self sl_rollingViewWithFrame:frame andImageURLs:imageURLs andShowImageDetails:nil];
}

+ (instancetype)sl_rollingViewWithFrame:(CGRect)frame andImageURLs:(NSArray *)imageURLs andShowImageDetails:(NSArray *)details {
    return [self sl_rollingViewWithFrame:frame collectionViewLayout:nil withReferences:nil withImageURLs:imageURLs andShowImageDetails:details];
}

+ (instancetype)sl_rollingViewWithFrame:(CGRect)frame collectionViewLayout:(void (^)(UICollectionViewFlowLayout *))collectionViewLayout withReferences:(void (^)(SLRollingParameter *))parameters withImageURLs:(NSArray *)imageURLs andShowImageDetails:(NSArray *)details {
    
    if (details) {
        NSAssert(imageURLs.count == details.count, @"\n\nClass\t: %@\n_cmd\t\t: %@\nself\t\t: %@\nError\t: \"the imageURLs is not compatible with details\"\n", self.class, NSStringFromSelector(_cmd), self);
    }
    
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
    
    layout.itemSize= frame.size;
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 0;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    if (collectionViewLayout) {
        collectionViewLayout(layout);
    }
    
    SLRollingImagesView * rolling = [[self alloc] initWithFrame:frame collectionViewLayout:layout withReferences:parameters withImageURLs:imageURLs andShowImageDetails:(NSArray *)details];
    
    [rolling registerClass:[SLRollingImagesCell class] forCellWithReuseIdentifier:cellID];
    
    return rolling;
    
}

- (nonnull instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(nonnull UICollectionViewLayout *)layout withReferences:(void (^)(SLRollingParameter *))parameters withImageURLs:(NSArray *)imageURLs andShowImageDetails:(NSArray *)details {
    
    if (self = [super initWithFrame:frame collectionViewLayout:layout]) {
        
        self.pagingEnabled = YES;
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        
        self.delegate = self;
        self.dataSource = self;
        
        NSAssert(imageURLs, @"\n\nClass\t: %@\n_cmd\t\t: %@\nself\t\t: %@\nError\t: \"imageURLs can not be nil\"\n", self.class, NSStringFromSelector(_cmd), self);
        
        self.imageURLs = imageURLs;
        
        self.parameter = [[SLRollingParameter alloc] init];
        
        if (parameters) {
            parameters(self.parameter);
        }
        
        /// 循环判断
        [self isLoopBlock:^{
            self.contentOffset = CGPointMake(frame.size.width, 0);
        } else:^{
            self.contentOffset = CGPointZero;
        }];
        
        
#pragma mark 指示器的frame
        /// 显示指示器判断
        [self showPageIndicatorBlock:^{
            UIPageControl * pc = [[UIPageControl alloc] init];
            self.pageControl = pc;
            
            CGSize exceptSize = [pc sizeForNumberOfPages:self.imageURLs.count];
            
            // NSLog(@"expected %@", NSStringFromCGSize(exceptSize));
            
            pc.bounds = CGRectMake(0, 0, exceptSize.width, exceptSize.height);
            
            
            [self isLoopBlock:^{
                pc.center = CGPointMake(self.center.x + frame.size.width, self.center.y);
            } else:^{
                pc.center = self.center;
            }];
            
            
            self.pageControlFrame = pc.frame;
            pc.numberOfPages = self.imageURLs.count;
            
            pc.pageIndicatorTintColor = [UIColor whiteColor];
            pc.currentPageIndicatorTintColor = [UIColor redColor];
            
            [self addSubview:pc];
            
        }];
        
        
        
        /// 计时判断
        [self isTimingBlock:^{
            
            self.link = [CADisplayLink displayLinkWithTarget:self selector:@selector(changePage)];
            [self.link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
            
        }];
        
        /// 输入DetailsLabel判断
        if (details) {
            self.details = details;
        }
    }
    return self;
}


#pragma mark - changePage
- (void)changePage {
    
    static int i = 0;
    i++;
    if (i % ((int)self.parameter.duration * 60) == 0) {
        
        [self isLoopBlock:^{
            
            [self selectItemAtIndexPath:[NSIndexPath indexPathForItem:2 inSection:0] animated:YES scrollPosition:UICollectionViewScrollPositionRight];
            
        } else:^{
            
            [self selectItemAtIndexPath:[NSIndexPath indexPathForItem:(self.autoChangeImageIndex+1)%self.imageURLs.count inSection:0] animated:YES scrollPosition:UICollectionViewScrollPositionRight];
            
        }];
        
    }
}

#pragma mark - 代理方法

- (void)scrollViewWillBeginDragging:(nonnull UIScrollView *)scrollView {
    
    [self isTimingBlock:^{
        
        [self.link invalidate];
        
    }];
}



- (void)scrollViewDidEndDragging:(nonnull UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    
    [self isTimingBlock:^{
        
        self.link = [CADisplayLink displayLinkWithTarget:self selector:@selector(changePage)];
        [self.link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
        
    }];
}

- (void)scrollViewDidScroll:(nonnull UIScrollView *)scrollView {
    
    
    [self isLoopBlock:^{
        
        CGRect move = self.pageControlFrame;
        move.origin.x = move.origin.x + scrollView.contentOffset.x - self.frame.size.width;
        self.pageControl.frame = move;
        
    } else:^{
        
        CGRect move = self.pageControlFrame;
        move.origin.x = move.origin.x + scrollView.contentOffset.x;
        self.pageControl.frame = move;
        
    }];
    
    
}

- (void)collectionView:(nonnull UICollectionView *)collectionView didEndDisplayingCell:(nonnull UICollectionViewCell *)cell forItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    [self isLoopBlock:^{
        
        if (self.contentOffset.x == 0 && self.parameter.loop) {
            
            self.imageIndex--;
            self.contentOffset = CGPointMake(self.frame.size.width, 0);
            
        }
        if (self.contentOffset.x == (self.frame.size.width * 2) && self.parameter.loop) {
            
            self.imageIndex++;
            self.contentOffset = CGPointMake(self.frame.size.width, 0);
            
        }
        
    } else:nil];
    
}

- (NSInteger)collectionViewCellForIndexOfImageAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    
    
    __block NSInteger index = indexPath.item + self.imageIndex;
    
    [self isLoopBlock:^{
        
        if (self.imageIndex < self.imageURLs.count) {
            self.imageIndex += self.imageURLs.count;
        }
        
        index = (indexPath.item + self.imageIndex - 1) % self.imageURLs.count;
        
        [self showPageIndicatorBlock:^{
            
            self.pageControl.currentPage = index;
            
        }];
        
        
    } else:nil];
    
    [self showPageIndicatorBlock:^{
        
        self.pageControl.currentPage = index;
        
    }];
    
    
    self.autoChangeImageIndex = index;
    
    return index;
    
}


#pragma mark 设置cell子控件的frame

- (nonnull UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    SLRollingImagesCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    
    NSInteger index =  [self collectionViewCellForIndexOfImageAtIndexPath:indexPath];
    
    // NSLog(@"cell indexpath.item = %@, index = %@", @(indexPath.item), @(index));
    
    [cell layoutIfNeeded];
    
#warning 改成自定义webimage
    [cell.imageView sd_setImageWithURL:self.imageURLs[index]];
    
    
    if (self.details) {
        cell.detailLabel.text = self.details[index];
    } else {
        cell.detailLabel.hidden = YES;
    }
    
    return cell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.imageURLs.count;
}


#pragma mark block

- (void)isLoopBlock:(void(^)())isLoop else:(void(^)())noLoop {
    
    if (self.parameter.loop) {
        isLoop();
    } else {
        if (noLoop) {
            noLoop();
        }
    }
    
}

- (void)showPageIndicatorBlock:(void(^)())show {
    if (self.parameter.showPageIndicator) {
        show();
    }
}

- (void)isTimingBlock:(void(^)())timing {
    if (self.parameter.timing) {
        timing();
    }
}

@end

@implementation SLRollingParameter

- (NSTimeInterval)duration {
    if (_duration < 0.5) {
        _duration = 2.0;
    }
    return _duration;
}

@end
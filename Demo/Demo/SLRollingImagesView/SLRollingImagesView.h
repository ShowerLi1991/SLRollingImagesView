//
//  SLRollingImagesView.h
//  Demo
//
//  Created by SL🐰鱼子酱 on 15/6/14.
//  Copyright © 2015年 SL. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface SLRollingParameter : NSObject

/// autoPlay default is NO.
@property (assign, nonatomic, getter = isTiming) BOOL timing;
/// if timing is YES, set the timing durantion, default is 2.0, and the least duration is 0.5.
@property (assign, nonatomic) NSTimeInterval duration;
/// loopPlaying default is NO.
@property (assign, nonatomic, getter = isLoop) BOOL loop;
/// showPageIndicator default is NO.
@property (assign, nonatomic, getter = isShowPageIndicator) BOOL showPageIndicator;

@end



@interface SLRollingImagesView : UICollectionView




/**
 Creat a collectionView of rolling imageViews quickly with imageURLs and details by parameters.
 Defaule pagingEnabled = YES, showsHorizontalScrollIndicator = NO and showsVerticalScrollIndicator = NO.
 @param collectionViewLayout // Did set the itemSize == collectionView.frame
 @param parameter            // Include BOOL loop, default is NO; BOOL showPageIndicator, default is NO; BOOL timing, default is NO; NSTimeInterval duration, default is 2.0s.
 @param imageURLs            // Array of imageURLs
 @param details              // If no need, set it nil, the count of details must be compatiable with imageURLs
 @return SLRollingView
 */
+ (instancetype)sl_rollingViewWithFrame:(CGRect)frame collectionViewLayout:(void(^)(UICollectionViewFlowLayout * layout))collectionViewLayout withReferences:(void (^)(SLRollingParameter * para))parameters withImageURLs:(NSArray *)imageURLs andShowImageDetails:(NSArray *)details;

@property (strong, nonatomic) SLRollingParameter * parameter;

@end


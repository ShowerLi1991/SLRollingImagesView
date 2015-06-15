# SLRollingImagesView

     Creat a collectionView of rolling imageViews quickly with imageURLs and details by parameters.
     Defaule pagingEnabled = YES, showsHorizontalScrollIndicator = NO and showsVerticalScrollIndicator = NO.
     @param collectionViewLayout // Did set the itemSize == collectionView.frame
     @param parameter            // Include BOOL loop, default is NO; BOOL showPageIndicator, default is NO; BOOL timing, default is NO; NSTimeInterval duration, default is 2.0s.
     @param imageURLs            // Array of imageURLs
     @param details              // If no need, set it nil, the count of details must be compatiable with imageURLs
     @return SLRollingView
     
#Using like this : (Xcode7)

    NSArray * details = @[@"星空", @"星河", @"星辰", @"星相", @"星宿", @"星斗"];
    
    
    SLRollingImagesView * rolling = [SLRollingImagesView sl_rollingViewWithFrame:CGRectMake(0, 0, 375, 200) collectionViewLayout:^(UICollectionViewFlowLayout *layout) {
        
        
    } withReferences:^(SLRollingParameter * para) {
        
        para.loop = YES;
        para.showPageIndicator = YES;
        para.timing = YES;
        para.duration = 4.0;
        
    } withImageURLs:self.imageURLs andShowImageDetails:details];
    
    [self.view addSubview:rolling];

#Feature

     ## Optional detailLabel:
![(Pic1)](http://www.52772577.com/content/images/SL/SLRollingImagesVIewPic11.jpg)
![(Pic2)](http://www.52772577.com/content/images/SL/SLRollingImagesVIewPic22.jpg)

     ## Optional parameters: loop, showPageIndicator, Timing, duration
![(Pic3)](http://www.52772577.com/content/images/SL/SLRollingImagesView44.gif)

     ## Custom CollectionLayout
![(Pic4)](http://www.52772577.com/content/images/SL/SLRollingImagesVIewPic33.png)
![(Pic5)](http://www.52772577.com/content/images/SL/SLRollingImagesVIewPic44.png)
![(Pic6)](http://www.52772577.com/content/images/SL/SLRollingImagesVIewPic55.png)


     

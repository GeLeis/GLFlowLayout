//
//  HKAppHomeLayout.h
//  BlackCard
//
//  Created by gelei on 2019/4/26.
//  Copyright © 2019 冒险元素. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GLFlowLayoutDelegate <UICollectionViewDelegateFlowLayout>
@optional

- (NSInteger)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout maxColumnInSection:(NSInteger)section;

@end

@interface GLFlowLayout : UICollectionViewLayout
@property (nonatomic, strong) id<GLFlowLayoutDelegate> delegate;
@end

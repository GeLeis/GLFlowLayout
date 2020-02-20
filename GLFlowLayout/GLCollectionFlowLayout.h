//
//  HKAppHomeLayout.h
//  BlackCard
//
//  Created by gelei on 2019/4/26.
//  Copyright © 2019 冒险元素. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GLCollectionFlowLayoutDelegate <UICollectionViewDelegateFlowLayout>
@optional

- (NSInteger)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout maxColumnInSection:(NSInteger)section;
//装饰view elementKind
- (NSString *)collectionView:(UICollectionView *)collectionView layoutAttributesForDecorationViewAtIndexPath:(NSIndexPath *)indexPath;
- (void)collectionView:(UICollectionView *)collectionView contentViewContentSize:(CGSize)contentSize;
@end

@interface GLCollectionFlowLayout : UICollectionViewLayout
@property (nonatomic, strong) id<GLCollectionFlowLayoutDelegate> delegate;
@end

//
//  HKAppHomeLayout.m
//  BlackCard
//
//  Created by gelei on 2019/4/26.
//  Copyright © 2019 冒险元素. All rights reserved.
//

#import "GLFlowLayout.h"

@interface GLFlowLayout()
/** 每一组section的maxYDic的集合<##> */
@property (nonatomic, strong) NSMutableArray<NSMutableDictionary<NSString *, NSNumber *> *> *maxYDics;
///每一组section这个字典用来存储每一列item的高度
@property (nonatomic, strong) NSMutableDictionary<NSString *, NSNumber *> *maxYDic;
//当前section的最大列数
@property (nonatomic, assign) NSInteger maxColumn;
/// 存放每一个item的布局属性
@property (nonatomic, strong) NSMutableArray<UICollectionViewLayoutAttributes *> *layoutAttributes;
/** 滚动的范围,避免重复计算 */
@property (nonatomic, assign) CGSize contentSize;
@end

@implementation GLFlowLayout

- (void)prepareLayout {
    self.contentSize = CGSizeZero;
    [self.maxYDics removeAllObjects];
    [self.maxYDic removeAllObjects];
    [self.layoutAttributes removeAllObjects];
    
    //计算所有item的属性,目前默认为
    for (NSInteger section = 0; section < self.collectionView.numberOfSections; section++) {
        CGFloat currentMaxY = [self currentMaxY];
        self.maxYDic = [NSMutableDictionary dictionary];
        self.maxColumn = 1;
        if ([self.delegate respondsToSelector:@selector(collectionView:layout:maxColumnInSection:)]) {
            self.maxColumn = [self.delegate collectionView:self.collectionView layout:self maxColumnInSection:section];
            for (int i = 0; i < self.maxColumn; i++) {
                [self.maxYDic setValue:@(currentMaxY) forKey:[NSString stringWithFormat:@"%d",i]];
            }
        }
        CGFloat decorationStartY = [self currentMaxY];
        //        NSInteger decorationIndex = self.layoutAttributes.count;
        
        NSIndexPath *pathOfSection = [NSIndexPath indexPathForRow:0 inSection:section];
        
        //sectionHeader 及sectionInset.top
        UICollectionViewLayoutAttributes *headerLayout = [self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader atIndexPath:pathOfSection];
        if (headerLayout) {
            [self.layoutAttributes addObject:headerLayout];
        }
        NSInteger rows = [self.collectionView numberOfItemsInSection:section];
        for (NSInteger row = 0; row < rows; row++) {
            UICollectionViewLayoutAttributes *itemLayout = [self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:row inSection:section]];
            [self.layoutAttributes addObject:itemLayout];
        }
        //sectionFooter及sectionInset.bottom
        UICollectionViewLayoutAttributes *footerLayout = [self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionFooter atIndexPath:pathOfSection];
        if (footerLayout) {
            [self.layoutAttributes addObject:footerLayout];
        }
        [self.maxYDics addObject:[self.maxYDic copy]];
        
        CGFloat decorationEndY = [self currentMaxY];
        if ([self.delegate respondsToSelector:@selector(collectionView:layoutAttributesForDecorationViewAtIndexPath:)]) {
            NSString *elementKind = [self.delegate collectionView:self.collectionView layoutAttributesForDecorationViewAtIndexPath:pathOfSection];
            if (elementKind) {
                UICollectionViewLayoutAttributes *decorationLayout = [self initialLayoutAttributesForAppearingDecorationElementOfKind:elementKind atIndexPath:pathOfSection];
                if (decorationLayout) {
                    //不知道为什么这里会有
                    decorationLayout.frame = CGRectMake(0, decorationStartY, self.collectionView.frame.size.width, decorationEndY - decorationStartY);
                    decorationLayout.zIndex = -1;
                    [self.layoutAttributes addObject:decorationLayout];
                }
            }
        }
    }
    self.contentSize = CGSizeMake(0, [self currentMaxY]);
}

- (CGFloat) currentMaxY {
    if (!self.maxYDics.lastObject) {
        return 0;
    }
    NSString *maxColumn = @"0";
    for (int i = 0; i < self.maxColumn; i++) {
        NSString *column = [NSString stringWithFormat:@"%d",i];
        if ([self.maxYDic[column] floatValue] > [self.maxYDic[maxColumn] floatValue]) {
            maxColumn = column;
        }
    }
    return [self.maxYDics.lastObject[maxColumn] floatValue];
}
//当前的最大y列
- (NSString *)columnOfMaxY {
    NSString *maxColumn = @"0";
    for (int i = 0; i < self.maxColumn; i++) {
        NSString *column = [NSString stringWithFormat:@"%d",i];
        if ([self.maxYDic[column] floatValue] > [self.maxYDic[maxColumn] floatValue]) {
            maxColumn = column;
        }
    }
    return maxColumn;
}
//当前最小y列
- (NSString *)columnOfMinY {
    NSString *minColumn = @"0";
    for (int i = 0; i < self.maxColumn; i++) {
        NSString *column = [NSString stringWithFormat:@"%d",i];
        if ([self.maxYDic[column] floatValue] < [self.maxYDic[minColumn] floatValue]) {
            minColumn = column;
        }
    }
    return minColumn;
}

//设置collectionView滚动区域
- (CGSize)collectionViewContentSize {
    if (self.contentSize.height > 0) {
        return self.contentSize;
    }
    return CGSizeMake(0,[self currentMaxY]);
}

//cell布局
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    //设置item的frame
    CGSize itemSize = CGSizeZero;
    if ([self.delegate respondsToSelector:@selector(collectionView:layout:sizeForItemAtIndexPath:)]) {
        itemSize = [self.delegate collectionView:self.collectionView layout:self sizeForItemAtIndexPath:indexPath];
    }
    UIEdgeInsets sectionInsets = UIEdgeInsetsZero;
    if ([self.delegate respondsToSelector:@selector(collectionView:layout:insetForSectionAtIndex:)]) {
        sectionInsets = [self.delegate collectionView:self.collectionView layout:self insetForSectionAtIndex:indexPath.section];
    }
    CGFloat interitemSpacing = CGFLOAT_MIN;
    if ([self.delegate respondsToSelector:@selector(collectionView:layout:minimumInteritemSpacingForSectionAtIndex:)]) {
        interitemSpacing = [self.delegate collectionView:self.collectionView layout:self minimumInteritemSpacingForSectionAtIndex:indexPath.section];
    }
    CGFloat lineSpacing = CGFLOAT_MIN;
    if ([self.delegate respondsToSelector:@selector(collectionView:layout:minimumLineSpacingForSectionAtIndex:)]) {
        lineSpacing = [self.delegate collectionView:self.collectionView layout:self minimumLineSpacingForSectionAtIndex:indexPath.section];
    }
    CGFloat x = 0;
    CGFloat y = 0;
    //如果宽带大于单个宽度
    if (itemSize.width > (self.collectionView.frame.size.width - sectionInsets.left - sectionInsets.right - (self.maxColumn - 1) * interitemSpacing) / self.maxColumn) {
        NSString *maxColumn = [self columnOfMaxY];
        x = sectionInsets.left;
        y = [self.maxYDic[maxColumn] floatValue];
        for (int i = 0; i < self.maxColumn; i++) {
            [self.maxYDic setValue:@(y + itemSize.height) forKey:[NSString stringWithFormat:@"%d",i]];
        }
    } else {
        NSString *minColumn = [self columnOfMinY];
        x = sectionInsets.left + (itemSize.width + interitemSpacing) * [minColumn intValue];
        y = [self.maxYDic[minColumn] floatValue];
        self.maxYDic[minColumn] = @(y + itemSize.height + lineSpacing);
    }
    if (itemSize.height > 0) {
        //创建布局属性
        UICollectionViewLayoutAttributes *layoutAttri = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
        //设置item的frame
        layoutAttri.frame = CGRectMake(x, y, itemSize.width, itemSize.height);
        return layoutAttri;
    }
    return nil;
}
//header,footer
- (nullable UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath {
    NSString *maxColumn = [self columnOfMaxY];
    CGFloat maxY = [self.maxYDic[maxColumn] floatValue];
    CGSize headerFooterSize = CGSizeZero;
    if ([elementKind isEqualToString:UICollectionElementKindSectionHeader] && [self.delegate respondsToSelector:@selector(collectionView:layout:referenceSizeForHeaderInSection:)]) {
        headerFooterSize = [self.delegate collectionView:self.collectionView layout:self referenceSizeForHeaderInSection:indexPath.section];
    } else if ([elementKind isEqualToString:UICollectionElementKindSectionFooter] && [self.delegate respondsToSelector:@selector(collectionView:layout:referenceSizeForFooterInSection:)]) {
        headerFooterSize = [self.delegate collectionView:self.collectionView layout:self referenceSizeForFooterInSection:indexPath.section];
    }
    //section的edge
    UIEdgeInsets sectionInsets = UIEdgeInsetsZero;
    if ([self.delegate respondsToSelector:@selector(collectionView:layout:insetForSectionAtIndex:)]) {
        sectionInsets = [self.delegate collectionView:self.collectionView layout:self insetForSectionAtIndex:indexPath.section];
    }
    CGFloat edge = CGFLOAT_MIN;
    if ([elementKind isEqualToString:UICollectionElementKindSectionHeader]) {
        edge = sectionInsets.top;
    } else if ([elementKind isEqualToString:UICollectionElementKindSectionFooter]) {
        edge = sectionInsets.bottom;
    }
    //更新最大Y值
    for (NSString *key in self.maxYDic.allKeys) {
        self.maxYDic[key] = @(maxY + headerFooterSize.height + edge);
    }
    
    if (headerFooterSize.height > 0) {
        UICollectionViewLayoutAttributes *layoutAttr = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:elementKind withIndexPath:indexPath];
        layoutAttr.frame = CGRectMake(0, maxY + ([elementKind isEqualToString:UICollectionElementKindSectionHeader] ? 0 : edge), headerFooterSize.width, headerFooterSize.height);
        return layoutAttr;
    }
    return nil;
}

- (UICollectionViewLayoutAttributes *)initialLayoutAttributesForAppearingDecorationElementOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)decorationIndexPath {
    return [UICollectionViewLayoutAttributes layoutAttributesForDecorationViewOfKind:elementKind withIndexPath:decorationIndexPath];
}

- (nullable NSArray<__kindof UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    return self.layoutAttributes;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    //宽度发生变化,一般不会
    if (CGRectGetWidth(newBounds) != CGRectGetWidth(self.collectionView.bounds)) {
        return YES;
    }
    return NO;
}

- (NSMutableArray<UICollectionViewLayoutAttributes *> *)layoutAttributes {
    if (!_layoutAttributes) {
        _layoutAttributes = [NSMutableArray array];
    }
    return _layoutAttributes;
}

- (NSMutableArray<NSMutableDictionary<NSString *,NSNumber *> *> *)maxYDics {
    if (!_maxYDics) {
        _maxYDics = [NSMutableArray array];
    }
    return _maxYDics;
}

@end

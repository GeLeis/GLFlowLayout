//
//  GLSectionModel.h
//  GLFlowLayoutDemo
//
//  Created by gelei on 2019/5/6.
//  Copyright © 2019 gelei. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GLRowModel;
NS_ASSUME_NONNULL_BEGIN

@interface GLSectionModel : NSObject
/** 每一行的最大个数 */
@property (nonatomic, assign) NSInteger maxColumn;
/** 最小的行间距 */
@property (nonatomic, assign) CGFloat lineSpacing;
/** 元素间距 */
@property (nonatomic, assign) CGFloat interitemSpacing;
/** section的内边距设置 */
@property (nonatomic, assign) UIEdgeInsets sectionInsets;
/** 头部高度 */
@property (nonatomic, assign) CGFloat headerHeight;
/** 底部高度 */
@property (nonatomic, assign) CGFloat footerHeight;
/** 数据源 */
@property (nonatomic, strong) NSArray<GLRowModel *> *rows;
@end

@interface GLRowModel : NSObject
@property (nonatomic, assign) CGSize itemSize;
/** itemCell的class */
@property (nonatomic, copy) NSString *cellIdentify;
@property (nonatomic, strong) id data;
@end

NS_ASSUME_NONNULL_END

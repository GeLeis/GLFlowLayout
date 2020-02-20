//
//  ViewController.m
//  GLFlowLayoutDemo
//
//  Created by gelei on 2019/5/6.
//  Copyright © 2019 gelei. All rights reserved.
//

#import "ViewController.h"
#import "GLCollectionFlowLayout.h"
#import "SectionHeaderReusableView.h"
#import "SectionFooterReusableView.h"
#import "GLSectionModel.h"
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#define kRandomColor [UIColor colorWithRed:(arc4random()%256)/256.f green:(arc4random()%256)/256.f blue:(arc4random()%256)/256.f alpha:1.0f]

@interface ViewController ()<UICollectionViewDataSource, GLCollectionFlowLayoutDelegate>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray <GLSectionModel *> *models;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.collectionView];
    [self createData];
    [self.collectionView reloadData];
}

#pragma mark -- UICollectionViewDataSource, GLFlowLayoutDelegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.models.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.models[section].rows.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    GLSectionModel *sectionM = self.models[indexPath.section];
    GLRowModel *rowM = sectionM.rows[indexPath.row];
    return rowM.itemSize;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout maxColumnInSection:(NSInteger)section {
    return [self.models[section] maxColumn];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    GLSectionModel *sectionM = self.models[indexPath.section];
    GLRowModel *rowM = sectionM.rows[indexPath.row];
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:rowM.cellIdentify forIndexPath:indexPath];
    cell.contentView.backgroundColor = kRandomColor;
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    GLSectionModel *sectionM = self.models[section];
    return CGSizeMake(SCREEN_WIDTH, sectionM.headerHeight);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    GLSectionModel *sectionM = self.models[section];
    return CGSizeMake(SCREEN_WIDTH, sectionM.footerHeight);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    GLSectionModel *sectionM = self.models[indexPath.section];
    if (sectionM.headerHeight > 0 && [kind isEqualToString:UICollectionElementKindSectionHeader]) {
        SectionHeaderReusableView *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass(SectionHeaderReusableView.class) forIndexPath:indexPath];
        header.backgroundColor = [UIColor redColor];
        return header;
    } else if (sectionM.footerHeight > 0 && [kind isEqualToString:UICollectionElementKindSectionFooter]) {
        SectionFooterReusableView *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:NSStringFromClass(SectionFooterReusableView.class) forIndexPath:indexPath];
        header.backgroundColor = [UIColor yellowColor];
        return header;
    }
    return nil;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return self.models[section].interitemSpacing;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return self.models[section].lineSpacing;
}


- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return self.models[section].sectionInsets;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        GLCollectionFlowLayout *layout = [[GLCollectionFlowLayout alloc] init];
        layout.delegate = self;
        _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
        _collectionView.showsHorizontalScrollIndicator = NO;
        [_collectionView registerClass:UICollectionViewCell.class forCellWithReuseIdentifier:NSStringFromClass(self.class)];
        
        [_collectionView registerClass:SectionHeaderReusableView.class forSupplementaryViewOfKind:UICollectionElementKindSectionHeader  withReuseIdentifier:NSStringFromClass(SectionHeaderReusableView.class)];
        
        [_collectionView registerClass:SectionFooterReusableView.class forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:NSStringFromClass(SectionFooterReusableView.class)];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
    }
    return _collectionView;
}

- (void)createData {
    GLSectionModel *model1 = [[GLSectionModel alloc] init];
    model1.headerHeight = 10;
    model1.footerHeight = 20;
    GLRowModel *row1 = [[GLRowModel alloc] init];
    row1.itemSize = CGSizeMake(SCREEN_WIDTH, 100);
    row1.cellIdentify = NSStringFromClass(self.class);
    row1.data = @1;
    
    GLRowModel *row2 = [[GLRowModel alloc] init];
    row2.itemSize = CGSizeMake(SCREEN_WIDTH, 100);
    row2.cellIdentify = NSStringFromClass(self.class);
    row2.data = @1;
    
    model1.rows = @[row1,row2];
    model1.maxColumn = 1;
    model1.sectionInsets = UIEdgeInsetsMake(10, 10, 10, 10);
    model1.lineSpacing = 20;
    
    GLSectionModel *model2 = [[GLSectionModel alloc] init];
    model2.headerHeight = 30;
    model2.footerHeight = 10;
    NSMutableArray *rows2 = [NSMutableArray array];
    for (int i = 0 ; i < 4 ; i++) {
        GLRowModel *row = [[GLRowModel alloc] init];
        row.data = @1;
        row.itemSize = CGSizeMake(SCREEN_WIDTH / 4, 99);
        row.cellIdentify = NSStringFromClass(self.class);
        [rows2 addObject:row];
    }
    model2.rows = rows2;
    model2.maxColumn = 4;
    
    GLSectionModel *model3 = [[GLSectionModel alloc] init];
    model3.headerHeight = 0;
    model3.footerHeight = 10;
    model3.sectionInsets = UIEdgeInsetsMake(6, 12, 6, 12);
    model3.lineSpacing = 1;
    model3.interitemSpacing = CGFLOAT_MIN;
    model3.maxColumn = 2;
    NSMutableArray *rows3 = [NSMutableArray array];
    for (int i = 0; i < 20; i++) {
        GLRowModel *row = [[GLRowModel alloc] init];
        row.cellIdentify = NSStringFromClass(self.class);
        row.itemSize = CGSizeMake((SCREEN_WIDTH - 40) / 2.f + 8, arc4random_uniform(200) + 100);
        row.data = @1;
        [rows3 addObject:row];
    }
    model3.rows = rows3;
    [self.models addObject:model1];
    [self.models addObject:model2];
    [self.models addObject:model3];
}

- (NSMutableArray<GLSectionModel *> *)models {
    if (!_models) {
        _models = [NSMutableArray array];
    }
    return _models;
}

@end

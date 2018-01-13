//
//  CollectionViewSource.m
//  SKImageReader
//
//  Created by Salman Khalid on 12/01/2018.
//  Copyright © 2018 Salman Khalid. All rights reserved.
//

#import "CollectionViewSource.h"
#import "CustomCollectionViewCell.h"


@interface CollectionViewSource()
{
    NSMutableArray *sourceArray;
}

@end

@implementation CollectionViewSource 

-(id)initWithSourceWithArray:(NSMutableArray *)inputArray ndCollectionView:(UICollectionView *)collectionView{
    
    if(self = [super init])
    {
        sourceArray = inputArray;
        
        [collectionView registerNib:[UINib nibWithNibName:@"CustomCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"CustomCollectionViewCell"];
        
        [collectionView setDataSource:self];
        [collectionView setDelegate:self];        

    }
    
    return self;
}

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {     
    
    CustomCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CustomCollectionViewCell" forIndexPath:indexPath];
    NSString *imagePath = [sourceArray objectAtIndex:indexPath.row];
    UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
    [cell.mainImageView setImage:image];
    cell.backgroundColor=[UIColor greenColor];

    return cell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return sourceArray.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(CGRectGetWidth(collectionView.frame)/3.1, (CGRectGetHeight(collectionView.frame)/3.1));
}

@end

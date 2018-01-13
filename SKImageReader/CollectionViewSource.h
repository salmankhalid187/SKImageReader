//
//  CollectionViewSource.h
//  SKImageReader
//
//  Created by Salman Khalid on 12/01/2018.
//  Copyright © 2018 Salman Khalid. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface CollectionViewSource : NSObject <UICollectionViewDataSource,UICollectionViewDelegate>

-(id)initWithSourceWithArray:(NSMutableArray *)inputArray ndCollectionView:(UICollectionView *)collectionView;
@end

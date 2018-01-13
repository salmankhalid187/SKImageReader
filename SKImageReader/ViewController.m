//
//  ViewController.m
//  SKImageReader
//
//  Created by Salman Khalid on 05/01/2018.
//  Copyright © 2018 Salman Khalid. All rights reserved.
//

#import "ViewController.h"
#import <Photos/Photos.h>
#import "CollectionViewSource.h"
#import "CustomCollectionViewCell.h"

#define IMAGES_LIMIT 200

@interface ViewController ()    {
    
    dispatch_queue_t m_writeDirectoryQueue;
    dispatch_queue_t m_readImagesQueue;
    double m_progressIncrementFactor;
    CollectionViewSource *m_pCollectionSource;
    NSMutableArray *m_pImagesPathsArray;
}
@property (weak, nonatomic) IBOutlet UIProgressView *progressBar;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UILabel *statuslbl;
@property (weak, nonatomic) IBOutlet UILabel *progressPercentagelbl;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    m_writeDirectoryQueue = dispatch_queue_create("com.salman.imagewriter", DISPATCH_QUEUE_SERIAL);
    m_readImagesQueue = dispatch_queue_create("com.salman.imagereader", DISPATCH_QUEUE_SERIAL);
    m_pImagesPathsArray = [[NSMutableArray alloc] init];
    m_pCollectionSource = [[CollectionViewSource alloc] initWithSourceWithArray:m_pImagesPathsArray ndCollectionView:_collectionView];
    
    [self RequestAccessForLibrary];
}

-(void)RequestAccessForLibrary  {
    
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status){
        
            switch (status) {
                case PHAuthorizationStatusAuthorized:
                {
                    [self ReadPhotosFromLibrary];
                    break;
                }
                case PHAuthorizationStatusRestricted:
                case PHAuthorizationStatusDenied:
                {
                    [self SetStatusLblText:@"Request Not Granted"];
                    break;
                }
                default:
                {
                    break;
                }
            }
        }
     ];
    
}

-(void)ReadPhotosFromLibrary    {

    PHFetchOptions *options = [[PHFetchOptions alloc] init];
    options.fetchLimit = IMAGES_LIMIT;
    PHFetchResult *results = [PHAsset fetchAssetsWithMediaType:PHAssetMediaTypeImage options:options];
    
    m_progressIncrementFactor = 1.0 /  results.count;
    
    [self SetStatusLblText:@"Fetching Images .."];
    
    [results enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        dispatch_async(m_readImagesQueue,^{
        
        [[PHImageManager defaultManager] requestImageDataForAsset:obj options:NULL resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
            
            dispatch_async(m_writeDirectoryQueue, ^{
                [self WriteImageToDocumentsDirectory:imageData ndName:[NSString stringWithFormat:@"%i",(int)idx]];
                
                    if(idx == (results.count-1))
                    {
                           dispatch_sync(dispatch_get_main_queue(), ^{
                                   [_statuslbl setText:@"Completed"];
                                   [_collectionView reloadData];
                               });
                    }
                });
            }];
        });
    }];

}

-(void)WriteImageToDocumentsDirectory:(NSData *)imageData ndName:(NSString *)fileName   {
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *getImagePath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png",fileName]];
    [imageData writeToFile:getImagePath atomically:YES];
    [m_pImagesPathsArray addObject:getImagePath];
    
    dispatch_sync(dispatch_get_main_queue(), ^{
        
        int progress = ceil(((_progressBar.progress+m_progressIncrementFactor) * 100));
        
        NSString *progressString = [NSString stringWithFormat:@"%i%%",progress];
        [_progressPercentagelbl setText:progressString];
        [_progressBar setProgress:(_progressBar.progress+m_progressIncrementFactor) animated:false];
        [_progressBar setNeedsDisplay];
    });
}

-(void)SetStatusLblText:(NSString *)text {
    
    dispatch_sync(dispatch_get_main_queue(), ^{
        [_statuslbl setText:text];
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

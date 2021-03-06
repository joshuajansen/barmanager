//
//  BarViewController.h
//  barmanager
//
//  Created by Youri van der Lans on 11/15/12.
//  Copyright (c) 2012 ITflows. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Bar.h"
#import "City.h"
#import "BarViewCell.h"
#import "Feature.h"
#import "AddFeatureViewController.h"

@interface BarViewController : UIViewController <UICollectionViewDelegate, UICollectionViewDataSource, RKObjectLoaderDelegate>
{
    NSString *identifier;
    NSArray *collection;
}

@property (nonatomic, strong) Bar *bar;
@property (nonatomic, strong) IBOutlet UICollectionView *featureCollectionView;
@property (nonatomic, strong) IBOutlet UICollectionView *expansionCollectionView;
@property (nonatomic, strong) IBOutlet UICollectionView *enlargementCollectionView;
@property (strong, nonatomic) IBOutlet UILabel *barName;
@property (strong, nonatomic) IBOutlet UILabel *cityName;
@property (strong, nonatomic) IBOutlet UILabel *barCapacity;
@property (strong, nonatomic) IBOutlet UILabel *barPopularity;

@end

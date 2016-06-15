//
//  DetailController.h
//  Weather
//
//  Created by Term Yad on 31.05.16.
//  Copyright © 2016 AntDavydov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Favorite.h"

@interface DetailController : UIViewController

@property (nonatomic, strong) NSString *headerTitle;
@property (nonatomic, strong) Favorite *city;
@end

//
//  ForecastTable.h
//  Weather
//
//  Created by Term Yad on 14.06.16.
//  Copyright © 2016 AntDavydov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Favorite.h"

@interface ForecastTable : UITableView <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, copy) Favorite *city;
-(instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style andData:(NSSet *)data;
-(void) updateForecast:(NSSet *)data;
@end

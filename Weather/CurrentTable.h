//
//  CurrentTable.h
//  Weather
//
//  Created by Term Yad on 14.06.16.
//  Copyright © 2016 AntDavydov. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Current_weather;

@interface CurrentTable : UITableView <UITableViewDataSource, UITableViewDelegate>

-(instancetype) initWithFrame:(CGRect)frame style:(UITableViewStyle)style andData:(Current_weather *)data;

@end

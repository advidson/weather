//
//  ForecastTable.m
//  Weather
//
//  Created by Term Yad on 14.06.16.
//  Copyright © 2016 AntDavydov. All rights reserved.
//

#import "ForecastTable.h"
#import "Forecast_weather.h"
#import "DataProvider.h"

@interface ForecastTable() {
    NSMutableArray *forecastData;
}

@end

@implementation ForecastTable

-(instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style andData:(NSSet *)data {
    self = [super initWithFrame:frame style:style];
    
    if (self) {
        [self updateForecast:data];
    }
    
    return self;
}

-(void) updateForecast:(NSSet *)data {
    forecastData = [NSMutableArray array];
    for (id item in data) {
        [forecastData addObject:item];
    }
    
    [self reloadData];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [forecastData count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
    Forecast_weather *forecast = forecastData[indexPath.row];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd.MM"];
    cell.textLabel.text = [formatter stringFromDate:forecast.dt];
    cell.detailTextLabel.text = [[forecast.descript stringByAppendingString: @" "] stringByAppendingString:[NSString stringWithFormat:@"%.f %@C", round([forecast.temp doubleValue]), @"\u00B0"]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

@end

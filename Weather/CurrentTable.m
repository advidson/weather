//
//  CurrentTable.m
//  Weather
//
//  Created by Term Yad on 14.06.16.
//  Copyright © 2016 AntDavydov. All rights reserved.
//

#import "CurrentTable.h"
#import "Current_weather.h"

@interface CurrentTable() {
    Current_weather *weather;
}

@end

@implementation CurrentTable

-(instancetype) initWithFrame:(CGRect)frame style:(UITableViewStyle)style andData:(Current_weather *)data {
    self = [super initWithFrame:frame style:style];
    
    if (self) {
        weather = data;
    }
    
    return self;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 6;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = @"Температура";
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%.1f %@C", round([weather.temp doubleValue]), @"\u00B0"];
            break;
        case 1:
            cell.textLabel.text = @"Максимальная температура";
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%.1f %@C", round([weather.temp_max doubleValue]), @"\u00B0"];
            break;
        case 2:
            cell.textLabel.text = @"Минимальная температура";
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%.1f %@C", round([weather.temp_min doubleValue]), @"\u00B0"];
            break;
        case 3:
            cell.textLabel.text = @"Давление";
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%.f мбар", round([weather.pressure doubleValue])];
            break;
        case 4:
            cell.textLabel.text = @"Влажность";
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%.f %%", round([weather.humidity doubleValue])];
            break;
        case 5:
            cell.textLabel.text = @"Ветер";
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%.1f м/с", round([weather.wind doubleValue])];
            break;
            
        default:
            break;
    }
    return cell;
}


@end

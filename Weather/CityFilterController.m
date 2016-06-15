//
//  CityFilterController.m
//  Weather
//
//  Created by Term Yad on 31.05.16.
//  Copyright © 2016 AntDavydov. All rights reserved.
//

#import "CityFilterController.h"
#import "City.h"

@interface CityFilterController ()

@end

@implementation CityFilterController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerClass:[UITableViewCell self] forCellReuseIdentifier:@"FilterCell"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.filterResult count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = (UITableViewCell *)[self.tableView dequeueReusableCellWithIdentifier:@"FilterCell"];
    City *city = self.filterResult[indexPath.row];
    cell.textLabel.text = city.name;
    
    return cell;
}


@end

//
//  RootController.m
//  Weather
//
//  Created by Term Yad on 31.05.16.
//  Copyright © 2016 AntDavydov. All rights reserved.
//

#import "RootController.h"
#import "DataProvider.h"
#import "DetailController.h"


@interface RootController () {
    NSArray *cities;
}

@end

@implementation RootController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"Погода";
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                                           target:self
                                                                                           action:@selector(showCountryList)];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self
                            action:@selector(updateWeather)
                  forControlEvents:UIControlEventValueChanged];
    
    [self.tableView reloadData];
    [self updateWeather];
    
}

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView reloadData];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appendData) name:@"currentWeatherAdded" object:nil];
    
}

-(void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void) appendData {
    cities = [NSArray arrayWithArray:[[DataProvider sharedData] favoriteList]];
    [self.tableView reloadData];
}

-(void) updateWeather {
    
    [[DataProvider sharedData] updateCurrentWeather:cities];
    cities = [[DataProvider sharedData] favoriteList];
    [self.refreshControl endRefreshing];
    [self.tableView reloadData];
}

-(void)showCountryList {
    [self.navigationController presentViewController:[[CityNavigationController alloc] init] animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [cities count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"Cell"];
    
    if(!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"Cell"];
    }
    
    Favorite *city = cities[indexPath.row];
    if (city) {
        cell.textLabel.text = [NSString stringWithFormat:@"%@",city.city.name];
        if (city.current) {
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ %@C", city.current.temp, @"\u00B0"];
        } else {
            cell.detailTextLabel.text = @"--";
        }
    } else {
        cell.textLabel.text = @"Test";
    }
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        [[DataProvider sharedData] removeFromFavorite:cities[indexPath.row]];
        cities = [[DataProvider sharedData] favoriteList];
        [tableView deleteRowsAtIndexPaths:@[indexPath]
                         withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    [[DataProvider sharedData] moveItemAtIndex:sourceIndexPath.row
                                       toIndex:destinationIndexPath.row];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Favorite *city = cities[indexPath.row];
    DetailController *detail = [[DetailController alloc] init];
    detail.headerTitle = city.city.name;
    detail.city = city;
    [self.navigationController pushViewController:detail animated:YES];
    
}

@end

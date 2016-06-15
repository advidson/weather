//
//  CityListController.m
//  Weather
//
//  Created by Term Yad on 31.05.16.
//  Copyright © 2016 AntDavydov. All rights reserved.
//

#import "CityListController.h"
#import "CityFilterController.h"
#import "DataProvider.h"
#import "City.h"

@interface CityListController() <UISearchBarDelegate, UISearchControllerDelegate, UISearchResultsUpdating> {
    NSArray *cities;
    UISearchController *search;
    CityFilterController *resultController;
}


@end

@implementation CityListController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"Список доступных городов";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                                                          target:self
                                                                                          action:@selector(hideCitySearch)];
    cities = [[[DataProvider sharedData] citiesList] copy];
    
    //add search
    resultController = [[CityFilterController alloc] init];
    search = [[UISearchController alloc] initWithSearchResultsController:resultController];
    search.searchResultsUpdater = self;
    search.searchBar.placeholder = @"Начните вводить название города...";
    [search.searchBar sizeToFit];
    search.dimsBackgroundDuringPresentation = NO;
    resultController.tableView.delegate = self;
    search.delegate = self;
    search.searchBar.delegate = self;
    [search loadViewIfNeeded];
    
    self.tableView.tableHeaderView = search.searchBar;
    self.definesPresentationContext = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) hideCitySearch {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UISearchBarDelegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
}

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    NSString *searchText = searchController.searchBar.text;
    
    CityFilterController *tableController = (CityFilterController *)search.searchResultsController;
    tableController.filterResult = [[DataProvider sharedData] searchCityByName:searchText];
    [tableController.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [cities count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CityCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CityCell"];
    }
    City *city = cities[indexPath.row];
    cell.textLabel.text = city.name;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    City *city;
    if ([tableView isEqual:resultController.tableView]) {
        city = resultController.filterResult[indexPath.row];
    } else {
        city = cities[indexPath.row];
    }
    
    [[DataProvider sharedData] addToFavorite:city];
    [self hideCitySearch];
}

@end

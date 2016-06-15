//
//  DataProvider.h
//  Weather
//
//  Created by Term Yad on 31.05.16.
//  Copyright © 2016 AntDavydov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "InternalDataManager.h"
#import "APIProvider.h"
@class Reachability;

@interface DataProvider : NSObject

+(instancetype) sharedData;
-(NSArray *) citiesList;
-(void) addCities: (NSArray *) cities;
-(NSArray *) searchCityByName: (NSString *) name;
-(void) addToFavorite: (City *) city;
-(NSArray *) favoriteList;
-(void) removeFromFavorite: (Favorite *) city;
- (void)moveItemAtIndex:(NSUInteger)fromIndex toIndex:(NSUInteger)toIndex;
-(void) updateCurrentWeather:(NSArray *)cities;
-(void) forecastForCity:(Favorite *)city completion:(void(^)(NSInteger status, NSArray *data))completitionBlock;
-(NSArray *) favoriteById:(NSNumber *) cityId;
@end

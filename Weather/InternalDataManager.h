//
//  InternalDataManager.h
//  Weather
//
//  Created by Term Yad on 31.05.16.
//  Copyright © 2016 AntDavydov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "City.h"
#import "Favorite.h"
#import "Current_weather.h"
#import "Forecast_weather.h"
@import CoreData;

@interface InternalDataManager : NSObject

@property (nonatomic, strong) NSManagedObjectContext *context;
@property (nonatomic, strong) NSManagedObjectModel *model;
@property (nonatomic, strong) NSPersistentStoreCoordinator *psc;

-(NSArray *)citiesList;
-(BOOL)addCities:(NSArray *) listOfCities;
-(NSArray *) searchCityByName: (NSString *) name;
-(City *) findCityByid:(NSUInteger) cityId;
-(BOOL) addToFavorite: (City *) city;
-(NSArray *) favoriteList;
-(void) removeFromFavorite: (Favorite *) city;
- (void)moveItemAtIndex:(NSUInteger)fromIndex toIndex:(NSUInteger)toIndex;
-(void)addCurentWeather:(NSArray *) weateher;
-(void) updateCurrentWeather:(NSArray *) weather;
-(void) addForecast:(NSArray *)weather;
-(Favorite *) favoriteCityById: (NSNumber *) cityId;
@end

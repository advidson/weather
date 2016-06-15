//
//  Favorite+CoreDataProperties.h
//  Weather
//
//  Created by Term Yad on 14.06.16.
//  Copyright © 2016 AntDavydov. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Favorite.h"

NS_ASSUME_NONNULL_BEGIN

@interface Favorite (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *cityId;
@property (nullable, nonatomic, retain) NSNumber *position;
@property (nullable, nonatomic, retain) City *city;
@property (nullable, nonatomic, retain) Current_weather *current;
@property (nullable, nonatomic, retain) NSOrderedSet<Forecast_weather *> *forecast;

@end

@interface Favorite (CoreDataGeneratedAccessors)

- (void)insertObject:(Forecast_weather *)value inForecastAtIndex:(NSUInteger)idx;
- (void)removeObjectFromForecastAtIndex:(NSUInteger)idx;
- (void)insertForecast:(NSArray<Forecast_weather *> *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeForecastAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInForecastAtIndex:(NSUInteger)idx withObject:(Forecast_weather *)value;
- (void)replaceForecastAtIndexes:(NSIndexSet *)indexes withForecast:(NSArray<Forecast_weather *> *)values;
- (void)addForecastObject:(Forecast_weather *)value;
- (void)removeForecastObject:(Forecast_weather *)value;
- (void)addForecast:(NSOrderedSet<Forecast_weather *> *)values;
- (void)removeForecast:(NSOrderedSet<Forecast_weather *> *)values;

@end

NS_ASSUME_NONNULL_END

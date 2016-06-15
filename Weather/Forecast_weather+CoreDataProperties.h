//
//  Forecast_weather+CoreDataProperties.h
//  Weather
//
//  Created by Term Yad on 14.06.16.
//  Copyright © 2016 AntDavydov. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Forecast_weather.h"

NS_ASSUME_NONNULL_BEGIN

@interface Forecast_weather (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *cityId;
@property (nullable, nonatomic, retain) NSString *descript;
@property (nullable, nonatomic, retain) NSDate *dt;
@property (nullable, nonatomic, retain) NSNumber *temp;
@property (nullable, nonatomic, retain) Favorite *city;

@end

NS_ASSUME_NONNULL_END

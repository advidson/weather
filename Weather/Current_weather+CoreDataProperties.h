//
//  Current_weather+CoreDataProperties.h
//  Weather
//
//  Created by Term Yad on 14.06.16.
//  Copyright © 2016 AntDavydov. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Current_weather.h"

NS_ASSUME_NONNULL_BEGIN

@interface Current_weather (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *cityId;
@property (nullable, nonatomic, retain) NSString *descript;
@property (nullable, nonatomic, retain) NSNumber *humidity;
@property (nullable, nonatomic, retain) NSString *icon;
@property (nullable, nonatomic, retain) NSNumber *pressure;
@property (nullable, nonatomic, retain) NSNumber *temp;
@property (nullable, nonatomic, retain) NSNumber *temp_max;
@property (nullable, nonatomic, retain) NSNumber *temp_min;
@property (nullable, nonatomic, retain) NSDate *update;
@property (nullable, nonatomic, retain) NSNumber *wind;
@property (nullable, nonatomic, retain) Favorite *city;

@end

NS_ASSUME_NONNULL_END

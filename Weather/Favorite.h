//
//  Favorite.h
//  Weather
//
//  Created by Term Yad on 14.06.16.
//  Copyright © 2016 AntDavydov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class City, Current_weather, Forecast_weather;

NS_ASSUME_NONNULL_BEGIN

@interface Favorite : NSManagedObject

// Insert code here to declare functionality of your managed object subclass

@end

NS_ASSUME_NONNULL_END

#import "Favorite+CoreDataProperties.h"

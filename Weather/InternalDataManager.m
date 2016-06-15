//
//  InternalDataManager.m
//  Weather
//
//  Created by Term Yad on 31.05.16.
//  Copyright © 2016 AntDavydov. All rights reserved.
//

#import "InternalDataManager.h"

@interface InternalDataManager() {
    NSArray *citiesList;
    NSMutableArray *favoriteList;
}

@end

@implementation InternalDataManager

-(instancetype) init {
    self = [super init];
    
    if (self) {
        [self configureDb];
        favoriteList = [NSMutableArray arrayWithArray:[self loadFavoriteList]];
    }
    
    return self;
}

-(void) configureDb {
    _model = [NSManagedObjectModel mergedModelFromBundles:nil];
    _psc =
    [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:_model];
    
    NSString *path = [self dbPath];
    NSURL *storeURL = [NSURL fileURLWithPath:path];
    
    NSError *error = nil;
    
    if (![_psc addPersistentStoreWithType:NSSQLiteStoreType
                           configuration:nil
                                     URL:storeURL
                                 options:nil
                                   error:&error]) {
        @throw [NSException exceptionWithName:@"OpenFailure"
                                       reason:[error localizedDescription]
                                     userInfo:nil];
    }
    _context = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    _context.persistentStoreCoordinator = _psc;
}

- (NSString *) dbPath {
    NSArray *documentDirectories =
    NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                        NSUserDomainMask,
                                        YES);
    NSString *documentDirectory = [documentDirectories firstObject];
    return [documentDirectory stringByAppendingPathComponent:@"Weather.sqlite"];
}

- (NSURL *) applicationDocumentsDirectory {
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

-(NSArray *) citiesList {
    NSError *error;
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    request.entity = [NSEntityDescription entityForName:@"City"
                                 inManagedObjectContext:self.context];
    
    NSSortDescriptor *nameSort = [NSSortDescriptor
                            sortDescriptorWithKey:@"name"
                            ascending:YES];
    

    NSPredicate *nameLenght = [NSPredicate predicateWithFormat:@"(name.length > 2)"];
    request.sortDescriptors = @[nameSort];
    request.predicate = nameLenght;
    
    NSArray *result = [self.context executeFetchRequest:request error:&error];
    if (!result) {
        [NSException raise:@"Fetch failed"
                    format:@"Reason: %@", [error localizedDescription]];
    }
    citiesList = [NSArray  arrayWithArray:result];
    return citiesList;
}

-(BOOL) addCities:(NSArray *) listOfCities {
    NSInteger num = [listOfCities count];
    int i = 0;
    for (id obj in listOfCities) {
        City *city = [NSEntityDescription insertNewObjectForEntityForName:@"City"
                                                   inManagedObjectContext:_context];

        city.id = [obj objectForKey:@"_id"];
        city.name = [obj objectForKey:@"name"];
        city.country = [obj objectForKey:@"country"];
        
        NSError *error;
        if (![_context save:&error]) {
            NSLog(@"Problem: %@", [error localizedDescription]);
        } else {
            i++;
        }
        // add msc and spb
        if ([city.id integerValue] == 524901 || [city.id integerValue] == 498817) {
            [self addToFavorite:city];
        }
    }
    
    if (i == num) {
        return true;
    } else {
        return false;
    }
    
    
}

-(City *) findCityByid:(NSUInteger) cityId {
    NSError *error;
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    request.entity = [NSEntityDescription entityForName:@"City"
                                 inManagedObjectContext:self.context];
    
    request.predicate  = [NSPredicate predicateWithFormat:@"id=%d", cityId];

    
    NSArray *result = [self.context executeFetchRequest:request error:&error];
    if (!result) {
        [NSException raise:@"Fetch failed"
                    format:@"Reason: %@", [error localizedDescription]];
    }
    return result[0];
}

-(NSArray *) searchCityByName: (NSString *) name {
    NSError *error;
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    request.entity = [NSEntityDescription entityForName:@"City"
                                 inManagedObjectContext:self.context];
    NSSortDescriptor *nameSort = [NSSortDescriptor
                                  sortDescriptorWithKey:@"name"
                                  ascending:YES];
    request.predicate = [NSPredicate predicateWithFormat:@"name BEGINSWITH[cd] %@", name];
    request.sortDescriptors = @[nameSort];
    
    NSArray *result = [self.context executeFetchRequest:request error:&error];
    if (!result) {
        [NSException raise:@"Fetch failed"
                    format:@"Reason: %@", [error localizedDescription]];
    }
    return [NSArray arrayWithArray:result];
}

-(NSArray *) favoriteList {
    return (NSArray *)favoriteList;
}

-(NSArray *) loadFavoriteList {
    NSError *error;
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    request.entity = [NSEntityDescription entityForName:@"Favorite"
                                 inManagedObjectContext:self.context];;
    NSSortDescriptor *sort = [NSSortDescriptor
                                  sortDescriptorWithKey:@"position"
                                  ascending:YES];
    request.sortDescriptors = @[sort];
    NSArray *result = [self.context executeFetchRequest:request error:&error];
    if (!result) {
        [NSException raise:@"Fetch failed"
                    format:@"Reason: %@", [error localizedDescription]];
    }
    
    return [[NSArray alloc] initWithArray:result];
}

-(Favorite *) favoriteCityById: (NSNumber *) cityId {
    NSError *error;
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    request.entity = [NSEntityDescription entityForName:@"Favorite"
                                 inManagedObjectContext:self.context];
    request.predicate = [NSPredicate predicateWithFormat:@"cityId = %d", [cityId integerValue]];
    NSArray *result = [self.context executeFetchRequest:request error:&error];
    return result[0];
}

-(BOOL) addToFavorite: (City *) city {
    double order;
    if ([favoriteList count] == 0) {
        order = 1.0;
    } else {
        order = [[[favoriteList lastObject] position] doubleValue] + 1.0;
    }
    NSError *error;
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Favorite"];
    request.predicate = [NSPredicate predicateWithFormat:@"cityId = %d", [city.id integerValue]];
    NSArray *cities = [self.context executeFetchRequest:request error:&error];
    
    if ([cities count] == 0) {
        Favorite *item = [NSEntityDescription insertNewObjectForEntityForName:@"Favorite"
                                                       inManagedObjectContext:self.context];
        item.position = [NSNumber numberWithDouble: order];
        item.cityId = city.id;
        item.city = city;
        
        NSError *error;
        if (![_context save:&error]) {
            NSLog(@"Problem: %@", [error localizedDescription]);
            return false;
        } else {
            [favoriteList addObject:item];
            return true;
        }
    } else {
        return false;
    }
    
    
}

-(void) removeFromFavorite: (Favorite *) city {
    
    [self.context deleteObject:city];
    NSError *error;
    if (![_context save:&error]) {
        NSLog(@"Problem: %@", [error localizedDescription]);
    } else {
        [favoriteList removeObjectIdenticalTo:city];
    }
    
}

-(void)moveItemAtIndex:(NSUInteger)fromIndex toIndex:(NSUInteger)toIndex {
    if (fromIndex == toIndex) {
        return;
    }
    
    Favorite *item =favoriteList[fromIndex];
    [favoriteList removeObjectAtIndex:fromIndex];
    [favoriteList insertObject:item atIndex:toIndex];
    
    double lowerBound = 0.0;
    if (toIndex > 0) {
        lowerBound = [[favoriteList[(toIndex - 1)] position] doubleValue];
    } else {
        lowerBound = [[favoriteList[1] position] doubleValue] - 2.0;
    }
    
    double upperBound = 0.0;
    if (toIndex < [favoriteList count] - 1) {
        upperBound = [[favoriteList[(toIndex + 1)] position] doubleValue];
    } else {
        upperBound = [[favoriteList[(toIndex - 1)] position] doubleValue] + 2.0;
    }
    
    item.position = [NSNumber numberWithDouble:(lowerBound + upperBound) / 2.0];
    
    NSError *error;
    if (![_context save:&error]) {
        NSLog(@"Problem: %@", [error localizedDescription]);
    }
}

-(void) addCurentWeather:(NSArray *) weather {
    NSDictionary *current = weather[0];
    
    Current_weather *w = [NSEntityDescription insertNewObjectForEntityForName:@"Current_weather"
                                                   inManagedObjectContext:self.context];
    w.descript = [current valueForKey:@"descript"];
    w.humidity = [current valueForKey:@"humidity"];
    w.pressure = [current valueForKey:@"pressure"];
    w.temp = [current valueForKey:@"temp"];
    w.temp_max = [current valueForKey:@"temp_max"];
    w.temp_min = [current valueForKey:@"temp_min"];
    w.wind = [current valueForKey:@"wind"];
    w.update = [NSDate date];
    w.cityId = [current valueForKey:@"cityId"];
    w.icon = @"02d";
    w.city = [self favoriteCityById:[current valueForKey:@"cityId"]];

    NSError *error;
    if (![_context save:&error]) {
        NSLog(@"Problem: %@", [error localizedDescription]);
    } else {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"currentWeatherAdded" object:self];
    }
}

-(void) updateCurrentWeather:(NSArray *) weather {
    NSError *error;
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    request.entity = [NSEntityDescription entityForName:@"Current_weather"
                                 inManagedObjectContext:self.context];
    
    NSArray *result = [self.context executeFetchRequest:request error:&error];
    if (result) {
        
        
        for (NSDictionary *current in weather) {
            bool find = false;
            for (Current_weather *item in result) {
                if ([[current valueForKey:@"cityId"] isEqual:item.cityId]) {
                    
                    item.descript = [current valueForKey:@"descript"];
                    item.humidity = [current valueForKey:@"humidity"];
                    item.pressure = [current valueForKey:@"pressure"];
                    item.temp = [current valueForKey:@"temp"];
                    item.temp_max = [current valueForKey:@"temp_max"];
                    item.temp_min = [current valueForKey:@"temp_min"];
                    item.update = [NSDate date];
                    item.cityId = [current valueForKey:@"cityId"];
                    item.icon = @"02d";
                    item.wind = [current valueForKey:@"wind"];
                    item.city = [self favoriteCityById:[current valueForKey:@"cityId"]];
                    NSError *error;
                    [_context save:&error];
                    find = true;
                    break;
                }
            }
            if (!find) {
                Current_weather *w = [NSEntityDescription insertNewObjectForEntityForName:@"Current_weather"
                                                                   inManagedObjectContext:self.context];
                w.descript = [current valueForKey:@"descript"];
                w.humidity = [current valueForKey:@"humidity"];
                w.pressure = [current valueForKey:@"pressure"];
                w.temp = [current valueForKey:@"temp"];
                w.temp_max = [current valueForKey:@"temp_max"];
                w.temp_min = [current valueForKey:@"temp_min"];
                w.wind = [current valueForKey:@"wind"];
                w.update = [NSDate date];
                w.cityId = [current valueForKey:@"cityId"];
                w.icon = @"02d";
                w.city = [self favoriteCityById:[current valueForKey:@"cityId"]];
                
                NSError *error;
                if (![_context save:&error]) {
                    NSLog(@"Problem: %@", [error localizedDescription]);
                }
            }
        }
    }
}

-(void) addForecast:(NSArray *)weather {
    
    NSError *error;
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Forecast_weather"];
    request.predicate = [NSPredicate predicateWithFormat:@"cityId = %d", [[weather[0] valueForKey:@"cityId"] integerValue]];
    NSArray *forecats = [self.context executeFetchRequest:request error:&error];
    //error handling goes here
    if ([forecats count] > 0) {
        int i = 0;
        for (NSDictionary *current in weather) {
            
                Forecast_weather *result = forecats[i];
                result.descript = [current valueForKey:@"descript"];
                result.temp = [current valueForKey:@"temp_max"];
                result.cityId = [current valueForKey:@"cityId"];
                result.dt = current[@"date"];
                result.city = [self favoriteCityById:[current valueForKey:@"cityId"]];
                
                NSError *error;
                if (![_context save:&error]) {
                    NSLog(@"Problem: %@", [error localizedDescription]);
                }
            i++;
        }
    } else {
        for (NSDictionary *current in weather) {
            Forecast_weather *w = [NSEntityDescription insertNewObjectForEntityForName:@"Forecast_weather"
                                                                inManagedObjectContext:self.context];
            w.descript = [current valueForKey:@"descript"];
            w.temp = [current valueForKey:@"temp_max"];
            w.cityId = [current valueForKey:@"cityId"];
            w.dt = current[@"date"];
            w.city = [self favoriteCityById:[current valueForKey:@"cityId"]];
            
            NSError *error;
            if (![_context save:&error]) {
                NSLog(@"Problem: %@", [error localizedDescription]);
            }
        }
    }
}
@end

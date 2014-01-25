//
//  Evaluation.h
//  Seva
//
//  Created by Vadym Zakovinko on 1/25/14.
//  Copyright (c) 2014 Vadym Zakovinko. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Technology, User;

@interface Evaluation : NSManagedObject

@property (nonatomic, retain) NSNumber * level;
@property (nonatomic, retain) NSNumber * is_favorite;
@property (nonatomic, retain) User *user;
@property (nonatomic, retain) Technology *technology;

@end

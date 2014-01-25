//
//  Technology.h
//  Seva
//
//  Created by Vadym Zakovinko on 1/25/14.
//  Copyright (c) 2014 Vadym Zakovinko. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Technology : NSManagedObject

@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * slug;
@property (nonatomic, retain) NSNumber * avg_level;
@property (nonatomic, retain) NSManagedObject *evaluations;

@end

//
//  User.h
//  Seva
//
//  Created by Vadym Zakovinko on 1/25/14.
//  Copyright (c) 2014 Vadym Zakovinko. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface User : NSManagedObject

@property (nonatomic, retain) NSString * username;
@property (nonatomic, retain) NSString * full_name;
@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSString * bio;
@property (nonatomic, retain) NSNumber * avg_level;
@property (nonatomic, retain) NSDate * joined;
@property (nonatomic, retain) NSDate * last_login;
@property (nonatomic, retain) NSManagedObject *evaluations;

@end

//
//  DataUpdater.m
//  Seva
//
//  Created by Vadym Zakovinko on 1/25/14.
//  Copyright (c) 2014 Vadym Zakovinko. All rights reserved.
//

#import "DataUpdater.h"
#import "AFNetworking.h"


@implementation DataUpdater

- (void)updateUsers:(NSArray *)users {
    NSManagedObjectContext *context = [self managedObjectContext];
    
    for (NSDictionary *userData in users) {
        NSManagedObject *user;
        
//        NSFetchRequest *fe
    }
}

- (void)fetchUsers:(NSString *)url withFinishSignal:(dispatch_semaphore_t)endSemaphore {
    NSURL *baseUrl = [NSURL URLWithString:@"http://seva.djangostars.com/"];
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:baseUrl];
    
    [manager GET:url
      parameters:nil
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             NSDictionary *meta = [responseObject valueForKey:@"meta"];
             if (![[meta valueForKey:@"next"] isEqual:[NSNull null]]) {
                 [self fetchUsers:[meta valueForKey:@"next"] withFinishSignal:endSemaphore];
             }
             
             if ([[meta valueForKey:@"next"] isEqual:[NSNull null]]) {
                 dispatch_semaphore_signal(endSemaphore);
             }
         }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             NSLog(@"fetch users error: %@", [error description]);
         }];
}

- (void)updateTechnologies:(NSArray *)technologies {
    NSManagedObjectContext *context = [self managedObjectContext];
    
    for (NSDictionary *tech in technologies) {
        NSManagedObject *technology;
        
        NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Technology"];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"slug == %@", [tech valueForKey:@"slug"]];
        [fetchRequest setPredicate:predicate];
        NSError *fetchError = nil;
        technology = [[context executeFetchRequest:fetchRequest error:&fetchError] lastObject];

        if (fetchError) {
            NSLog(@"fetch error: %@", [fetchError description]);
        } else if (!technology) {
            technology = [NSEntityDescription insertNewObjectForEntityForName:@"Technology"
                                                       inManagedObjectContext:context];
        }
        [technology setValue:[tech valueForKey:@"title"] forKey:@"title"];
        [technology setValue:[tech valueForKey:@"slug"] forKey:@"slug"];
        [technology setValue:[tech valueForKey:@"avg"] forKey:@"avg_level"];
        
        NSError *error = nil;
        [context save:&error];
        if (error != nil) {
            NSLog(@"technology save error: %@", [error description]);
        }
    }
}

- (void)fetchTechnologies:(NSString *)url withFinishSignal:(dispatch_semaphore_t)endSemaphore {
    NSURL *baseURL = [NSURL URLWithString:@"http://seva.djangostars.com/"];
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:baseURL];
    
    [manager GET:url
      parameters:nil
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             NSDictionary *meta = [responseObject valueForKey:@"meta"];
             if (![[meta valueForKey:@"next"] isEqual:[NSNull null]]) {
                 NSLog(@"fetch: %@", [meta valueForKey:@"next"]);
                 [self fetchTechnologies:[meta valueForKey:@"next"] withFinishSignal:endSemaphore];
             }
             [self updateTechnologies:[responseObject valueForKey:@"objects"]];
             
             if ([[meta valueForKey:@"next"] isEqual:[NSNull null]]) {
//                 [self fetchUsers:@"/api/v1/users/" withFinishSignal:endSemaphore];
                 dispatch_semaphore_signal(endSemaphore);
             }
         }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             NSLog(@"fetch technology error: %@", [error description]);
             dispatch_semaphore_signal(endSemaphore);
         }];
}

- (void)updateLocalData {
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    
    [self fetchTechnologies:@"/api/v1/technology/?format=json&limit=10" withFinishSignal:semaphore];

    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    NSLog(@"Finished");
};

- (NSManagedObjectContext *)managedObjectContext {
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}


@end

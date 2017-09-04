//
//  Entity+CoreDataProperties.m
//  SampleApp
//
//  Created by INNOISDF700278 on 8/29/17.
//  Copyright © 2017 INNOISDF700278. All rights reserved.
//

#import "Entity+CoreDataProperties.h"

@implementation Entity (CoreDataProperties)

+ (NSFetchRequest<Entity *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Entity"];
}

@dynamic comments;
@dynamic location;
@dynamic image;

@end

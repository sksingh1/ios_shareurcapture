//
//  Entity+CoreDataProperties.h
//  SampleApp
//
//  Created by INNOISDF700278 on 8/29/17.
//  Copyright © 2017 INNOISDF700278. All rights reserved.
//

#import "Entity+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Entity (CoreDataProperties)

+ (NSFetchRequest<Entity *> *)fetchRequest;
@property (nullable, nonatomic, copy) NSString *categaryoption;
@property (nullable, nonatomic, copy) NSString *comments;
@property (nullable, nonatomic, copy) NSString *location;
@property (nullable, nonatomic, retain) NSData *image;
@property (nullable, nonatomic, copy) NSString *videourl;


@end

NS_ASSUME_NONNULL_END

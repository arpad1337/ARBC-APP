//
//  Book.h
//  ARBC
//
//  Created by Árpád Kiss on 2014.05.09..
//  Copyright (c) 2014 OE-NIK. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Book : NSManagedObject

@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * author;
@property (nonatomic, retain) NSString * publisher;
@property (nonatomic, retain) NSString * cover;

@end

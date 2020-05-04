//
//  Person.h
//  Book
//
//  Created by Kuei-Jung Hu on 2020/5/5.
//  Copyright © 2020 Kuei-Jung Hu. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Person : NSObject

@property (nonatomic) NSString *name;
@property (nonatomic) NSDate *birthday;

-(instancetype)initWithName:(NSString*)name
                   birthday:(NSDate*)birthday;

@end

NS_ASSUME_NONNULL_END

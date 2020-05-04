//
//  House.h
//  House
//
//  Created by Kuei-Jung Hu on 2020/5/4.
//  Copyright © 2020 Kuei-Jung Hu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Bedroom.h"

NS_ASSUME_NONNULL_BEGIN

@interface House : NSObject

@property (nonatomic, copy) NSString *address;
@property (nonatomic, readonly) int numberOfBedrooms;
@property (nonatomic) BOOL hasHotTub;

-(instancetype)initWithAddress:(NSString*)address;

// Note: Use week references for 1. delegates 2. subviews of the main view
@property (nonatomic, strong) Bedroom *frontBedroom;
@property (nonatomic, strong) Bedroom *backBedroom;

@end

NS_ASSUME_NONNULL_END

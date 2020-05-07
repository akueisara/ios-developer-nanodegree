//
//  PlaneTicket.h
//  PlaneTicket
//
//  Created by Gabrielle Miller-Messner on 4/12/16.
//  Copyright © 2016 Gabrielle Miller-Messner. All rights reserved.
//

@import Foundation;
#import "Passenger.h"

@interface PlaneTicket : NSObject

@property (nonatomic, copy) NSString * _Nonnull departureCity;
@property (nonatomic, copy) NSString * _Nonnull destination;
@property (nonatomic)       NSDate * _Nonnull departureDate;
@property (nonatomic, copy) NSString * _Nullable seatAssignment;
@property (nonatomic) Passenger * _Nonnull passenger;

-(instancetype _Nullable)initWithDestination:(NSString* _Nonnull)destination
                     departureCity:(NSString* _Nonnull)departureCity
                         passenger:(Passenger* _Nonnull)person
                              date:(NSDate* _Nonnull)departureDate;

@end

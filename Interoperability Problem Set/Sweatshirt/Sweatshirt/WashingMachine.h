//
//  WashingMachine.h
//  Sweatshirt
//
//  Created by Gabrielle Miller-Messner on 4/12/16.
//  Copyright © 2016 Gabrielle Miller-Messner. All rights reserved.
//

@import Foundation;
#import "Sweatshirt.h"

@interface WashingMachine : NSObject

@property (nonatomic) NSArray * _Nonnull clothes;

-(Sweatshirt* _Nonnull)wash:(Sweatshirt* _Nonnull)sweatshirt;

@end

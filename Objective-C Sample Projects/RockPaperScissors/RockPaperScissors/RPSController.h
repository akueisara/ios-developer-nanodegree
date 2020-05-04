//
//  RPSController.h
//  RockPaperScissors
//
//  Created by Kuei-Jung Hu on 2020/5/5.
//  Copyright © 2020 Kuei-Jung Hu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RPSGame.h"

NS_ASSUME_NONNULL_BEGIN

@interface RPSController : NSObject

@property (nonatomic) RPSGame *game;

-(void)throwDown:(Move) playersMove;
-(NSString*)messageForGame:(RPSGame*)game;

@end

NS_ASSUME_NONNULL_END

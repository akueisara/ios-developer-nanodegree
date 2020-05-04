//
//  main.m
//  RockPaperScissors
//
//  Created by Kuei-Jung Hu on 2020/5/5.
//  Copyright © 2020 Kuei-Jung Hu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RPSTurn.h"
#import "RPSController.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        
        // Initialize an instance of RPSController
        RPSController *gameController = [[RPSController alloc] init];
        // Send the message throwDown: to the game controller you just created
        [gameController throwDown: Paper];
        // Create an NSString called results message
        // Call the method, messageForGame: using the gameController you just created
        // Pass gameController.game as a parameter to messageForGame:
        NSString *resultsMessage = [gameController messageForGame: gameController.game];
        // Assign the return value of messageForGame: to the resultsMessage string
        NSLog(@"%@", resultsMessage);
    }
    return 0;
}

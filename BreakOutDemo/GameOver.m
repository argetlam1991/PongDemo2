//
//  GameOver.m
//  BreakOutDemo
//
//  Created by Gu Han on 6/29/17.
//  Copyright © 2017 Gu Han. All rights reserved.
//

#import "GameOver.h"
#import "GameScene.h"
@implementation GameOver{
  SKLabelNode *_label;
}

- (void)didMoveToView:(SKView *)view {
  // Setup your scene here
  
  // Get label node from scene and store it for use later
  _label = (SKLabelNode *)[self childNodeWithName:@"//GameOverLabel"];
  _label.alpha = 0.0;
  [_label runAction:[SKAction fadeInWithDuration:2.0]];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
  if(touches) {
    SKView *skview = (SKView *)self.view;
    GameScene *scene = [GameScene nodeWithFileNamed:@"GameScene"];
    scene.scaleMode = SKSceneScaleModeAspectFit;
    
    [skview presentScene:scene];
  }
}

@end

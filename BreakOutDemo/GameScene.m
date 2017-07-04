//
//  GameScene.m
//  BreakOutDemo
//
//  Created by Gu Han on 6/29/17.
//  Copyright © 2017 Gu Han. All rights reserved.
//

#import "GameScene.h"
#import "GameOver.h"


static const CGFloat kTrackPointsPerSecond = 1000;

static const uint32_t category_fence  = 0x1 << 3;
static const uint32_t category_paddle = 0x1 << 2;
static const uint32_t category_block  = 0x1 << 1;
static const uint32_t category_ball   = 0x1 << 0;

@interface GameScene () <SKPhysicsContactDelegate>

@property (nonatomic, strong, nullable) UITouch *motivatingTouch;

@end


@implementation GameScene {
  SKLabelNode *_label;
}

- (void)didMoveToView:(SKView *)view {
  // Setup your scene here
  self.name = @"Fence";
  self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:self.frame];
  self.physicsBody.categoryBitMask = category_fence;
  self.physicsBody.collisionBitMask = 0x0;
  self.physicsBody.contactTestBitMask = 0x0;
  
  
  self.physicsWorld.contactDelegate = self;
  
  
  
  
  
  
  
  SKSpriteNode *ball1 = [SKSpriteNode spriteNodeWithImageNamed:@"ball.png"];
  ball1.name = @"Ball";
  ball1.position = CGPointMake(0, 0);
  ball1.zPosition = 1;
  
  
  ball1.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:ball1.size.width/2];
  ball1.physicsBody.dynamic = YES;
  ball1.physicsBody.friction = 0.0;
  ball1.physicsBody.restitution = 1.0;
  ball1.physicsBody.linearDamping = 0.0;
  ball1.physicsBody.angularDamping = 0.0;
  ball1.physicsBody.allowsRotation = NO;
  ball1.physicsBody.mass = 1.0;
  ball1.physicsBody.velocity = CGVectorMake(200.0, 200.0);
  ball1.physicsBody.affectedByGravity = NO;
  ball1.physicsBody.categoryBitMask = category_ball;
  ball1.physicsBody.collisionBitMask = category_fence | category_ball | category_block | category_paddle;
  ball1.physicsBody.contactTestBitMask = category_fence | category_block;
  ball1.physicsBody.usesPreciseCollisionDetection = YES;

  
  
  SKSpriteNode *paddle = [SKSpriteNode spriteNodeWithImageNamed:@"paddle.png"];
  paddle.name = @"Paddle";
  paddle.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(paddle.size.width, paddle.size.height)];
  paddle.physicsBody.dynamic = NO;
  paddle.position = CGPointMake(0,  - (self.size.height/2 - paddle.size.height/2));
  paddle.physicsBody.friction = 0.0;
  paddle.physicsBody.restitution = 1.0;
  paddle.physicsBody.linearDamping = 0.0;
  paddle.physicsBody.angularDamping = 0.0;
  paddle.physicsBody.allowsRotation = NO;
  paddle.physicsBody.mass = 1.0;
  paddle.physicsBody.velocity = CGVectorMake(0.0, 0.0);
  paddle.physicsBody.categoryBitMask = category_paddle;
  paddle.physicsBody.collisionBitMask = 0x0;
  paddle.physicsBody.contactTestBitMask = category_ball;
  paddle.physicsBody.usesPreciseCollisionDetection = YES;
  
  
  [self addChild:ball1];
  [self addChild:paddle];
  
  SKSpriteNode *node = [SKSpriteNode spriteNodeWithColor:[UIColor greenColor] size:CGSizeMake(100, 30)];
  CGFloat kBlockWidth = node.size.width;
  CGFloat kBlockHeight = node.size.height;
  CGFloat kBlockHorizSpace = 20.0f;
  int kBlockPerRow = (self.size.width / (kBlockWidth + kBlockHorizSpace));
  
  
  for (int j = 0; j < 2; j++) {
    for (int i = 0; i < kBlockPerRow; i++) {
      node = [SKSpriteNode spriteNodeWithColor:[UIColor greenColor] size:CGSizeMake(100, 30)];
      node.name = @"Block";
      node.position = CGPointMake(-self.size.width / 2 +  kBlockHorizSpace/2 + kBlockWidth/2 + i*(kBlockWidth+kBlockHorizSpace), self.size.height/2 - 30 - kBlockHeight/2 - j*(1.5*kBlockHeight));
      node.zPosition = 1;
      node.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:node.size center:CGPointMake(0, 0)];
      node.physicsBody.dynamic = NO;
      node.physicsBody.friction = 0.0;
      node.physicsBody.restitution = 0.0;
      node.physicsBody.linearDamping = 0.0;
      node.physicsBody.angularDamping = 0.0;
      node.physicsBody.allowsRotation = NO;
      node.physicsBody.mass = 1.0;
      node.physicsBody.velocity = CGVectorMake(0, 0);
      node.physicsBody.categoryBitMask = category_block;
      node.physicsBody.collisionBitMask = 0x0;
      node.physicsBody.contactTestBitMask = category_ball;
      node.physicsBody.usesPreciseCollisionDetection = NO;
      [self addChild:node];
      
    }
  }
  

  
  
  
  
  // Get label node from scene and store it for use later
  _label = (SKLabelNode *)[self childNodeWithName:@"//helloLabel"];
  
  _label.alpha = 0.0;
  [_label runAction:[SKAction fadeInWithDuration:2.0]];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
  const CGRect touchRegion = CGRectMake(-self.size.width/2, - self.size.height * 0.5, self.size.width, self.size.height * 0.3);
  for(UITouch *touch in touches) {
    CGPoint p = [touch locationInNode:self];
    if (CGRectContainsPoint(touchRegion, p)) {
      self.motivatingTouch = touch;
      
    }
  }
  
  [self trackPaddlesToMotivatingTouches];

}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
  [self trackPaddlesToMotivatingTouches];
  
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
  if ([touches containsObject:self.motivatingTouch]) {
    self.motivatingTouch = nil;
  }
  
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
  if ([touches containsObject:self.motivatingTouch]) {
    self.motivatingTouch = nil;
  }
}

- (void) trackPaddlesToMotivatingTouches {
  SKNode *node = [self childNodeWithName:@"Paddle"];
  UITouch *touch = self.motivatingTouch;
  if (!touch)
    return;
  CGFloat xPos = [touch locationInNode:self].x;
  NSTimeInterval duration = ABS(xPos - node.position.x) / kTrackPointsPerSecond;
  [node runAction:[SKAction moveToX:xPos duration:duration]];
  
}

- (void)update:(NSTimeInterval)currentTime {
  static const int kMaxSpeed = 1500;
  static const int kMinSpeed = 400;
  
  SKNode *ball1 = [self childNodeWithName:@"Ball"];
  float dx = (ball1.physicsBody.velocity.dx) / 2;
  float dy = (ball1.physicsBody.velocity.dy) / 2;
  float speed = sqrt(dx*dx + dy*dy);
  if (speed > kMaxSpeed) {
    ball1.physicsBody.linearDamping += 0.1;
  } else if (speed < kMinSpeed) {
    ball1.physicsBody.linearDamping -= 0.1;
  } else {
    ball1.physicsBody.linearDamping = 0.0;
  }
  
}

- (void)didBeginContact:(SKPhysicsContact *)contact {
  NSString *nameA = contact.bodyA.node.name;
  NSString *nameB = contact.bodyB.node.name;
  if (([nameA containsString:@"Fence"] && [nameB containsString:@"Ball"]) ||
       ([nameA containsString:@"Ball"] && [nameB containsString:@"Fence"])) {
    NSLog(@"%f", contact.contactPoint.y);
    if (contact.contactPoint.y < -self.size.height/2 + 100) {
      SKView * skView = (SKView *)self.view;
      [self removeFromParent];
      GameOver *scene = [GameOver nodeWithFileNamed:@"GameOver"];
      scene.scaleMode = SKSceneScaleModeFill;
      [skView presentScene:scene];
    }
  } else if(([nameA containsString:@"Block"] && [nameB containsString:@"Ball"]) ||
            ([nameA containsString:@"Ball"] && [nameB containsString:@"Block"])) {
    if ([nameA containsString:@"Block"]) {
      [contact.bodyA.node removeFromParent];
    } else {
      [contact.bodyB.node removeFromParent];
    }
    
  } else {
    NSLog(@"%@ %@", nameA, nameB);
  }
}

@end

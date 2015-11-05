//
//  Ball.swift
//  PongTV
//
//  Created by Normann Zsolt on 29/10/15.
//  Copyright © 2015 Zsolt Normann. All rights reserved.
//

import SpriteKit

class Ball: SKSpriteNode {

  // MARK: - init Arena
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  init() {
    super.init(texture: nil, color: UIColor.whiteColor(), size: CGSize(width: Const.BallSize.Length , height: Const.BallSize.Length))
    
    self.zPosition = Const.ZPos.Paddle
    self.physicsBody = SKPhysicsBody(rectangleOfSize: self.size)
    self.physicsBody?.usesPreciseCollisionDetection = true
    self.physicsBody?.affectedByGravity = false
    self.physicsBody?.dynamic = true
    self.physicsBody?.allowsRotation = false
    self.physicsBody?.collisionBitMask = Const.PhysicsCategory.Ball | Const.PhysicsCategory.Wall | Const.PhysicsCategory.Paddle1 | Const.PhysicsCategory.Paddle2
    self.physicsBody?.categoryBitMask = Const.PhysicsCategory.Ball
    self.physicsBody?.contactTestBitMask = (self.physicsBody?.collisionBitMask)!
    self.physicsBody?.restitution = 1
    self.physicsBody?.linearDamping = 0
    self.physicsBody?.friction = 0.0
    self.physicsBody?.angularDamping = 0
  }
  
  func isOut() -> Int {
    if self.position.x > self.parent?.frame.width {
      return 1
    } else if self.position.x < 0 {
      return 0
    }
    return -1
  }

}

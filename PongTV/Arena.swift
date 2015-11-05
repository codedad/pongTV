//
//  Arena.swift
//  PongTV
//
//  Created by Normann Zsolt on 12/10/15.
//  Copyright © 2015 Zsolt Normann. All rights reserved.
//

import SpriteKit

class Arena: SKNode {
  var scores = [Int](count: 4, repeatedValue: 0)
  var scoreLabels = [UILabel]()
  var arenaSize : CGSize = CGSize(width: 0, height: 0)
  var paddleList: [Paddle]!
  
  // MARK: - init Arena
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  init(size: CGSize) {
    super.init()
    arenaSize = size
    NSLog("arenaSize: \(arenaSize)")
    self.addFences()
    self.addLabels()
  }
  
  // MARK: - init helpers
  func addFences() {
    let fenceTop = SKSpriteNode(color: UIColor.whiteColor(), size: CGSizeMake(arenaSize.width, 10))
    fenceTop.position = CGPoint(x:0, y:285)
    fenceTop.zPosition = Const.ZPos.Background
    self.addChild(fenceTop)
    fenceTop.physicsBody = SKPhysicsBody(rectangleOfSize: fenceTop.size)
    fenceTop.physicsBody?.affectedByGravity = false
    fenceTop.physicsBody?.dynamic = false
    fenceTop.physicsBody?.allowsRotation = false
    fenceTop.physicsBody?.collisionBitMask = Const.PhysicsCategory.Ball
    fenceTop.physicsBody?.categoryBitMask = Const.PhysicsCategory.Wall
    fenceTop.physicsBody?.restitution = 1
    fenceTop.physicsBody?.linearDamping = 0
    fenceTop.physicsBody?.friction = 0
    fenceTop.physicsBody?.angularDamping = 0
    
    
    let fenceBottom = SKSpriteNode(color: UIColor.whiteColor(), size: CGSizeMake(arenaSize.width, 10))
    fenceBottom.position = CGPoint(x:0, y:-285)
    fenceBottom.zPosition = 10
    self.addChild(fenceBottom)
    fenceBottom.physicsBody = SKPhysicsBody(rectangleOfSize: fenceBottom.size)
    fenceBottom.physicsBody?.affectedByGravity = false
    fenceBottom.physicsBody?.dynamic = false
    fenceBottom.physicsBody?.allowsRotation = false
    fenceBottom.physicsBody?.collisionBitMask = Const.PhysicsCategory.Ball
    fenceBottom.physicsBody?.categoryBitMask = Const.PhysicsCategory.Wall
    fenceBottom.physicsBody?.restitution = 1
    fenceBottom.physicsBody?.linearDamping = 0
    fenceBottom.physicsBody?.friction = 0
    fenceBottom.physicsBody?.angularDamping = 0
  }
  
  func addLabel(txtAlign:SKLabelHorizontalAlignmentMode, text:String, scoreNodeName:String) {
    var xPos = CGFloat(0)
    if txtAlign == .Left {
      xPos = -arenaSize.width/2 + 50
    } else if txtAlign == .Right {
      xPos = arenaSize.width/2 - 50
    }
    let name = SKLabelNode(fontNamed:"C64Pro")
    name.text = text
    name.fontSize = 40
    name.position = CGPoint(x: xPos, y:0)
    name.zPosition = Const.ZPos.Background
    name.horizontalAlignmentMode = txtAlign
    name.fontColor = UIColor.grayColor()
    self.addChild(name)
    
    let score = SKLabelNode(fontNamed:"C64Pro")
    score.name = scoreNodeName
    score.text = "0"
    score.fontSize = 40
    score.position = CGPoint(x: xPos, y:-60)
    score.zPosition = Const.ZPos.Background
    score.horizontalAlignmentMode = txtAlign
    score.fontColor = UIColor.grayColor()
    self.addChild(score)
  }

  func addLabels() {
    self.addLabel(.Left, text: "Computer", scoreNodeName: Const.NodeName.Score+"0")
    self.addLabel(.Right, text: "Player1", scoreNodeName: Const.NodeName.Score+"1")
  }
  
  func addPaddle(paddleOrintation:Const.PaddleOrientation, myPaddle: Paddle) {
    self.addChild(myPaddle)
    if paddleOrintation == .Left {
      myPaddle.position = CGPoint(x: -arenaSize.width/2 + 20, y:0)
    } else if paddleOrintation == .Right {
      myPaddle.position = CGPoint(x: arenaSize.width/2 - 20, y:0)
    }

  }
  
  
  // MARK: - manage Scores
  func initScores() {
    for (index, _) in scores.enumerate() {
      scores[index] = 0
    }
  }
  
  func updateScores(failIndex: Int) {
    scores[failIndex]--
    for (index, _) in scores.enumerate() {
      scores[index]++
      (self.childNodeWithName(Const.NodeName.Score + String(index)) as? SKLabelNode)?.text = String(scores[index])
    }
  }
  
}
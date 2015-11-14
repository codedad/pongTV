//
//  Paddle.swift
//  PongTV
//
//  Created by Normann Zsolt on 13/10/15.
//  Copyright © 2015 Zsolt Normann. All rights reserved.
//

import SpriteKit
import GameController

class Paddle: SKSpriteNode {
  var playerID : GCControllerPlayerIndex = .IndexUnset
  var isAiOn = false
  var arenaSize : CGSize = CGSize(width: 0, height: 0)
  var gameController: GCController! = nil
  
  var yPosUpdate_prev : Float = 0
  var yPosUpdate_cur : Float = 0
  var yPosUpdateSign = 0
  
  private var up = 0
  private var down = 0
  private var movSpeed : CGFloat = 1.0

  
  private var prevcalcProxmitiyDx : CGFloat = 0
  
  // MARK: - init Arena
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  init() {
    super.init(texture: nil, color: UIColor.whiteColor(), size: CGSizeZero)
  }
  
  init(myID: GCControllerPlayerIndex, sizeTV: CGSize, isComputer: Bool) {
    super.init(texture: nil, color: UIColor.whiteColor(), size: CGSize(width: 15, height: 100))
    playerID = myID
    arenaSize = sizeTV
    isAiOn = isComputer

    self.zPosition = Const.ZPos.Paddle
    self.physicsBody = SKPhysicsBody(rectangleOfSize: self.size)
    self.physicsBody?.usesPreciseCollisionDetection = true
    self.physicsBody?.affectedByGravity = false
    self.physicsBody?.dynamic = false
    self.physicsBody?.allowsRotation = false
    self.physicsBody?.collisionBitMask = Const.PhysicsCategory.Ball | Const.PhysicsCategory.Wall
    self.physicsBody?.categoryBitMask = Const.PhysicsCategory.Paddle1
    self.physicsBody?.contactTestBitMask = Const.PhysicsCategory.Ball
    self.physicsBody?.restitution = 1
    self.physicsBody?.linearDamping = 0
    self.physicsBody?.friction = 0.0
    self.physicsBody?.angularDamping = 0
    
  }
  
  // MARK: - Controller mgmt

  func registerController(gameController : GCController) {
    NSLog("attempting to register Controller: \(gameController.vendorName)")
    if (self.gameController != nil) {
      NSLog("already registered as: \(self.gameController!.vendorName)")
      return
    }
    if isAiOn {
      NSLog("cannot add controller to Computer player")
      //TODO: felajánlani a computer helyett a humán játékost
      return
    }
    if gameController.playerIndex != .IndexUnset {
      NSLog("controller already registered to player: \(gameController.playerIndex.rawValue)")
      //TODO: felajánlani a computer helyett a humán játékost
      return
      
    }
    
    self.gameController = gameController;
    self.gameController!.playerIndex = playerID
    registerPauseEvent()
    registerAttackEvents()
    registerMovementEvents()
  }
  
  var isGameControllerRegistered: Bool {
    if isAiOn {
      // in case if it is Computer then do not assign gamecontroller
      return true
    }
    var isGameControllerRegistered = false
    if (self.gameController != nil) {
      isGameControllerRegistered = true
    }
    //NSLog("isGameControllerRegistered: \(isGameControllerRegistered)")
    return isGameControllerRegistered
  }
  
  func unregisterController(gameController : GCController) {
    if gameController.playerIndex == self.playerID {
      self.gameController = nil
    }
  }

  // MARK: - Controller events handling

  private func registerPauseEvent() {
    NSLog("** registerPauseEvent for \(self.gameController.vendorName), \(self.gameController.playerIndex.rawValue)")
    self.gameController.controllerPausedHandler = { [unowned self] _ in
      NSLog("")
      NSLog("[\(self.gameController!.playerIndex.rawValue)]: pause pressed")
    }
  }

  private func registerAttackEvents() {
    /// A handler for button press events that trigger an attack action.
    NSLog("** registerAttackEvents for \(self.gameController.vendorName) ")
    let attackHandler: GCControllerButtonValueChangedHandler = { [unowned self] button, _, pressed in
      NSLog("[\(self.gameController!.playerIndex.rawValue)]: attack pressed")
    }
    
    #if os(tvOS)
      // `GCMicroGamepad` button handlers.
      if let microGamepad = gameController!.microGamepad {
        microGamepad.buttonA.pressedChangedHandler = attackHandler
        microGamepad.buttonX.pressedChangedHandler = attackHandler
      }
    #endif
    
    // `GCGamepad` button handlers.
    if let gamepad = gameController!.gamepad {
      /*
      Assign an action to every button, even if this means that multiple
      buttons provide the same functionality. It's better to have repeated
      functionality than to have a button that doesn't do anything.
      */
      gamepad.buttonA.pressedChangedHandler = attackHandler
      gamepad.buttonB.pressedChangedHandler = attackHandler
      gamepad.buttonX.pressedChangedHandler = attackHandler
      gamepad.buttonY.pressedChangedHandler = attackHandler
      gamepad.leftShoulder.pressedChangedHandler = attackHandler
      gamepad.rightShoulder.pressedChangedHandler = attackHandler
    }
    
    // `GCExtendedGamepad` trigger handlers.
    if let extendedGamepad = gameController!.extendedGamepad {
      extendedGamepad.rightTrigger.pressedChangedHandler = attackHandler
      extendedGamepad.leftTrigger.pressedChangedHandler  = attackHandler
    }

  }
  
  private func registerMovementEvents() {
    /// An analog movement handler for D-pads and movement thumbsticks.
    let movementHandler: GCControllerDirectionPadValueChangedHandler = { [unowned self] _, xValue, yValue in
      // Move toward the direction of the axis.
      self.yPosUpdate_cur = xValue * yValue
      self.yPosUpdateSign = (yValue>0 ? 1 : -1)

//      let displacement = float2(x: xValue, y: yValue)
      //NSLog("[\(self.gameController!.playerIndex.rawValue)]: moving: \(self.yPosUpdate_cur)")
//      var curPos = self.position
  //    var modPosY = curPos.y + 229
      
//      curPos.y += 2.0 * (yValue>0 ? 1 : -1)
      
     // var targetDisplacement = CGFloat(100.0) * yValue
/*
      if fabs(yValue) < 0.1 {
        self.removeAllActions()
      } else if yValue >= 0.1 {
        let yPositionAction = SKAction.moveBy(CGVectorMake(0, CGFloat(yValue * 4.0 )), duration: 0.01)
        self.runAction(yPositionAction)
      }
      */
      
      // topy:225
      // bottomy:-229
//      let yPositionAction = SKAction.moveBy(CGVectorMake(0, CGFloat(yValue * 2.0 )), duration: 0.01)
//      self.runAction(yPositionAction)
//      NSLog("\(curPos)")
    }
    
    #if os(tvOS)
      // `GCMicroGamepad` D-pad handler.
      if let microGamepad = gameController!.microGamepad {
        // Allow the gamepad to handle transposing D-pad values when rotating the controller.
        microGamepad.allowsRotation = true
        microGamepad.dpad.valueChangedHandler = movementHandler
      }
    #endif
    
    // `GCGamepad` D-pad handler.
    if let gamepad = gameController!.gamepad {
      gamepad.dpad.valueChangedHandler = movementHandler
    }
    
    // `GCExtendedGamepad` left thumbstick.
    if let extendedGamepad = gameController!.extendedGamepad {
      extendedGamepad.leftThumbstick.valueChangedHandler = movementHandler
    }
  }

  
  
  func aiThinking(dt:CFTimeInterval, ball:Ball)  {
    //NSLog("\(dt)")
    //let convertedBallPos = self.convertPoint(ballPos,toNode:self.parent!)
    
    let calcProxmitiyDx = fabs(self.position.x - (ball.position.x - 512))
    //NSLog("calcProxmitiyDx\(self.playerID.rawValue):\(calcProxmitiyDx) ")
    if prevcalcProxmitiyDx < calcProxmitiyDx {
      //NSLog("távolodik \(self.playerID.rawValue)")
      self.up = 0
      self.down = 0
    } else if prevcalcProxmitiyDx > calcProxmitiyDx {
      //NSLog("közeledik \(self.playerID.rawValue)")
      
      // kakulálni kell a becsapódási pontot
      
      var c = ball.physicsBody!.velocity.normalized()
      var cc = (c.dy)/c.dx*(self.position.x-ball.position.x+512)
      
      let redx = SKSpriteNode.init(color: UIColor.redColor(), size: CGSize(width: 10, height: 10))
      redx.position = CGPoint(x: self.position.x + 500, y: cc+ball.position.y)
      redx.name = "redx"
      self.parent?.parent?.childNodeWithName("redx")?.removeFromParent()
      self.parent?.parent?.addChild(redx)
      
      //NSLog("\(self.parent?.parent?.convertPoint(redx.position, toNode: self.parent!))")
      
      let predictedPos : CGPoint = (self.parent?.parent?.convertPoint(CGPoint(x: self.position.x + 500, y: cc+ball.position.y), toNode: self.parent!))!
      //let predictedPos = CGPoint(x: self.position.x, y: cc+ball.position.y)
      let diffY = fabs(predictedPos.y - self.position.y)
      self.movSpeed = 1.5 * diffY / Const.PaddleMinMax.Max
      
      //NSLog("\(predictedPos.y) ** \(self.position.y)")
      if predictedPos.y > Const.PaddleMinMax.MinExtended && predictedPos.y < Const.PaddleMinMax.MaxExtended {
        if predictedPos.y > self.position.y {
          self.up = 1
          self.down = 0
        } else if predictedPos.y < self.position.y {
          self.up = 0
          self.down = -1
        }
      }

      
      //NSLog("velo\(self.playerID.rawValue): \(ball.physicsBody?.velocity.normalized()), \(self.position.x), \(self.position.x-ball.position.x+512), cc:\(cc+ball.position.y)")
      
    }
    
    
    prevcalcProxmitiyDx = calcProxmitiyDx
  }
  
  
  func movePaddle(dt:CFTimeInterval) {
    var currPos = self.position
    let moveOrNot = self.up + self.down
    if moveOrNot != 0 {
      currPos.y += CGFloat(moveOrNot)*movSpeed
      if currPos.y > Const.PaddleMinMax.Max {
        currPos.y = Const.PaddleMinMax.Max
      } else if currPos.y < Const.PaddleMinMax.Min {
        currPos.y = Const.PaddleMinMax.Min
      }
      self.position = currPos
    }
  }
  
  
  func updatePlayer(dt:CFTimeInterval, ball:Ball?=nil) {
    if self.isAiOn {
      
      //NSLog("{\(ball?.position)")
      
      self.aiThinking(dt, ball: ball!)
      self.movePaddle(dt)
      
      
    } else {
      
      if isGameControllerRegistered {
        
        var dpadUp : Float = 0
        var dpadDown : Float = 0
        
        if (self.gameController!.microGamepad != nil) {
          dpadUp = self.gameController!.microGamepad!.dpad.up.value
          dpadDown = self.gameController!.microGamepad!.dpad.down.value
          //NSLog("microGamepad")
        } else if (self.gameController!.extendedGamepad != nil) {
          dpadUp = self.gameController!.extendedGamepad!.dpad.up.value
          dpadDown = self.gameController!.extendedGamepad!.dpad.down.value
          //NSLog("extendedGamepad")
        } else if (self.gameController!.gamepad != nil) {
          dpadUp = self.gameController!.gamepad!.dpad.up.value
          dpadDown = self.gameController!.gamepad!.dpad.down.value
          //NSLog("gamepad")
        }
        
        

        var currPos = self.position
        if dpadDown > 0.0 {
          currPos.y -= CGFloat( 10 * dpadDown)
        }
        if dpadUp > 0.0 {
          currPos.y += CGFloat( 10 * dpadUp)
        }
        if currPos.y > Const.PaddleMinMax.Max {
          currPos.y = Const.PaddleMinMax.Max
        } else if currPos.y < Const.PaddleMinMax.Min {
          currPos.y = Const.PaddleMinMax.Min
        }
        self.position = currPos

      }
      
      
      /*
      if self.yPosUpdate_cur != self.yPosUpdate_prev {
        var curPos = self.position
        curPos.y += CGFloat (self.yPosUpdateSign * 3)
        self.position = curPos
      }
      self.yPosUpdate_prev = self.yPosUpdate_cur
*/
    }
  }
  
}

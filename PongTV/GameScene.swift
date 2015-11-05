//
//  GameScene.swift
//  PongTV
//
//  Created by Normann Zsolt on 12/10/15.
//  Copyright (c) 2015 Zsolt Normann. All rights reserved.
//

import SpriteKit
import GameController


class GameScene: SKScene {
  var arena : Arena?
  var player1 : Paddle?
  var player2 : Paddle?
  var ball : Ball!
  let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
  
  override func didMoveToView(view: SKView) {
    self.name = Const.NodeName.MainScene
    
    let clickGestureRecognizer = UITapGestureRecognizer(target: self, action: "clickRecognized:")
    self.view?.addGestureRecognizer(clickGestureRecognizer)
    
    arena = Arena(size: self.frame.size)
    arena!.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame))
    self.addChild(arena!)
   // arena?.updateScores(1)
    
    player1 = Paddle(myID: .Index1 , sizeTV: self.size, isComputer: true)
    arena!.addPaddle(.Left, myPaddle: player1!)
    player2 = Paddle(myID: .Index2, sizeTV: self.size, isComputer: false)
    arena!.addPaddle(.Right, myPaddle: player2!)
    
    ball = Ball()
    ball.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame))
    self.addChild(ball)
    
    for pairedController in GCController.controllers() {
      playersControllerReg_Helper(pairedController)
    }
    self.registerForGameControllerNotifications()
    
  }
  
//  override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
//    let touch = touches.first
//    let prevLoc = touch!.previousLocationInView(self.view)
//    let curLoc = touch!.locationInView(self.view)
//    var dy = prevLoc.y - curLoc.y
//    
//    self.startGame()
//
//  }
//  
//  override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
//    if let touch = touches.first {
//      let prevLoc = touch.previousLocationInView(self.view)
//      let curLoc = touch.locationInView(self.view)
//      let dy = prevLoc.y - curLoc.y
//      NSLog("dy: \(dy)")
//      //userPaddle.moveByY(dy)
//    }
//  }
  
  override func update(currentTime: CFTimeInterval) {
    self.player1!.updatePlayer(currentTime, ball: self.ball)
    self.player2!.updatePlayer(currentTime, ball: self.ball)
    
    let whoLoses=ball.isOut()
    if whoLoses != -1 {
      changeGameState(Const.GameState.S4_FailNewBall)
      NSLog("\(whoLoses)")
      arena!.updateScores(whoLoses)
      resetBall()
    }
  }
  
  
  
  // gamecontroller stuff
  
  
  func registerForGameControllerNotifications() {
    GCController.startWirelessControllerDiscoveryWithCompletionHandler(nil)
    NSNotificationCenter.defaultCenter().addObserver(self, selector: "handleControllerDidConnectNotification:", name: GCControllerDidConnectNotification, object: nil)
    NSNotificationCenter.defaultCenter().addObserver(self, selector: "handleControllerDidDisconnectNotification:", name: GCControllerDidDisconnectNotification, object: nil)
  }
  
  deinit {
    GCController.stopWirelessControllerDiscovery()
    NSNotificationCenter.defaultCenter().removeObserver(self, name: GCControllerDidConnectNotification, object: nil)
    NSNotificationCenter.defaultCenter().removeObserver(self, name: GCControllerDidDisconnectNotification, object: nil)
  }
  
  
  func playersControllerReg_Helper(thisgamecontroller : GCController) {
    if !player1!.isGameControllerRegistered {
      player1!.registerController(thisgamecontroller)
    }
    if !player2!.isGameControllerRegistered {
      player2!.registerController(thisgamecontroller)
    }
  }
  
  func handleControllerDidConnectNotification(notification: NSNotification) {
    let connectedGameController = notification.object as! GCController
    connectedGameController.playerIndex = .IndexUnset
    NSLog("connectedGameController name \(connectedGameController.vendorName), \(connectedGameController.playerIndex.rawValue)")
    playersControllerReg_Helper(connectedGameController)
  }
  
  func handleControllerDidDisconnectNotification(notification: NSNotification) {
    let disconnectedGameController = notification.object as! GCController
    player1!.unregisterController(disconnectedGameController)
    player2!.unregisterController(disconnectedGameController)
    NSLog("DISconnectedGameController name \(disconnectedGameController.vendorName)")
  }
  
  
  
  
  // aux game funcs
  
  
  func startGame() {
    ball.physicsBody?.applyImpulse(CGVector(dx: 3, dy: 3.5))
  }
  
  func resetBall() {
    ball.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame))
    ball.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
    changeGameState(Const.GameState.S2_BeforeStart)
  }
  
  
  // game state dependent code
  
  
  func changeGameState(toState:Int) {
    appDelegate.g_prevgamestate = appDelegate.g_gamestate
    if appDelegate.g_gamestate==Const.GameState.S2_BeforeStart {
      startGame()
      appDelegate.g_gamestate = toState
      return
    }
    if appDelegate.g_gamestate==Const.GameState.S3_InGame {
      appDelegate.g_gamestate = toState
      return
    }
    if appDelegate.g_gamestate==Const.GameState.S4_FailNewBall {
      appDelegate.g_gamestate = toState
      return
    }

  }

  func clickRecognized(recognizer: UITapGestureRecognizer) {
    changeGameState(Const.GameState.S3_InGame)
  }


}

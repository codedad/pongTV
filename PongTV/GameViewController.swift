//
//  GameViewController.swift
//  PongTV
//
//  Created by Normann Zsolt on 12/10/15.
//  Copyright (c) 2015 Zsolt Normann. All rights reserved.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController {
    
  @IBOutlet weak var menuView: UIView!
  @IBOutlet weak var labelRounds: UILabel!
  @IBOutlet weak var buttonMenuStartGame: UIButton!

  @IBOutlet weak var pausedView: UIView!
  @IBOutlet weak var endView: UIView!
  @IBOutlet weak var buttonContinue: UIButton!
  @IBOutlet weak var labelWhoWon: UILabel!
  var scene : SKScene!

  let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate

    override func viewDidLoad() {
      super.viewDidLoad()
      
      scene = SKScene(fileNamed: "GameScene") as? GameScene
      
      if scene != nil {
        let skView = self.view as! SKView
        skView.showsFPS = true
        skView.showsNodeCount = true
        skView.ignoresSiblingOrder = true
        scene.scaleMode = .AspectFill
        skView.presentScene(scene)
        
        appDelegate.g_rounds = Const.RoundNo.IsLevel1
        appDelegate.g_gamestate = Const.GameState.S1_MenuOn
        
        registerGameNotifs()
        NSNotificationCenter.defaultCenter().postNotificationName(Const.Notifications.UpdateNames, object: nil)
      }
  }

  deinit {
    NSNotificationCenter.defaultCenter().removeObserver(self, name: Const.Notifications.EndGame, object: nil)
  }

  
  
  // MARK: various touch handlings
  
  
  @IBAction func buttonTouchedStartGame(sender: AnyObject) {
    menuView.hidden = true
    appDelegate.g_prevgamestate = appDelegate.g_gamestate
    appDelegate.g_gamestate = Const.GameState.S2_BeforeStart
    NSNotificationCenter.defaultCenter().postNotificationName(Const.Notifications.UpdateNames, object: nil)
  }
  
  @IBAction func buttonTouchedChgRounds(sender: AnyObject) {
    if appDelegate.g_rounds==Const.RoundNo.IsLevel1 {
      appDelegate.g_rounds=Const.RoundNo.IsLevel2
    } else if appDelegate.g_rounds==Const.RoundNo.IsLevel2 {
      appDelegate.g_rounds=Const.RoundNo.IsLevel3
    } else if appDelegate.g_rounds==Const.RoundNo.IsLevel3 {
      appDelegate.g_rounds=Const.RoundNo.IsLevel1
    }
    labelRounds.text="Rounds #: \(appDelegate.g_rounds!)"
//    myPreferredFocusedView = buttonMenuStartGame
//    setNeedsFocusUpdate()
//    updateFocusIfNeeded()

  }
  
  @IBAction func buttonTouchedContinue(sender: AnyObject) {
    pausedView.hidden = true
    appDelegate.g_gamestate = appDelegate.g_prevgamestate
    scene.paused = false
  }
  @IBAction func buttonPauseTouchedBackToMenu(sender: AnyObject) {
    pausedView.hidden = true
    showMenu()
    NSNotificationCenter.defaultCenter().postNotificationName(Const.Notifications.ResetGame, object: nil)
  }
  
  @IBAction func buttonTouchedRemacth(sender: AnyObject) {
    endView.hidden = true
    appDelegate.g_prevgamestate = appDelegate.g_gamestate
    appDelegate.g_gamestate = Const.GameState.S2_BeforeStart
  }

  @IBAction func buttonTouchedBackToMenu(sender: AnyObject) {
    menuView.hidden = false
    endView.hidden = true
    appDelegate.g_prevgamestate = appDelegate.g_gamestate
    appDelegate.g_gamestate = Const.GameState.S1_MenuOn
  }

  
  // MARK: aux game flow functions
  
  func pauseGame() {
    appDelegate.g_prevgamestate = appDelegate.g_gamestate
    appDelegate.g_gamestate = Const.GameState.Sx_Paused
    scene.paused = true
    pausedView.hidden = false
  }
  
  func showMenu() {
    appDelegate.g_prevgamestate = appDelegate.g_gamestate
    appDelegate.g_gamestate = Const.GameState.S1_MenuOn
    menuView.hidden = false
  }
  
  func registerGameNotifs() {
    NSNotificationCenter.defaultCenter().addObserver(self, selector: "handleEndGameNotification:", name: Const.Notifications.EndGame, object: nil)
  }
  
  func handleEndGameNotification(notification: NSNotification) {
    endView.hidden = true
  }

  
  // MARK: menu button handling
  
  override func pressesBegan(presses: Set<UIPress>, withEvent event: UIPressesEvent?) {
    if(presses.first?.type == UIPressType.Menu) {
      if appDelegate.g_gamestate == Const.GameState.S3_InGame || appDelegate.g_gamestate == Const.GameState.S4_FailNewBall ||
         appDelegate.g_gamestate == Const.GameState.S2_BeforeStart {
        pauseGame()
        return
      }
      if appDelegate.g_gamestate == Const.GameState.S5_GameEnded {
        showMenu()
        return
      }
      if appDelegate.g_gamestate == Const.GameState.S1_MenuOn || appDelegate.g_gamestate == Const.GameState.Sx_Paused {
        exit(0)
      }
    } else {
      super.pressesBegan(presses, withEvent: event)
    }
  }
  
//  var myPreferredFocusedView:UIView?
//  override var preferredFocusedView: UIView? {
//    return myPreferredFocusedView
//  }
  
}

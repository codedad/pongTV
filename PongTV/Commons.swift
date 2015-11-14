//
//  Commons.swift
//  PongTV
//
//  Created by Normann Zsolt on 12/10/15.
//  Copyright © 2015 Zsolt Normann. All rights reserved.
//

import SpriteKit

struct Const {
	struct NotificationKey {
		static let Welcome = "kWelcomeNotif"
	}
	
	struct Path {
		static let Documents = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
		static let Tmp = NSTemporaryDirectory()
	}


  struct PhysicsCategory {
    static let Wall : UInt32 = 0b1
    static let Ball : UInt32 = 0b10
    static let Paddle1 : UInt32 = 0b100
    static let Paddle2 : UInt32 = 0b100
  }
  
  struct ZPos {
    static let Background : CGFloat = 10
    static let Paddle : CGFloat = 20
    static let Ball : CGFloat = 30
  }
  
  struct NodeName {
    static let Score : String = "kscorenode"
    static let PlayerName : String = "knamenode"
    static let MainScene : String = "kmainscene"
  }

  struct BallSize {
    static let Length : CGFloat = 20
  }

  struct PaddleMinMax {
    static let Min : CGFloat = -230
    static let Max : CGFloat = 230
    static let MinExtended : CGFloat = -270
    static let MaxExtended : CGFloat = 270
  }

  struct RoundNo {
    static let IsLevel1 : Int = 15
    static let IsLevel2 : Int = 20
    static let IsLevel3 : Int = 30
  }

  struct GameState {
    static let S1_MenuOn : Int = 1
    static let S2_BeforeStart : Int = 2
    static let S3_InGame : Int = 3
    static let S4_FailNewBall : Int = 4
    static let S5_GameEnded : Int = 5
    static let Sx_Paused : Int = 7
  }
  
  struct Notifications {
    static let EndGame : String = "kendgamenotification"
    static let UpdateNames : String = "kupdatenamesnotification"
    static let ResetGame : String = "kresetgamenotification"
  }


  
  
  enum PaddleOrientation {
    case Left
    case Right
  }

}

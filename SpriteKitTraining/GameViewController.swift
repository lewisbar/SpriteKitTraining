//
//  GameViewController.swift
//  SpriteKitTraining
//
//  Created by Lennart Wisbar on 21.06.17.
//  Copyright © 2017 Lennart Wisbar. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let gameScene = GameScene(size: self.view.bounds.size)
        
        let skView = self.view as! SKView
        skView.presentScene(gameScene)
    }
}

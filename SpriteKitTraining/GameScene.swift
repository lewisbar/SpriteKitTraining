//
//  GameScene.swift
//  SpriteKitTraining
//
//  Created by Lennart Wisbar on 21.06.17.
//  Copyright © 2017 Lennart Wisbar. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    let ball = SKSpriteNode(imageNamed: "StarBall")
    let floor = SKSpriteNode(imageNamed: "Floor")
    var initialBallPosition: CGPoint!
    var initialBallSize: CGSize!
    
    override func didMove(to view: SKView) {
        
        initialBallPosition = CGPoint(x: ball.size.width, y: floor.size.height + ball.size.height / 2)
        initialBallSize = ball.size
        
        backgroundColor = .lightGray
        
        floor.anchorPoint = .zero
        floor.position = .zero
        floor.zPosition = 1
        self.addChild(floor)
        
        ball.position = initialBallPosition
        ball.zPosition = 2
        self.addChild(ball)
    }
    
    override func update(_ currentTime: TimeInterval) {
        ball.zRotation -= .pi * 5 / 180
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            ball.position = touch.location(in: floor)
            ball.size.width *= 2
            ball.size.height *= 2
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            ball.position = touch.location(in: floor)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let fingerPosition = touch.location(in: floor)
            self.ball.position = CGPoint(x: fingerPosition.x, y: self.initialBallPosition.y)
            self.ball.size = self.initialBallSize
        }
    }
}

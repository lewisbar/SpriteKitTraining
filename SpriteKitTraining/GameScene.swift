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
    let floor1 = SKSpriteNode(imageNamed: "Floor")
    let floor2 = SKSpriteNode(imageNamed: "Floor")
    var initialBallPosition: CGPoint!
    var initialBallSize: CGSize!
    
    override func didMove(to view: SKView) {
        initialBallPosition = CGPoint(x: ball.size.width, y: floor1.size.height + ball.size.height / 2)
        initialBallSize = ball.size
        
        backgroundColor = .lightGray
        
        floor1.anchorPoint = .zero
        floor1.position = .zero
        floor1.zPosition = 1
        floor1.size.width = self.size.width
        self.addChild(floor1)
        
        floor2.anchorPoint = .zero
        floor2.position = CGPoint(x: floor1.size.width, y: 0)
        floor2.zPosition = 1
        floor2.size.width = self.size.width
        self.addChild(floor2)
        
        ball.position = initialBallPosition
        ball.zPosition = 2
        self.addChild(ball)
    }
    
    override func update(_ currentTime: TimeInterval) {
        ball.zRotation -= .pi * 5 / 180
        
        floor1.position.x -= 4
        floor2.position.x -= 4
        
        if floor1.position.x < -floor1.size.width {
            floor1.position.x = floor2.position.x + floor2.size.width
        } else if floor2.position.x < -floor2.size.width {
            floor2.position.x = floor1.position.x + floor1.size.width
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            ball.position.x = touch.location(in: view).x
            ball.position.y = -touch.location(in: view).y + (view?.bounds.height)!
            ball.size.width *= 2
            ball.size.height *= 2
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            ball.position.x = touch.location(in: view).x
            ball.position.y = -touch.location(in: view).y + (view?.bounds.height)!
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let fingerPosition = touch.location(in: view)
            self.ball.position = CGPoint(x: fingerPosition.x, y: self.initialBallPosition.y)
            self.ball.size = self.initialBallSize
        }
    }
}

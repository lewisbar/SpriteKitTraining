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
        
        // Background
        backgroundColor = .lightGray
        
        // PhysicsWorld
        physicsWorld.gravity = CGVector(dx: 0, dy: -9.8)
        
        // Floor
        placeForEndLessScrolling(node1: floor1, node2: floor2)
        let floor1TopLeft = CGPoint(x: 0, y: floor1.size.height)
        let floor1TopRight = CGPoint(x: floor1.size.width, y: floor1.size.height)
        floor1.physicsBody = SKPhysicsBody(edgeFrom: floor1TopLeft, to: floor1TopRight)
        let floor2TopLeft = CGPoint(x: 0, y: floor2.size.height)
        let floor2TopRight = CGPoint(x: floor2.size.width, y: floor2.size.height)
        floor2.physicsBody = SKPhysicsBody(edgeFrom: floor2TopLeft, to: floor2TopRight)
        floor1.physicsBody?.isDynamic = false
        floor2.physicsBody?.isDynamic = false
        self.addChild(floor1)
        self.addChild(floor2)
        
        // Ball
        initialBallPosition = CGPoint(x: ball.size.width, y: floor1.size.height + ball.size.height / 2)
        initialBallSize = ball.size
        ball.position = initialBallPosition
        ball.zPosition = 2
        ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.size.width / 2)
        self.addChild(ball)
    }
    
    override func update(_ currentTime: TimeInterval) {
        ball.zRotation -= .pi * 5 / 180
        scrollLeftEndlessly(node1: floor1, node2: floor2, speed: 4)
    }
    
    // MARK: - Floor Scrolling
    func placeForEndLessScrolling(node1: SKSpriteNode, node2: SKSpriteNode) {
        node1.anchorPoint = .zero
        node1.position = .zero
        node1.zPosition = 1
        node1.size.width = self.size.width
        
        node2.anchorPoint = .zero
        node2.position = CGPoint(x: node1.size.width, y: 0)
        node2.zPosition = 1
        node2.size.width = self.size.width
    }
    
    func scrollLeftEndlessly(node1: SKSpriteNode, node2: SKSpriteNode, speed: CGFloat) {
        node1.position.x -= speed
        node2.position.x -= speed
        
        if node1.position.x < -node1.size.width {
            node1.position.x = node2.position.x + node2.size.width
        } else if node2.position.x < -node2.size.width {
            node2.position.x = node1.position.x + node1.size.width
        }
    }
    
    // MARK: - Ball Grabbing
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            ball.position = touch.location(in: self)
            ball.size.width *= 2
            ball.size.height *= 2
            ball.physicsBody?.isDynamic = false
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            ball.position = touch.location(in: self)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for _ in touches {
            //let fingerPosition = touch.location(in: self)
            //self.ball.position = CGPoint(x: fingerPosition.x, y: self.initialBallPosition.y)
            self.ball.size = self.initialBallSize
            ball.physicsBody?.isDynamic = true
        }
    }
}

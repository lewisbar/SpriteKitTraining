//
//  GameScene.swift
//  SpriteKitTraining
//
//  Created by Lennart Wisbar on 21.06.17.
//  Copyright © 2017 Lennart Wisbar. All rights reserved.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    let balls = [#imageLiteral(resourceName: "RedStarBall"), #imageLiteral(resourceName: "BlueStarBall"), #imageLiteral(resourceName: "GreenStarBall"), #imageLiteral(resourceName: "ClearStarBall"), #imageLiteral(resourceName: "PurpleStarBall"), #imageLiteral(resourceName: "LightBlueStarBall"), #imageLiteral(resourceName: "BlackStarBall"), #imageLiteral(resourceName: "OrangeStarBall"), #imageLiteral(resourceName: "YellowStarBall"), #imageLiteral(resourceName: "PinkStarBall"), #imageLiteral(resourceName: "GrayStarBall")]
    var ballIndex = 0
    let ball = SKSpriteNode(imageNamed: "RedStarBall")
    let ground1 = SKSpriteNode(imageNamed: "Floor")
    let ground2 = SKSpriteNode(imageNamed: "Floor")
    let dust = SKEmitterNode(fileNamed: "Dust.sks")!
    var initialBallPosition: CGPoint!
    var initialBallSize: CGSize!
    var ballCanFall = false
    var ballIsOnGround: Bool {
        return ball.position.y == initialBallPosition.y && ball.size == initialBallSize
    }
    
    override func didMove(to view: SKView) {
        
        // Background
        backgroundColor = .lightGray
        
        // PhysicsWorld
        physicsWorld.gravity = CGVector(dx: 0, dy: -9.8)
        physicsWorld.contactDelegate = self
        
        // Ground
        setupGround(ground1)
        setupGround(ground2)
        placeForEndLessScrolling(node1: ground1, node2: ground2)
        self.addChild(ground1)
        self.addChild(ground2)
        
        // Ball
        initialBallPosition = CGPoint(x: ball.size.width, y: ground1.size.height + ball.size.height / 2)
        initialBallSize = ball.size
        ball.position = initialBallPosition
        ball.zPosition = 2
        ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.size.width / 2)
        ball.physicsBody?.categoryBitMask = 0b1
        ball.physicsBody?.contactTestBitMask = 0b10 // Ground
        self.addChild(ball)
        
        // Dust
        dust.run(.fadeOut(withDuration: 0))
        self.addChild(dust)
    }
    
    override func update(_ currentTime: TimeInterval) {
        ball.zRotation -= .pi * 5 / 180
        scrollLeftEndlessly(node1: ground1, node2: ground2, speed: 4)
//        if ballCanFall, ballIsOnGround {
//            dust?.position = ball.position
//            dust?.zPosition = 1
//            self.addChild(dust!)
//            ballCanFall = false
//        } else if ballIsOnGround {
//            dust?.removeFromParent()
//        } else {
//            ballCanFall = true
//        }
    }
    
    // MARK: - ground Setup
    func setupGround(_ ground: SKSpriteNode) {
        let topLeft = CGPoint(x: 0, y: ground.size.height)
        let topRight = CGPoint(x: ground.size.width, y: ground.size.height)
        ground.physicsBody = SKPhysicsBody(edgeFrom: topLeft, to: topRight)
        ground.physicsBody?.isDynamic = false
        ground.physicsBody?.categoryBitMask = 0b10
        ground.physicsBody?.contactTestBitMask = 0b1 // Ball
        ground.zPosition = 1
    }
    
    func placeForEndLessScrolling(node1: SKSpriteNode, node2: SKSpriteNode) {
        node1.anchorPoint = .zero
        node1.position = .zero
        node1.size.width = self.size.width
        
        node2.anchorPoint = .zero
        node2.position = CGPoint(x: node1.size.width, y: 0)
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
            self.ball.size = self.initialBallSize
            ball.physicsBody?.isDynamic = true
            
            // Move ball to top and change its color when released underground
            if ball.position.y < ground1.size.height {
                ball.position.y = self.size.height
                nextBall()
            }
            
            if !ballIsOnGround {
                ballCanFall = true
            }
        }
    }
    
    func nextBall() {
        ballIndex = (ballIndex < balls.count - 1) ? (ballIndex + 1) : 0
        ball.texture = SKTexture(image: balls[ballIndex])
    }
    
    // Contact
    func didBegin(_ contact: SKPhysicsContact) {
        guard ballCanFall else { return }
        dust.position = CGPoint(x: ball.position.x, y: ground1.size.height)
        dust.zPosition = 1
        dust.run(.fadeIn(withDuration: 0))
        dust.run(.fadeOut(withDuration: 0.5))
        ballCanFall = false
    }
}

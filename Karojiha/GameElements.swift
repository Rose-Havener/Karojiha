//
//  GameElements.swift
//  Karojiha
//
//  Created by Jina Park on 10/11/17.
//  Copyright © 2017 Macalester College. All rights reserved.
//

import SpriteKit

extension GameScene{
    
    //Create the bird
    func createBird() -> SKSpriteNode {
        
        //Set the size and position of the bird
        let bird = SKSpriteNode(texture: SKTextureAtlas(named:"player").textureNamed("bird_1"))
        
        playerBody.mass = 0.4
        playerBody.categoryBitMask = PhysicsCategory.Player
        playerBody.collisionBitMask = 4
        
        bird.size = CGSize(width: 150, height: 110)
        bird.position = CGPoint(x: self.frame.midX, y: ledge.position.y + 15)
        bird.zPosition = 10
        bird.name = birdName
        
        //Define the bird to be a SKPhysicsBody object.
        bird.physicsBody = SKPhysicsBody(circleOfRadius: bird.size.width / 2)
        bird.physicsBody?.linearDamping = 1.1
        bird.physicsBody?.restitution = 0
        bird.physicsBody?.contactTestBitMask = PhysicsCategory.Fly
        bird.physicsBody?.contactTestBitMask = PhysicsCategory.Bee
        bird.physicsBody?.usesPreciseCollisionDetection = true
        bird.physicsBody = playerBody
        bird.physicsBody?.affectedByGravity = true
        bird.physicsBody?.isDynamic = true
        bird.physicsBody?.allowsRotation = false

        //makes bird flap its wings when tap occurrs
        let birdSprites = (1...4).map { n in birdAtlas.textureNamed("bird_\(n)") }
        let animatebird = SKAction.animate(with: birdSprites, timePerFrame: 0.1)
        flappingAction = SKAction.repeat(animatebird, count: 2)

        
        return bird
    }
    
    //Function that adds worms to screen
    func createFly() {
        
        let fly = SKSpriteNode(imageNamed: "dragonfly.png")
        
        // Determine where to spawn the worm along the Y axis
        let actualY = bird.position.y + size.height/2
        fly.position = CGPoint(x: random(min:10, max: size.width - 10), y: actualY)
        
        fly.physicsBody = SKPhysicsBody(rectangleOf: fly.size)
        fly.physicsBody?.isDynamic = false
        fly.physicsBody?.affectedByGravity = false
        fly.physicsBody?.allowsRotation = false
        fly.physicsBody?.categoryBitMask = PhysicsCategory.Fly
        fly.physicsBody?.collisionBitMask = PhysicsCategory.Fly
        fly.physicsBody?.contactTestBitMask = PhysicsCategory.Player
        fly.physicsBody?.velocity = CGVector(dx: random(min: -100, max: 100), dy: random(min: -50, max: -100))
        
        self.addChild(fly)
    }
    
    
    func createBee() {
        
        let bee = SKSpriteNode(imageNamed: "bee.png")
        let actualY = bird.position.y + size.height/2
        
        bee.size = CGSize(width: 30, height: 30)
        bee.position = CGPoint(x: random(min:10, max: size.width - 10), y: actualY)
        
        bee.physicsBody = SKPhysicsBody(rectangleOf: bee.size)
        bee.physicsBody?.isDynamic = false
        bee.physicsBody?.affectedByGravity = false
        bee.physicsBody?.allowsRotation = false
        bee.physicsBody?.categoryBitMask = PhysicsCategory.Bee
        bee.physicsBody?.collisionBitMask = PhysicsCategory.Bee
        bee.physicsBody?.contactTestBitMask = PhysicsCategory.Player
        bee.physicsBody?.velocity = CGVector(dx: random(min: -250, max: 250), dy: random(min: -100, max: -400))
        
        self.addChild(bee)
    }
    
    
    //Set up click counter in upper right corner
    func createElevationLabel(){
        elevationLabel.horizontalAlignmentMode = .right
        elevationLabel.position = CGPoint(x: size.width/2.35, y: size.height/2.25)
        elevationLabel.fontColor = .orange
        elevationLabel.fontSize = 20
        elevationLabel.fontName = "Avenir-BlackOblique"
        elevationLabel.text = String(describing:
            Int((bird.position.y) - (ledge.position.y + 10))) + String(" ft")
        cameraNode.addChild(elevationLabel)
    }
    
    //Creates the sound button button
    func createSoundBtn() {
        soundBtn = SKSpriteNode(imageNamed: "soundButtonSmallSquare")
        soundBtn.size = CGSize(width: 50, height: 50)
        soundBtn.position = CGPoint(x: -size.width/2.5, y: size.height/3.50)
        soundBtn.zPosition = 6
        soundBtn.setScale(0)
        cameraNode.addChild(soundBtn)
        soundBtn.run(SKAction.scale(to: 1.0, duration: 0.0))
    }
    
    //Creates the pause button
    func createPauseBtn() {
        pauseBtn = SKSpriteNode(imageNamed: "pauseButtonSmallSquare")
        pauseBtn.size = CGSize(width: 50, height: 50)
        pauseBtn.position = CGPoint(x: -size.width/2.5, y: size.height/2.75)
        pauseBtn.zPosition = 6
        pauseBtn.setScale(0)
        cameraNode.addChild(pauseBtn)
        pauseBtn.run(SKAction.scale(to: 1.0, duration: 0.0))
    }

    //Creates the restart button
    func createHomeBtn() {
        homeBtn = SKSpriteNode(imageNamed: "homeButtonSmallSquare")
        homeBtn.size = CGSize(width: 50, height: 50)
        homeBtn.position = CGPoint(x: -size.width/2.5 , y: size.height/2.25)
        homeBtn.zPosition = 6
        homeBtn.setScale(0)
        cameraNode.addChild(homeBtn)
        homeBtn.run(SKAction.scale(to: 1.0, duration: 0.0))
    }
}



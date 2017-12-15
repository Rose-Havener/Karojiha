//
//  InstructionsScene.swift
//  Karojiha
//
//  Created by Hannah Gray  on 11/25/17.
//  Copyright © 2017 Macalester College. All rights reserved.
//

import Foundation
import SpriteKit
import UIKit

class InstructionsScene: SKScene, SKPhysicsContactDelegate{
    let titleLabel = SKLabelNode(fontNamed: "AvenirNextCondensed-DemiBold")
    let stepsLabel = SKLabelNode(fontNamed: "Avenir-Light")
    let instructions = SKSpriteNode(imageNamed: "instructions")
    
    var sound: Bool = true
    
    //Sound effects and music taken from freesfx.co.uk
    let backgroundSound = SKAudioNode(fileNamed: "opening_day.mp3")
    let buttonPressSound = SKAction.playSoundFileNamed("single_bubbleEDIT.wav", waitForCompletion: true)
    
    let birdAtlas = SKTextureAtlas(named:"player")
    var birdSprites = Array<SKTexture>()
    var bird = SKSpriteNode()
    var repeatActionbird = SKAction()
    let buttons = Buttons()


    override init(size: CGSize){
        super.init(size: size)
        buttons.scene = self
        
        
        //Changed background to be black
        backgroundColor = SKColor.black

        
        //Adds and loops the background sound
        self.addChild(backgroundSound)
        backgroundSound.autoplayLooped = true

        buttons.addHomeButton(position: CGPoint(x: size.width/10, y: size.height/1.05))
        buttons.addSoundButton(position: CGPoint(x: size.width/3.8, y: size.height/1.05))


        //Sets up 'How to Play' Label
        let titleLabel = SKLabelNode(fontNamed: "AvenirNextCondensed-DemiBold")
        titleLabel.text = "How to Play"
        titleLabel.fontSize = 50
        titleLabel.fontColor = SKColor.yellow
        titleLabel.position = CGPoint(x: size.width/2, y: size.height/1.3)
        addChild(titleLabel)
    
        //Sets up instructions button
        instructions.size = CGSize(width: size.width/1.05, height: 200)
        instructions.position = CGPoint(x: size.width/2, y: size.height/1.8)
        addChild(instructions)

        
        //Add bird and flapping animation
        let bird = SKSpriteNode(texture: SKTextureAtlas(named:"player").textureNamed("birdHelmet_1"))
        bird.size = CGSize(width: 200, height: 150)
        bird.position = CGPoint(x:self.frame.midX, y:self.frame.midY/2.5)
        bird.zPosition = 10
        addChild(bird)
        
        birdSprites.append(birdAtlas.textureNamed("birdHelmet_1"))
        birdSprites.append(birdAtlas.textureNamed("birdHelmet_2"))
        birdSprites.append(birdAtlas.textureNamed("birdHelmet_3"))
        birdSprites.append(birdAtlas.textureNamed("birdHelmet_4"))
        
        let animatebird = SKAction.animate(with: birdSprites, timePerFrame: 0.3)
        repeatActionbird = SKAction.repeatForever(animatebird)
        bird.run(repeatActionbird)
    }
    
    // Return to the home page if the home button is pressed
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches{
            let location = touch.location(in: self)
            if buttons.homeBtn.contains(location) {
                run(buttonPressSound)
                let reveal = SKTransition.fade(withDuration: 0.5)
                let scene = MenuScene(size: size)
                self.view?.presentScene(scene, transition: reveal)
            } else if buttons.soundBtn.contains(location) {
                if sound {
                    buttons.soundBtn.texture = SKTexture(imageNamed: "soundOffButtonSmallSquare")
                    sound = false
                    backgroundSound.run(SKAction.stop())
                } else {
                    buttons.soundBtn.texture = SKTexture(imageNamed: "soundButtonSmallSquare")
                    sound = true
                    backgroundSound.run(SKAction.play())
                }
            }
        }
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//
//  Background.swift
//  Karojiha
//
//  Created by Kai Heen on 11/27/17.
//  Copyright © 2017 Macalester College. All rights reserved.
//

import Foundation
import SpriteKit

class Background {

    var size = CGSize.zero
    weak var scene: SKScene? {
        didSet {
            self.size = scene?.size ?? CGSize.zero
        }
    }

    var backgroundImages: [SKNode] = []
    let backgroundHeight = CGFloat(8.0)
    var currentBackground: CGFloat = 1.0
    var previousBackground: CGFloat = 0.0
    var bgFlavorCheckpoint = CGFloat(0.0)
    let flavorFrequency = CGFloat(500.0)
    
    let backgroundNames = ["background1","background2","background3","background4","blackBackground"]
    
    //For example, images of comets and planets are added to the 5th background --> "blackBackground"
    var bgFlavorImages  = [
        1: ["background1Cloud"],
        2: ["lightning"],
        3: ["blueClouds"],
        4: ["purplePlanet"],
        5: ["comet", "planet"]
    ]

    //This function creates SKSpriteNode Objects for all background images, and adds them to backgroundImages
    func initBackgroundArray(names: [String]){
        var x: CGFloat = 0.0
        for bgName in names {
            let backgroundImage = SKSpriteNode(imageNamed: bgName)
            backgroundImage.xScale = size.width/backgroundImage.size.width
            backgroundImage.yScale = size.height/backgroundImage.size.height*backgroundHeight
            backgroundImage.anchorPoint = CGPoint(x: 0.5, y: 0.0)
            backgroundImage.position = CGPoint(x: size.width/2, y: backgroundImage.size.height*x)
            backgroundImage.zPosition = -5
            backgroundImages.append(backgroundImage)
            x += 1
        }
        
        let mountainImage = SKSpriteNode(imageNamed: "mountains_700")
        mountainImage.size = CGSize(width: size.width, height: size.height/1.05)
        mountainImage.position = CGPoint(x: size.width/2, y: size.height/3)
        mountainImage.zPosition = 1
        
        scene?.addChild(backgroundImages[0])
        scene?.addChild(mountainImage)

    }
    
    
    /*
     Removes the previous background when the bird is far enough above it.
     Repeats the last stars background in the end.
    */
    func adjust(forBirdPosition position: CGPoint){
        
        //Adds the next background when the bird is close enough
        if (position.y > backgroundHeight * size.height * currentBackground - size.height){
            
            //Check if at end of BackgroundImages array, if so, re-add last Image
            if currentBackground >= CGFloat(backgroundImages.count) {
                let backgroundImage = SKSpriteNode(imageNamed: backgroundNames.last!)
                backgroundImage.xScale = size.width / backgroundImage.size.width
                backgroundImage.yScale = size.height / backgroundImage.size.height * backgroundHeight
                backgroundImage.anchorPoint = CGPoint(x: 0.5, y: 0.0)
                backgroundImage.position = CGPoint(x: size.width/2, y: backgroundImage.size.height * currentBackground)
                backgroundImage.zPosition = -2
                backgroundImages.append(backgroundImage)
            }
            scene?.addChild(backgroundImages[Int(currentBackground)])
            currentBackground += 1
        }
        
        if (position.y > backgroundHeight * size.height * (previousBackground + 1) + size.height){
            (backgroundImages[Int(previousBackground)]).removeFromParent()
            previousBackground += 1
        }
    }
    
    
    //Adds images to the background, choosing randomly from the correct array in bgFlavorImages
    func addBackgroundFlavor(forBirdPosition position: CGPoint){
        if position.y > flavorFrequency + bgFlavorCheckpoint {
            bgFlavorCheckpoint = position.y
            
            var choicesForImage = [String]()
            if currentBackground <= 4 {
                choicesForImage = bgFlavorImages[Int(currentBackground)]! }
            else {
                choicesForImage = bgFlavorImages[5]! }
            
            if choicesForImage.count > 0 {
                let randomIndex = random(min: 0, max: CGFloat((choicesForImage.endIndex)))
                let chosenImage = choicesForImage[Int(randomIndex)]
                createFlavorSprite(imageName: chosenImage, forBirdPosition: position)
            }
        }
    }
    
    
    //Helper function called in addBackgroundFlavor()
    func createFlavorSprite(imageName: String, forBirdPosition position: CGPoint){
        let flavorSprite = SKSpriteNode(imageNamed: imageName)
        scene?.addChild(flavorSprite)
        flavorSprite.size.width = flavorSprite.size.width/2
        flavorSprite.size.height = flavorSprite.size.height/2
        flavorSprite.position.y = position.y + size.height
        flavorSprite.position.x = random(min: 0, max: size.width)
        flavorSprite.zPosition = 3
        let moveAction = SKAction.moveBy(x:0, y: -1100, duration: 5.1)
        let deleteAction = SKAction.removeFromParent()
        let flavorAction = SKAction.sequence([moveAction, deleteAction])
        flavorSprite.run(flavorAction)
    }
    
    
    /*
        Implements the parallax background.
        Code altered from https://www.hackingwithswift.com/read/36/3/sky-background-and-ground-parallax-scrolling-with-spritekit.
    */
    func createParallax() {
        let backgroundTexture = SKTexture(imageNamed: "parallax_white")
        
        for i in 0 ... 50 {
            let background = SKSpriteNode(texture: backgroundTexture)
            background.zPosition = -1.5
            background.anchorPoint = CGPoint.zero
            background.xScale = size.width / background.size.width
            background.yScale = size.height / background.size.height * backgroundHeight
            background.position = CGPoint(x: 0, y: (backgroundTexture.size().height * CGFloat(i) - CGFloat(1 * i)))
            scene?.addChild(background)
            
            let moveUp = SKAction.moveBy(x: 0, y: -backgroundTexture.size().height, duration: 10)
            let moveReset = SKAction.moveBy(x: 0, y: backgroundTexture.size().height, duration: 0)
            let moveLoop = SKAction.sequence([moveUp, moveReset])
            let moveForever = SKAction.repeatForever(moveLoop)
            
            background.run(moveForever)
        }
    }
}

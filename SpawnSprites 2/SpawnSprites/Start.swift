//
//  Start.swift
//  SpawnSprites
//
//  Created by Varshith on 8/17/18.
//  Copyright © Varshith. All rights reserved.
//

import SpriteKit
import GameplayKit

var start: SKLabelNode!

class Start: SKScene {
    override func didMove(to view: SKView) {
        start = self.childNode(withName: "start") as! SKLabelNode
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch in touches {
            
            let points = touch.location(in: self)
            
            if start.contains(points) {
                let gameScene = GameScene(fileNamed: "GameScene")
                gameScene?.scaleMode = .aspectFill
                self.view?.presentScene(gameScene!)
            }
        }
    }
}

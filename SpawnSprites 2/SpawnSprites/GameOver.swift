//
//  GameOver.swift
//  SpawnSprites
//
//  Created by Varshith on 7/26/18.
//  Copyright © Varshith. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameOver: SKScene {
    var score: Int = 0
    var gameOverLabel: SKLabelNode!
    var finalScore: SKLabelNode!
    var restart: SKLabelNode!
    
    override func didMove(to view: SKView) {
        gameOverLabel = self.childNode(withName: "gameOverLabel") as! SKLabelNode
        finalScore = self.childNode(withName: "finalScore") as! SKLabelNode
        restart = self.childNode(withName: "restart") as! SKLabelNode
        
        finalScore.text = "Final Score: \(score)"
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let points = touch.location(in: self)
            if restart.contains(points) {
                let gameScene = GameScene(fileNamed: "GameScene")
                gameScene?.scaleMode = .aspectFill
                self.view?.presentScene(gameScene!)
            }
        }
    }
}

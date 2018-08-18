//
//  GameScene.swift
//  SpawnSprites
//
//  Created by Varshith on 6/23/18.
//  Copyright © Varshith. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene , SKPhysicsContactDelegate {
    
    var enemy: SKSpriteNode!
    var player: SKSpriteNode!
    var laser: SKSpriteNode!
    var score: SKLabelNode!
    var timer: Timer!
    var gameOver = false
    
    override func didMove(to view: SKView) {
        enemy = self.childNode(withName: "enemy") as! SKSpriteNode
        player = self.childNode(withName: "player") as! SKSpriteNode
        player.position = CGPoint(x: 0, y: -self.frame.height/2 + 50)
        laser = self.childNode(withName: "laser") as! SKSpriteNode
        score = self.childNode(withName: "score") as! SKLabelNode
        
        self.physicsWorld.contactDelegate = self
        
        move(enemy: enemy)
        
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { (_) in
            self.spawnEnemy()
        }
    }
    
    
     override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
     let point = touches.first?.location(in: self)
     let newPoint = CGPoint(x: (point?.x)! , y: -self.frame.height/2 + 50)
     player.position = newPoint
     player.position = newPoint
     
        if gameOver ==  false {
            spawnLaser()
        }
     }
    
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch in touches {
            let point = touch.location(in: self)
            player.position = CGPoint(x: point.x, y: -self.frame.height/2 + 50.0)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        //spawnLaser()
    }
    
    func move(enemy: SKSpriteNode) {
        let move = SKAction.moveBy(x: 0, y: -self.frame.height, duration: 3.7)
        enemy.run(move)
    }
    
    func spawnEnemy() {
        
        let random = GKRandomDistribution(lowestValue: Int(-self.frame.width/2), highestValue: Int(self.frame.width/2))
        
        let newEnemy = enemy.copy() as! SKSpriteNode
        newEnemy.position = CGPoint(x: random.nextInt(), y: Int(self.frame.height/2))
        move(enemy: newEnemy)
        self.addChild(newEnemy)
    }
    
    func spawnLaser() {
        playSound(node: laser)
        
        let newLaser = laser.copy() as! SKSpriteNode
        newLaser.position = player.position
        moveLaser(newLaser)
        self.addChild(newLaser)
    }
    
    func moveLaser(_ laser: SKSpriteNode) {
        let move = SKAction.moveBy(x: player.position.x, y: self.frame.height, duration: 0.25)
        laser.run(move)
    }
    
    var count = 0
    
    func sound(node: SKNode) {
        let sound = SKAction.playSoundFileNamed("Explosion", waitForCompletion: true)
        self.run(sound)
        print("sound \(sound)")
    }
    
    var contactInProgress = false
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        var nameA = ""
        var nameB = ""
        
        if let node = contact.bodyA.node {
            nameA = node.name!
        }
        
        if let node = contact.bodyB.node {
            nameB = node.name!
        }
        
        if contact.bodyA.node?.parent != nil && contact.bodyB.node?.parent != nil {
        
        if (nameA == "laser" && nameB == "enemy") || (nameA == "enemy" && nameB == "laser") {
            contact.bodyA.node?.removeFromParent()
            contact.bodyB.node?.removeFromParent()
            sound(node: contact.bodyA.node!)
            
            // show the explosion
            showExplosion(node: contact.bodyA.node!)
            count += 1
            score.text = "\(count)"
            }
        
        print("Contact between \(nameA) , \(nameB)")
        }
        
        if (nameA == "player" && nameB == "enemy") || (nameA == "enemy" && nameB == "player") {
            contact.bodyA.node?.removeFromParent()
            contact.bodyB.node?.removeFromParent()
            sound(node: contact.bodyA.node!)
            
            // show the explosion
            showExplosion(node: contact.bodyA.node!)
            
            timer.invalidate()
            
            gameOver = true
            
            gameOverScene()
        }
    }
    
    func gameOverScene() {
        let videoGameOver = GameOver(fileNamed: "GameOver")
        videoGameOver?.size = self.size
        videoGameOver?.scaleMode = .aspectFill
        videoGameOver?.score = count
        let transition = SKTransition.fade(withDuration: 1.0)
        self.view?.presentScene(videoGameOver! , transition: transition)
    }
    
    func showExplosion(node: SKNode ) {
        let emittorNode = SKEmitterNode(fileNamed: "Explosion")
        emittorNode?.position = node.position
        self.addChild(emittorNode!)
    }
    
    func playSound(node: SKNode) {
        let sound = SKAction.playSoundFileNamed("Pew", waitForCompletion: true)
        self.run(sound)
        print("sound \(sound)")
    }
    
    func didEnd(_ contact: SKPhysicsContact) {
        
    }
    
    override func update(_ currentTime: TimeInterval){
        enumerateChildNodes(withName: "laser") { (node, block) in
            if node.position.y > self.frame.maxY {
                node.removeFromParent()
            }
        }
        
        enumerateChildNodes(withName: "enemy") { (node, block) in
            if node.position.y < self.frame.minY {
                node.removeFromParent()
            }
        }
    }
}

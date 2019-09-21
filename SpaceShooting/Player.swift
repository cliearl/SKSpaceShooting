//
//  Player.swift
//  SpaceShooting
//
//  Created by Kyunghun Jung on 20/08/2019.
//  Copyright © 2019 qualitybits.net. All rights reserved.
//

import SpriteKit

class Player: SKSpriteNode {
    
    var screenSize: CGSize!
    
    init(screenSize: CGSize) {
        self.screenSize = screenSize
        let playerTexture = Atlas.gameobjects.textureNamed("player")
        super.init(texture: playerTexture, color: SKColor.clear, size: playerTexture.size())
        self.zPosition = Layer.player
        
        // 물리바디 설정
        self.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: self.size.width / 3, height: self.size.height / 3), center: CGPoint(x: 0, y: 0))
        self.physicsBody?.categoryBitMask = PhysicsCategory.player
        self.physicsBody?.contactTestBitMask = PhysicsCategory.enemy | PhysicsCategory.meteor | PhysicsCategory.bossMissile | PhysicsCategory.item
        self.physicsBody?.collisionBitMask = 0
        
        // 스러스터 붙이기
        guard let thruster = SKEmitterNode(fileNamed: Particle.playerThruster) else { return }
        thruster.position.y -= self.size.height / 2
        thruster.zPosition = Layer.sub
        // EmitterNode를 그대로 붙이면 흰색 배경일때 효과가 보이지 않음
//        self.addChild(thruster)
        
        // 알파블렌딩 문제 해결
        let thrusterEffectNode = SKEffectNode()
        thrusterEffectNode.addChild(thruster)
        self.addChild(thrusterEffectNode)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // 실드 작성
    func createShield() -> SKSpriteNode {
        let texture = Atlas.gameobjects.textureNamed("playerShield")
        let shield = SKSpriteNode(texture: texture)
        shield.position = CGPoint(x: 0, y: 0)
        shield.zPosition = Layer.upper
        shield.physicsBody = SKPhysicsBody(circleOfRadius: shield.size.height / 2)
        shield.physicsBody?.categoryBitMask = PhysicsCategory.shield
        shield.physicsBody?.contactTestBitMask = PhysicsCategory.enemy | PhysicsCategory.meteor | PhysicsCategory.bossMissile
        shield.physicsBody?.collisionBitMask = 0
        
        // 깜박임 효과
        let fadeOutAndIn = SKAction.sequence([
            SKAction.fadeAlpha(to: 0.2, duration: 1.0),
            SKAction.fadeAlpha(to: 1.0, duration: 1.0)
            ])
        shield.run(SKAction.repeatForever(fadeOutAndIn))
        
        return shield
    }
    
    // 미사일 작성
    func createMissile() -> SKSpriteNode {
        let texture = Atlas.gameobjects.textureNamed("playerMissile")
        let missile = SKSpriteNode(texture: texture)
        missile.position = self.position
        missile.position.y += self.size.height
        missile.zPosition = Layer.playermissile
        
        // 물리바디 부여
        missile.physicsBody = SKPhysicsBody(rectangleOf: missile.size)
        missile.physicsBody?.categoryBitMask = PhysicsCategory.missile
        missile.physicsBody?.contactTestBitMask = PhysicsCategory.enemy | PhysicsCategory.meteor | PhysicsCategory.boss
        missile.physicsBody?.collisionBitMask = 0
        missile.physicsBody?.usesPreciseCollisionDetection = true
        
        return missile
    }
    
    // 미사일 발사
    func fireMissile(missile: SKSpriteNode) {
        var actionArray = [SKAction]()
        actionArray.append(SKAction.moveTo(y: self.screenSize.height + missile.size.height, duration: 0.4))
        actionArray.append(SKAction.removeFromParent())
        
        missile.run(SKAction.sequence(actionArray))
    }
}

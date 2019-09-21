//
//  MenuScene.swift
//  SpaceShooting
//
//  Created by Kyunghun Jung on 09/09/2019.
//  Copyright © 2019 qualitybits.net. All rights reserved.
//

import SpriteKit

class MenuScene: SKScene {
    
    override func didMove(to view: SKView) {
        let bgmPlayer = SKAudioNode(fileNamed: BGM.title)
        bgmPlayer.autoplayLooped = true
        self.addChild(bgmPlayer)
        
        guard let starfield = SKEmitterNode(fileNamed: Particle.starfield) else { return }
        starfield.position = CGPoint(x: size.width / 2, y: size.height)
        starfield.zPosition = Layer.starfield
        starfield.advanceSimulationTime(30)
        self.addChild(starfield)
        
        let titleLabel = SKLabelNode(text: "Space Shooting")
        titleLabel.fontName = "Minercraftory"
        titleLabel.fontSize = 30
        titleLabel.position = CGPoint(x: size.width / 2, y: size.height / 1.3)
        titleLabel.zPosition = Layer.hud
        self.addChild(titleLabel)
        
        let highscore = UserDefaults.standard.integer(forKey: "highScore")
        let highscoreLabel = SKLabelNode(text: String(format: "High score: %d", highscore))
        highscoreLabel.fontName = "Minercraftory"
        highscoreLabel.fontSize = 20
        highscoreLabel.position = CGPoint(x: size.width / 2, y: size.height / 2)
        highscoreLabel.zPosition = Layer.hud
        self.addChild(highscoreLabel)
        
        let playBtn = SKSpriteNode(imageNamed: "playBtn")
        playBtn.name = "playBtn"
        playBtn.position = CGPoint(x: size.width / 2, y: size.height / 4)
        playBtn.zPosition = Layer.hud
        self.addChild(playBtn)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        if let location = touch?.location(in: self) {
            let nodesArray = self.nodes(at: location)
            if nodesArray.first?.name == "playBtn" {
                let transition = SKTransition.doorsOpenHorizontal(withDuration: 0.5)
                let gamescene = GameScene(size: self.size)
                gamescene.scaleMode = .aspectFit
                self.view?.presentScene(gamescene, transition: transition)
            }
        }
    }
}

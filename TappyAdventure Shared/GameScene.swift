//
//  TappyAdventure
//
//  Copyright © 2018 DevFountain LLC. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {

    let player = SKSpriteNode(imageNamed: "Plane1")

    var timer: Timer?

    let scoreLabel = SKLabelNode(fontNamed: "KenVector-Future-Thin")

    var score = 0 {
        didSet {
            scoreLabel.text = "SCORE: \(score)"
        }
    }

    let music = SKAudioNode(fileNamed: "salty-ditty.mp3")
    /*
     "Salty Ditty" Kevin MacLeod (incompetech.com)
     Licensed under Creative Commons: By Attribution 3.0 License
     http://creativecommons.org/licenses/by/3.0/
     */

    class func newGameScene() -> GameScene {
        let scene = GameScene(size: CGSize(width: 1366, height: 1024))
        scene.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        scene.scaleMode = .aspectFill
        return scene
    }

    override func didMove(to view: SKView) {
        physicsWorld.contactDelegate = self
        physicsWorld.gravity = .zero

        isUserInteractionEnabled = false

        player.position = CGPoint(x: -400, y: 200)
        addChild(player)

        player.physicsBody = SKPhysicsBody(texture: player.texture!, size: player.texture!.size())
        player.physicsBody?.categoryBitMask = 1
        player.physicsBody?.collisionBitMask = 0

        let textures = [SKTexture(imageNamed: "Plane1"), SKTexture(imageNamed: "Plane2"), SKTexture(imageNamed: "Plane3")]
        let animate = SKAction.animate(with: textures, timePerFrame: 0.5 / TimeInterval(textures.count))
        let forever = SKAction.repeatForever(animate)
        player.run(forever)

        parallaxScroll(image: "Sky", y: 0, z: -100, duration: 10, needsPhysics: false)

        #if os(iOS) || os(tvOS)
            let y = fromBottom(61)
        #elseif os(macOS)
            let y: CGFloat = -451
        #endif
        parallaxScroll(image: "Ground", y: y, z: -50, duration: 6, needsPhysics: true)

        timer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(self.createObstacle), userInfo: nil, repeats: true)

        scoreLabel.fontColor = Color.black.withAlphaComponent(0.5)
        scoreLabel.fontSize = 64
        #if os(iOS) || os(tvOS)
            scoreLabel.position.y = fromTop(10)
        #elseif os(macOS)
            scoreLabel.position.y = 482
        #endif
        scoreLabel.zPosition = 50
        scoreLabel.verticalAlignmentMode = .top
        addChild(scoreLabel)

        score = 0

        let getReady = SKSpriteNode(imageNamed: "GetReady")
        addChild(getReady)

        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.physicsWorld.gravity = CGVector(dx: 0, dy: -5)

            self.isUserInteractionEnabled = true

            self.addChild(self.music)

            getReady.removeFromParent()
        }
    }

    override func update(_ currentTime: TimeInterval) {
        let value = player.physicsBody!.velocity.dy * 0.001
        let rotate = SKAction.rotate(toAngle: value, duration: 0.1)
        player.run(rotate)

        #if os(iOS) || os(tvOS)
            let maxY = fromTop(30)
        #elseif os(macOS)
            let maxY: CGFloat = 482
        #endif
        if player.position.y > maxY {
            player.position.y = maxY
        }
    }

    func parallaxScroll(image: String, y: CGFloat, z: CGFloat, duration: Double, needsPhysics: Bool) {
        for i in 0 ... 1 {
            let node = SKSpriteNode(imageNamed: image)
            node.position = CGPoint(x: (size.width - 1) * CGFloat(i), y: y)
            node.zPosition = z
            addChild(node)

            if needsPhysics {
                node.name = "obstacle"
                node.physicsBody = SKPhysicsBody(texture: node.texture!, size: node.texture!.size())
                node.physicsBody?.contactTestBitMask = 1
                node.physicsBody?.isDynamic = false
            }

            let move = SKAction.moveBy(x: -size.width, y: 0, duration: duration)
            let wrap = SKAction.moveBy(x: size.width, y: 0, duration: 0)
            let sequence = SKAction.sequence([move, wrap])
            let forever = SKAction.repeatForever(sequence)
            node.run(forever)
        }
    }

    @objc func createObstacle() {
        let images = ["RockHigh", "RockLow"]
        let index = GKRandomSource.sharedRandom().nextInt(upperBound: 2)
        let random = GKRandomDistribution(lowestValue: -170, highestValue: 170)

        let obstacle = SKSpriteNode(imageNamed: images[index])
        obstacle.position.x = 768
        if index == 0 {
            #if os(iOS) || os(tvOS)
                obstacle.position.y = fromTop(45)
            #elseif os(macOS)
                obstacle.position.y = 482
            #endif
        } else if index == 1 {
            #if os(iOS) || os(tvOS)
                obstacle.position.y = fromBottom(45)
            #elseif os(macOS)
                obstacle.position.y = -482
            #endif
        }
        obstacle.zPosition = -75
        addChild(obstacle)

        obstacle.name = "obstacle"
        obstacle.physicsBody = SKPhysicsBody(texture: obstacle.texture!, size: obstacle.texture!.size())
        obstacle.physicsBody?.contactTestBitMask = 1
        obstacle.physicsBody?.isDynamic = false

        let move = SKAction.moveTo(x: -768, duration: 9)
        let remove = SKAction.removeFromParent()
        let sequence = SKAction.sequence([move, remove])
        obstacle.run(sequence)

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            let star = SKSpriteNode(imageNamed: "Star")
            star.position = CGPoint(x: 768, y: CGFloat(random.nextInt()))
            self.addChild(star)

            star.name = "star"
            star.physicsBody = SKPhysicsBody(texture: star.texture!, size: star.texture!.size())
            star.physicsBody?.contactTestBitMask = 1
            star.physicsBody?.isDynamic = false

            star.run(sequence)
        }
    }

    func playerHit(_ node: SKNode) {
        if node.name == "obstacle" {
            if let explosion = SKEmitterNode(fileNamed: "Explosion") {
                explosion.position = player.position
                addChild(explosion)
            }

            run(SKAction.playSoundFileNamed("explosion.wav", waitForCompletion: false))

            player.removeFromParent()

            let message = SKSpriteNode(imageNamed: "GameOver")
            addChild(message)

            music.removeFromParent()

            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                let scene = GameScene.newGameScene()
                self.view?.presentScene(scene)
            }
        } else if node.name == "star" {
            node.removeFromParent()

            run(SKAction.playSoundFileNamed("score.wav", waitForCompletion: false))

            score += 1
        }
    }

}

extension GameScene: SKPhysicsContactDelegate {

    func didBegin(_ contact: SKPhysicsContact) {
        guard let nodeA = contact.bodyA.node else { return }
        guard let nodeB = contact.bodyB.node else { return }

        if nodeA == player {
            playerHit(nodeB)
        } else if nodeB == player {
            playerHit(nodeA)
        }
    }

}

#if os(iOS)
    extension GameScene {

        override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            player.physicsBody?.velocity = CGVector(dx: 0, dy: 300)
        }

    }
#elseif os(tvOS)
    extension GameScene {

        override func pressesBegan(_ presses: Set<UIPress>, with event: UIPressesEvent?) {
            player.physicsBody?.velocity = CGVector(dx: 0, dy: 300)
        }

    }
#elseif os(macOS)
    extension GameScene {

        override func mouseDown(with event: NSEvent) {
            player.physicsBody?.velocity = CGVector(dx: 0, dy: 300)
        }

    }
#endif

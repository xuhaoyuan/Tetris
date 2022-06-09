//
//  Swiftris.swift
//  Swiftris
//
//  Created by Sungbae Kim on 2015. 7. 3..
//  Copyright (c) 2015년 1minute2life. All rights reserved.
//

import UIKit


enum GameState:Int {
    case stop = 0
    case play
    case pause
}


extension NSNotification.Name {
    static let LineClearNotification  = NSNotification.Name("LineClearNotification")
    static let NewBrickDidGenerateNotification = NSNotification.Name("NewBrickDidGenerateNotification")
    static let GameStateChangeNotification   = NSNotification.Name("GameStateChangeNotification")
}

class Swiftris: NSObject {
    
    // font
    static func GameFont(_ fontSize:CGFloat) -> UIFont? {
        return UIFont(name: "ChalkboardSE-Regular", size: fontSize)
    }
    
    private let gameView: GameView
    private lazy var gameTimer: GameTimer = {
         GameTimer(target: self, selector: #selector(Swiftris.gameLoop))
    }()

    private var soundManager = SoundManager()
    private var gameState = GameState.stop

    private lazy var panGesture: UIPanGestureRecognizer = {
        UIPanGestureRecognizer(target: self, action: #selector(panGestureHandler(_:)))
    }()

    private lazy var tapGesture: UITapGestureRecognizer = {
        UITapGestureRecognizer(target: self, action: #selector(tapGestureHandler))
    }()
    
    required init(gameView: GameView) {
        self.gameView = gameView
        super.init()
        self.initGame()
    }
    
    deinit {
        debugPrint("deinit Swiftris")
    }
    
    private func initGame() {

        gameView.gameBoard.addGestureRecognizer(panGesture)
        gameView.gameBoard.addGestureRecognizer(tapGesture)

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(gameStateChange(_:)),
                                               name: .GameStateChangeNotification,
                                               object: nil)

    }
    
    func deinitGame() {
        self.stop()
        self.soundManager.clear()
        self.removeGameStateChangeNotificationAction()
    }
    
    @objc func gameStateChange(_ noti:Notification) {
        guard let userInfo = noti.userInfo as? [String:NSNumber] else { return }
        guard let rawValue = userInfo["gameState"] else { return }
        guard let toState = GameState(rawValue: rawValue.intValue) else { return }
        
        switch self.gameState {
        case .play:
            // pause
            if toState == GameState.pause {
                self.pause()
            }
            // stop
            if toState == GameState.stop {
                self.stop()
            }
        case .pause:
            // resume game
            if toState == GameState.play {
                self.play()
            }
            // stop
            if toState == GameState.stop {
                self.stop()
            }
        case .stop:
            // start game
            if toState == GameState.play {
                self.prepare()
                self.play()
            }
        }
    }

    @objc func tapGestureHandler() {
        rotateBrick()
    }

    private var currentXIndex: Int = -1
    @objc func panGestureHandler(_ panGes: UIPanGestureRecognizer) {
        guard gameState == GameState.play else { return }
        guard let _ = gameView.gameBoard.currentBrick else { return }
        let point = panGes.location(in: gameView.gameBoard)
        func getXIndex() -> Int {
            let maxX: CGFloat = (point.x - CGFloat(GameBoard.gap/2))
            let width: CGFloat = CGFloat((GameBoard.brickSize+GameBoard.gap))
            return Int(maxX/width)
        }

        let newIndex = getXIndex()
        switch panGes.state {
        case .began:
            currentXIndex = newIndex
        case .changed:
            if newIndex > currentXIndex {
                gameView.gameBoard.updateX(1)
            } else if newIndex < currentXIndex {
                gameView.gameBoard.updateX(-1)
            }
            currentXIndex = newIndex
        case .ended:
            let velocity = panGes.velocity(in: gameView.gameBoard).y
            if velocity > 1300 {
                gameView.gameBoard.dropBrick()
            }
            tapGesture.require(toFail: panGes)
            currentXIndex = -1
        default:
            break
        }
    }

    @objc func gameLoop() {
        update()
        gameView.setNeedsDisplay()
    }

    private func update() {

        gameTimer.counter += 1
        
        guard gameTimer.counter%10 == 9 else { return }
        let game = gameView.gameBoard.update()

        guard !game.isGameOver else {
            gameOver()
            return
        }

        guard game.droppedBrick else { return }
        soundManager.dropBrick()
    }
    
    private func prepare() {
        gameView.prepare()
        gameView.gameBoard.generateBrick()
    }

    private func play() {
        gameState = GameState.play
        gameTimer.start()
        soundManager.playBGM()
    }

    private func pause() {
        gameState = GameState.pause
        gameTimer.pause()
        soundManager.pauseBGM()
    }

    private func stop() {
        gameState = GameState.stop
        gameTimer.pause()
        soundManager.stopBGM()
        
        gameView.clear()
    }

    private func gameOver() {
        gameState = GameState.stop
        gameTimer.pause()
        soundManager.stopBGM()
        soundManager.gameOver()
        
        gameView.nextBrick.clearButtons()
    }
    
    private func rotateBrick() {
        gameView.gameBoard.rotateBrick()
    }

    private func removeGameStateChangeNotificationAction() {
        NotificationCenter.default.removeObserver(self)
    }
    
}

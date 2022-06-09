//
//  NextBrick.swift
//  Swiftris
//
//  Created by Sungbae Kim on 2015. 7. 4..
//  Copyright (c) 2015년 1minute2life. All rights reserved.
//

import UIKit
import XHYCategories

class NextBrick: UIView {

    var exchangeHandler: VoidHandler?

   private var gameButton = GameButton(title: "Play", frame: CGRect.zero)
   private var stopButton = GameButton(title: "Stop", frame: CGRect.zero)
   private var exchangeButton = GameButton(title: "Change", frame: CGRect.zero)
    
    override init(frame: CGRect) {
        super.init(frame: CGRect.zero)
        self.backgroundColor = UIColor(red:0.21, green:0.21, blue:0.21, alpha:1.0)
        
        NotificationCenter.default.addObserver(self, selector: #selector(newBrickGenerated),
                                               name: .NewBrickDidGenerateNotification,
                                               object: nil)
        
        self.makeGameButton()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func newBrickGenerated() {
        self.setNeedsDisplay()
    }
    
     override func draw(_ rect: CGRect) {
        let gap = 4 * CGFloat(GameBoard.smallBrickSize)
        var top = 2 * CGFloat(GameBoard.smallBrickSize)
    
        for brick in Brick.nextBricks {
            let brickWidth = (brick.right().x+1) * CGFloat(GameBoard.smallBrickSize)
            let brickHeight = brick.bottom().y * CGFloat(GameBoard.smallBrickSize)
            let left = (rect.size.width - brickWidth)/2
            for p in brick.points {
                let r = Int(p.y)
                let c = Int(p.x)
                self.drawAt(top: top, left:left, row:r, col: c, color:brick.color)
            }
            top += brickHeight
            top += gap
        }
    }
    
    func drawAt(top:CGFloat, left:CGFloat, row:Int, col:Int, color:UIColor) {
        let context = UIGraphicsGetCurrentContext()!
        let block = CGRect(
            x: left + CGFloat(col*GameBoard.gap + col*GameBoard.smallBrickSize),
            y: top + CGFloat(row*GameBoard.gap + row*GameBoard.smallBrickSize),
            width: CGFloat(GameBoard.smallBrickSize),
            height: CGFloat(GameBoard.smallBrickSize)
        )
        
        if color == GameBoard.EmptyColor {
            GameBoard.strokeColor.set()
            context.fill(block)
        } else {
            color.set()
            UIBezierPath(roundedRect: block, cornerRadius: 1).fill()
        }
    }
    
    func makeGameButton() {
        // play and pause button
        gameButton.translatesAutoresizingMaskIntoConstraints = false
        gameButton.addTarget(self, action: #selector(NextBrick.changeGameState(_:)), for: .touchUpInside)
        addSubview(self.gameButton)
        
        stopButton.translatesAutoresizingMaskIntoConstraints = false
        stopButton.addTarget(self, action: #selector(NextBrick.gameStop(_:)), for: .touchUpInside)
        addSubview(self.stopButton)

        exchangeButton.layer.borderColor = UIColor.white.cgColor
        exchangeButton.layer.borderWidth = 2
        exchangeButton.layer.cornerRadius = 5
        exchangeButton.backgroundColor = UIColor.white
        addSubview(exchangeButton)
        exchangeButton.addTapGesture { [weak self] in
            self?.exchangeHandler?()
        }

        exchangeButton.snp.makeConstraints { make in
            make.size.equalTo(60)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(stopButton.snp.top).offset(-20)
        }

        gameButton.snp.makeConstraints { make in
            make.size.equalTo(60)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-20)
        }

        stopButton.snp.makeConstraints { make in
            make.size.equalTo(60)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(gameButton.snp.top).offset(-20)
        }
    }
    
    @objc func gameStop(_ sender:UIButton) {
        NotificationCenter.default.post(
            name: .GameStateChangeNotification,
            object: nil,
            userInfo: ["gameState":NSNumber(value: GameState.stop.rawValue as Int)]
        )
    }
    
    @objc func changeGameState(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        let gameState = self.update(sender.isSelected)
        
        NotificationCenter.default.post(
            name: .GameStateChangeNotification,
            object: nil,
            userInfo: ["gameState":NSNumber(value: gameState.rawValue as Int)]
        )
    }
    
    @discardableResult
    func update(_ selected:Bool) -> GameState {
        var gameState = GameState.play
        if selected {
            gameState = GameState.play
            self.gameButton.setTitle("Pause", for: .normal)
        } else {
            gameState = GameState.pause
            self.gameButton.setTitle("Play", for: .normal)
        }
        return gameState
    }
    
    func prepare() {
        self.clearButtons()
        self.clearNextBricks()
    }
    
    func clearButtons() {
        self.gameButton.isSelected = false
        self.update(self.gameButton.isSelected)
    }
    
    func clearNextBricks() {
        Brick.nextBricks = [Brick]()
        self.setNeedsDisplay()
    }
}

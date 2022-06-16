//
//  SwiftrisViewController.swift
//  Swiftris
//
//  Created by Sungbae Kim on 2016. 6. 4..
//  Copyright © 2016년 1minute2life. All rights reserved.
//

import UIKit
import SnapKit

class SwiftrisViewController: UIViewController {

    private var swiftris: Swiftris?
    private let image = UIImageView(image: UIImage(named: "background1"))

    override func viewDidLoad() {
        super.viewDidLoad()
        initializeGame()
    }
    
    deinit {
        self.swiftris?.deinitGame()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func initializeGame() {
        view.backgroundColor = UIColor.white
        view.addSubview(image)
        image.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        DispatchQueue.main.async {
            let gameView = GameView()
            self.view.addSubview(gameView)
            gameView.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
            self.swiftris = Swiftris(gameView: gameView)
        }
    }
    
    override var prefersStatusBarHidden : Bool {
        return false
    }
}

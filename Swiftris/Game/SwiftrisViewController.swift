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

    private var contentView: UIView = UIView()

    private var swiftris:Swiftris?

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
        view.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        DispatchQueue.main.async {
            let gameView = GameView(self.contentView)
            self.swiftris = Swiftris(gameView: gameView)
        }
    }
    
    override var prefersStatusBarHidden : Bool {
        return false
    }
}

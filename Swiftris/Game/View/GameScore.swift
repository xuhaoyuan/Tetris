import UIKit
import XHYCategories

class GameScore: UIView {

    var gameLevel = 0
    var lineClearCount = 0
    var gameScore = 0
    
    fileprivate var levelLabel = UILabel()
    fileprivate var lineClearLabel = UILabel()
    fileprivate var scoreLabel = UILabel()
    fileprivate var scores = [0, 10, 30, 60, 100]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        levelLabel.translatesAutoresizingMaskIntoConstraints = false
        levelLabel.textColor = UIColor.white
        levelLabel.text = "Level: \(self.gameLevel)"
        levelLabel.font = Swiftris.GameFont(20)
        levelLabel.adjustsFontSizeToFitWidth = true
        levelLabel.minimumScaleFactor = 0.9
        levelLabel.textAlignment = .center

        lineClearLabel.textColor = UIColor.white
        lineClearLabel.text = "Lines: \(self.lineClearCount)"
        lineClearLabel.font = Swiftris.GameFont(20)
        lineClearLabel.adjustsFontSizeToFitWidth = true
        lineClearLabel.minimumScaleFactor = 0.9
        lineClearLabel.textAlignment = .center

        scoreLabel = UILabel(frame: CGRect.zero)
        scoreLabel.translatesAutoresizingMaskIntoConstraints = false
        scoreLabel.textColor = UIColor.white
        scoreLabel.text = "Score: \(self.gameScore)"
        scoreLabel.font = Swiftris.GameFont(20)
        scoreLabel.adjustsFontSizeToFitWidth = true
        scoreLabel.minimumScaleFactor = 0.9
        scoreLabel.textAlignment = .center

        let stackView = UIStackView(subviews: [levelLabel, lineClearLabel, scoreLabel], axis: .horizontal, alignment: .center, distribution: .fillProportionally, spacing: 0)
        
        addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        NotificationCenter.default.addObserver(self, selector: #selector(GameScore.lineClear(_:)),
                                               name: .LineClearNotification,
                                               object: nil)
    }
    
    @objc func lineClear(_ noti:Notification) {
        if let userInfo = noti.userInfo as? [String:NSNumber] {
            if let lineCount = userInfo["lineCount"] {
                self.lineClearCount += lineCount.intValue
                self.gameScore += self.scores[lineCount.intValue]
                self.update()
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
   func clear() {
        self.gameLevel = 0
        self.lineClearCount = 0
        self.gameScore = 0
        self.update()
    }
    
    func update() {
        self.levelLabel.text = "Level: \(self.gameLevel)"
        self.lineClearLabel.text = "Lines: \(self.lineClearCount)"
        self.scoreLabel.text = "Score: \(self.gameScore)"
    }
}


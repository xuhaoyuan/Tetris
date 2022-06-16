import UIKit
import SnapKit
class GameView: BaseView {
    
    private lazy var scoreBlur: UIVisualEffectView = {
       let view = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
        view.contentView.addSubview(gameScore)
        gameScore.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        return view
    }()
    private lazy var boardBlur: UIVisualEffectView = {
        let view = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
        view.contentView.addSubview(gameBoard)
        gameBoard.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
         return view
     }()
    private lazy var brickBlur: UIVisualEffectView = {
        let view = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
        view.contentView.addSubview(nextBrick)
        nextBrick.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
         return view
     }()

    var gameScore = GameScore(frame:CGRect.zero)
    var gameBoard = GameBoard(frame:CGRect.zero)
    var nextBrick = NextBrick(frame:CGRect.zero)
    private lazy var stackView = UIStackView(subviews: [boardBlur, brickBlur],
                                             axis: .horizontal, alignment: .fill, distribution: .fill, spacing: 8)


    private var isLeft: Bool = true
    
    override init() {
        super.init()

        brickBlur.corner = 12
        boardBlur.corner = 12
        scoreBlur.corner = 12

        contentView.addSubview(scoreBlur)
        contentView.addSubview(stackView)

        scoreBlur.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(8)
            make.leading.equalTo(8)
            make.trailing.equalTo(-8)
            make.bottom.equalTo(stackView.snp.top).offset(-8)
        }

        stackView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(8)
            make.top.equalTo(scoreBlur.snp.bottom).offset(8)
            make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).offset(-8)
            make.trailing.equalToSuperview().offset(-8)
        }

        nextBrick.exchangeHandler = { [weak self] in
            self?.exchangeLayout()
        }

        boardBlur.snp.makeConstraints { make in
            make.height.equalTo(GameBoard.height)
            make.width.equalTo(GameBoard.width)
        }
    }

    private func exchangeLayout() {
        isLeft = !isLeft
        UIView.animate(withDuration: 0.3, delay: 0, options: [.beginFromCurrentState, .curveEaseInOut]) { [weak self] in
            guard let self = self else { return }
            switch self.isLeft {
            case true:
                self.stackView.insertArrangedSubview(self.boardBlur, at: 0)
            case false:
                self.stackView.insertArrangedSubview(self.brickBlur, at: 0)
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        debugPrint("deinit GameView")
    }
    
    func clear() {
        gameScore.clear()
        gameBoard.clear()
        nextBrick.prepare()
    }
    func prepare() {
        gameScore.clear()
        gameBoard.clear()
        nextBrick.clearNextBricks()
    }
}

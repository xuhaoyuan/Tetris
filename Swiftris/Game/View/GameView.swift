import UIKit

class GameView: UIView {

    var gameScore = GameScore(frame:CGRect.zero)
    var gameBoard = GameBoard(frame:CGRect.zero)
    var nextBrick = NextBrick(frame:CGRect.zero)
    private lazy var stackView = UIStackView(subviews: [gameBoard, nextBrick],
                                             axis: .horizontal, alignment: .fill, distribution: .fill, spacing: 8)


    private var isLeft: Bool = true
    
    init(_ superView:UIView) {
        super.init(frame: superView.bounds)
        superView.backgroundColor = UIColor(red:0.27, green:0.27, blue:0.27, alpha:1.0)
        superView.addSubview(self)

        backgroundColor = UIColor(red:0.27, green:0.27, blue:0.27, alpha:1.0)

        gameScore.corner = 12
        nextBrick.corner = 12
        gameBoard.corner = 12

        addSubview(gameScore)
        addSubview(stackView)

        gameScore.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(8)
            make.leading.equalTo(8)
            make.trailing.equalTo(-8)
            make.bottom.equalTo(gameBoard.snp.top).offset(-8)
        }

        stackView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(8)
            make.top.equalTo(gameScore.snp.bottom).offset(8)
            make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).offset(-8)
            make.trailing.equalToSuperview().offset(-8)
        }

        nextBrick.exchangeHandler = { [weak self] in
            self?.exchangeLayout()
        }

        gameBoard.snp.makeConstraints { make in
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
                self.stackView.insertArrangedSubview(self.gameBoard, at: 0)
            case false:
                self.stackView.insertArrangedSubview(self.nextBrick, at: 0)
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

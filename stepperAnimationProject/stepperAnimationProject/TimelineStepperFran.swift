//
//  TimelineStepper.swift
//  InStoreUIComponents
//
//  Created by Paulo Henrique Machtura on 13/10/21.
//

import UIKit

final class TimelineStepperFran: UIView {

    private var contentStackView: UIStackView = {
        let view = UIStackView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .horizontal
        view.distribution = .fill
        view.isLayoutMarginsRelativeArrangement = true
        view.layoutMargins = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 2)
        view.alignment = .center
        view.clipsToBounds = true
        return view
    }()

//    private var orderStatusStepperConfiguration: OrderStatusStepperProtocol?

    private var circleLayerAnimation = "opacity"

    private var lineLayerAnimation = "strokeEnd"

    private var animationKey = "animation"
    
    /// Halo Circle
    private var haloCircleView: UIView?

    // MARK: - Initializers

    public init() {
        super.init(frame: .zero)
        setupView()
        setupConstraints()
    }

//    public init(orderStatus: OrderStatusStepperProtocol) {
//        super.init(frame: .zero)
//        setupView()
//        setupConstraints()
//    }
    

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public Methods
    public func update() {
        contentStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }

        let totaldelayAnimation = 0.0
        let delay = 0.20
        let animated = false

        drawStepes(totaldelay: totaldelayAnimation, delay: delay, animated: animated)

    }

    private func drawStepes(totaldelay: Double, delay: Double, animated: Bool ) {
        var totaldelayAnimation = 0.0
        for item in 1 ... 3 {
            if item == 2 {
                if item != 1 {
                    self.drawLineBetweenStep(selectedLine: true, animation: animated, totaldelayAnimation: totaldelayAnimation)
                }
                self.contentStackView.addArrangedSubview(self.createCurrentStepCircle())
                totaldelayAnimation = totaldelayAnimation + delay
                
            } else if item < 2 {
                if item != 1 {
                    self.drawLineBetweenStep(selectedLine: true, animation: animated, totaldelayAnimation: totaldelayAnimation)
                }
                self.contentStackView.addArrangedSubview(self.createStepCircle())
                totaldelayAnimation = totaldelayAnimation + delay
                
            } else if item > 2 {
                if item != 1 {
                    self.drawLineBetweenStep(selectedLine: false, animation: animated, totaldelayAnimation: totaldelayAnimation)
                }
                self.contentStackView.addArrangedSubview(self.createNextStepCircle())
                totaldelayAnimation = totaldelayAnimation + delay
            }
        }
    }

    private func drawLineBetweenStep(selectedLine: Bool, animation: Bool, totaldelayAnimation: Double ) {
        var color: UIColor
        if selectedLine {
            //            color = UIColor(red: 0, green: 166, blue: 80, alpha: 1)
            color = .blue
        } else {
            //            color = UIColor(red: 222, green: 222, blue: 222, alpha: 1)
            color = .white
            
        }
        self.contentStackView.addArrangedSubview(self.drawLine(color: color, animation: animation, delay: totaldelayAnimation))
    }
    
    // MARK: - Helper
//    private func StringToColor(string: String?, type: TimeLineStepperDefaultColors) -> UIColor {
//        if let string = string, let color = UIColor(hexString: string) {
//            return color
//        }
//        return type.rawValue
//    }

    // MARK: - Setup Methods
    private func setupView() {
        translatesAutoresizingMaskIntoConstraints = false
        addSubview(contentStackView)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            contentStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentStackView.topAnchor.constraint(equalTo: topAnchor)
        ])

        NSLayoutConstraint.activate([
            self.heightAnchor.constraint(equalToConstant: 20),
            self.widthAnchor.constraint(equalTo: contentStackView.widthAnchor )
        ])

    }

}
// MARK: - Draw shapes Methods
extension TimelineStepperFran {
    // MARK: - StepCircle
    private func createStepCircle(animation: Bool = false) -> UIView {
        let size: CGFloat = 10.0

        let circleView = createBaseView(size: size, background: UIColor.clear)

        let circlePath = createCirclePath(withSize: size, withBorder: false)

        let shapeLayer = CAShapeLayer()
        shapeLayer.path = circlePath.cgPath
        shapeLayer.fillColor = UIColor.blue.cgColor

        if animation {
            let animation = createAnimation(key: circleLayerAnimation)
            shapeLayer.add(animation, forKey: animationKey)
        }

        circleView.layer.addSublayer(shapeLayer)
        setupSizeConstraints(view: circleView, height: size, width: size)

        return circleView
    }

    private func createCirclePath(withSize: CGFloat, withBorder: Bool) -> UIBezierPath {
    let borderSize: CGFloat = withBorder ? 0.5 : 0.0
        return UIBezierPath(arcCenter: CGPoint(x: withSize/2, y: withSize/2),
                                      radius: CGFloat( withSize/2  - borderSize),
                                      startAngle: CGFloat(0),
                                      endAngle: CGFloat(Double.pi * 2),
                                      clockwise: true)
    }
    
    // MARK: - NextStepCircle
    private func createNextStepCircle(animation: Bool = false) -> UIView {
        let size: CGFloat = 10
        let circleInternalColor = UIColor.white.cgColor

        let circleView = createBaseView(size: size, background: UIColor.clear)

        let circlePath = createCirclePath(withSize: size, withBorder: false)
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = circlePath.cgPath
        shapeLayer.fillColor = circleInternalColor
        circleView.layer.addSublayer(shapeLayer)

        let circlePath2 =  createCirclePath(withSize: size, withBorder: true)

        let shapeLayer2 = self.createShapeLayer(strokeColor: UIColor.blue, lineWidth: 2)
        shapeLayer2.path = circlePath2.cgPath

        if animation {
            let animation = createAnimation(key: circleLayerAnimation)
            shapeLayer2.add(animation, forKey: animationKey)
        }

        circleView.layer.addSublayer(shapeLayer2)
        setupSizeConstraints(view: circleView, height: size, width: size)

        return circleView
    }

    private func createAnimation(key: String) -> CABasicAnimation {
        let animation = CABasicAnimation(keyPath: key)
        animation.duration = 1
        animation.fromValue = 0
        animation.toValue = 1
        return animation
    }

    private func createShapeLayer(strokeColor: UIColor, lineWidth: CGFloat) -> CAShapeLayer {
        let shapeLayer = CAShapeLayer()
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = strokeColor.cgColor
        shapeLayer.lineWidth = lineWidth
        return shapeLayer
    }

    private func createBaseView(size: CGFloat, background: UIColor ) -> UIView {
        let view = UIView(frame: CGRect(x: .zero, y: .zero, width: size, height: size))
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.clear
        return view
    }
    
    // ARREGLAR ESTO
    private func myCreateCirclePath(withSize: CGSize, withRadius: CGFloat, withBorder: CGFloat = 0.0) -> UIBezierPath {
        return UIBezierPath(arcCenter: CGPoint(x: withSize.width/2, y: withSize.height/2),
                            radius: CGFloat(withRadius/2 - withBorder),
                            startAngle: CGFloat(0),
                            endAngle: CGFloat(Double.pi * 2),
                            clockwise: true)
    }
    
    // MARK: - CurrentStepCircle
    private func createCurrentStepCircle(animation: Bool = false) -> UIView {
        let sizeStepCircle: CGFloat = 12
        let sizeView = CGSize(width: 20, height: 20)
        let radiusHaloCircle: CGFloat = 20
        let sizeAnimation: CGFloat = 26

        let viewContainer = createBaseView(size: sizeView.width, background: UIColor.clear)

        let filledCircleView = createBaseView(size: sizeView.height, background: UIColor.clear)
        let haloCircleView = createBaseView(size: sizeView.width, background: UIColor.clear)

        // Filled Circle
        let filledCircleShapeLayer = CAShapeLayer()
        let filledCirclePath = myCreateCirclePath(withSize: filledCircleView.bounds.size,
                                            withRadius: sizeStepCircle)

        filledCircleShapeLayer.path = filledCirclePath.cgPath
//        filledCircleShapeLayer.fillColor = UIColor(red: 0, green: 166, blue: 80, alpha: 1).cgColor
        filledCircleShapeLayer.fillColor = UIColor.blue.cgColor

        // Halo Circle
        let haloCirclePath =  myCreateCirclePath(withSize: haloCircleView.bounds.size,
                                              withRadius: radiusHaloCircle,
                                              withBorder: 0.5)

//        let haloCircleShapeLayer = createShapeLayer(strokeColor: UIColor(red: 0, green: 166, blue: 80, alpha: 1),
//                                           lineWidth: 1)
        let haloCircleShapeLayer = createShapeLayer(strokeColor: UIColor.blue,
                                                    lineWidth: 1)
        haloCircleShapeLayer.opacity = 0.3
        haloCircleShapeLayer.path = haloCirclePath.cgPath

        if animation {
            let animation = createAnimation(key: circleLayerAnimation)
            haloCircleShapeLayer.add(animation, forKey: animationKey)
        }

        // MARK: ANIMATION

        // Changes radius in Halo Circle
        let pathAnimation = CABasicAnimation(keyPath: #keyPath(CAShapeLayer.path))
        pathAnimation.fromValue = myCreateCirclePath(withSize: haloCircleView.bounds.size,
                                                     withRadius: radiusHaloCircle,
                                                     withBorder: 0.5).cgPath
        pathAnimation.toValue = myCreateCirclePath(withSize: haloCircleView.bounds.size,
                                                   withRadius: sizeAnimation,
                                                   withBorder: 1.0).cgPath
        pathAnimation.duration = 2.0
        pathAnimation.repeatCount = .greatestFiniteMagnitude
        pathAnimation.autoreverses = true

        // Changes lineWidth in Halo Circle
        let lineWidthAnimation = CABasicAnimation(keyPath: #keyPath(CAShapeLayer.lineWidth))
        lineWidthAnimation.fromValue = 1.0
        lineWidthAnimation.toValue = 2.0
//        lineWidthAnimation.duration = 2.0
        lineWidthAnimation.repeatCount = .greatestFiniteMagnitude
        lineWidthAnimation.autoreverses = true

        // Adding of sublayers to circleView.layer
        filledCircleView.layer.addSublayer(filledCircleShapeLayer)
        haloCircleView.layer.addSublayer(haloCircleShapeLayer)

        // Apply all animations to haloCircleShapeLayer
        CATransaction.begin()
        CATransaction.setAnimationDuration(2)
        CATransaction.setCompletionBlock {
            print("PANCHO")
        }

        haloCircleShapeLayer.add(pathAnimation, forKey: nil)
        haloCircleShapeLayer.add(lineWidthAnimation, forKey: nil)

        CATransaction.commit()

        viewContainer.addSubview(filledCircleView)
        viewContainer.addSubview(haloCircleView)

        setupSizeConstraints(view: filledCircleView, height: sizeView.height, width: sizeView.width)
        setupSizeConstraints(view: haloCircleView, height: sizeView.height, width: sizeView.width)

        setupSizeConstraints(view: viewContainer, height: sizeView.height, width: sizeView.width)

        return viewContainer
    }

    private func drawLine(color: UIColor, animation: Bool, delay: Double = 0) -> UIView {
        let lineView = UIView()
        let size: CGFloat = 13
        let lineHeight: CGFloat = 2

        lineView.bounds = CGRect(x: .zero, y: .zero, width: size, height: lineHeight)
        lineView.translatesAutoresizingMaskIntoConstraints = false
        lineView.backgroundColor = UIColor.clear

        var shapeLayer: CAShapeLayer?
        let path = UIBezierPath()
        path.move(to: CGPoint(x: .zero, y: 1))
        path.addLine(to: CGPoint(x: size/2, y: 1))
        path.addLine(to: CGPoint(x: size, y: 1))

        shapeLayer = CAShapeLayer()
        shapeLayer?.fillColor = color.cgColor
        shapeLayer?.strokeColor = color.cgColor
        shapeLayer?.lineWidth = 2
        shapeLayer?.path = path.cgPath

        if animation {
            let animation = CABasicAnimation(keyPath: lineLayerAnimation)
            animation.fromValue = 0
            animation.toValue = 1
            animation.duration = 0.5
            animation.beginTime = CACurrentMediaTime() + delay
            shapeLayer?.add(animation, forKey: animationKey)
        }

        lineView.layer.addSublayer(shapeLayer!)

        setupSizeConstraints(view: lineView, height: lineHeight, width: size)

        return lineView
    }

    private func setupSizeConstraints(view: UIView, height: CGFloat, width: CGFloat) {
        NSLayoutConstraint.activate([
            view.heightAnchor.constraint(equalToConstant: height),
            view.widthAnchor.constraint(equalToConstant: width)
        ])
    }

    enum TimeLineStepperDefaultColors {
        case currentColor
        case selectedColor
        case nextColor

        var rawValue: UIColor {
            switch self {
            case .currentColor, .selectedColor:
                return UIColor(red: 0, green: 166, blue: 80, alpha: 1)
            case .nextColor:
                return UIColor(red: 222, green: 222, blue: 222, alpha: 1)
            }
        }
    }
}

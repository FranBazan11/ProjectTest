//
//  MyTimelineStepper.swift
//  stepperAnimationProject
//
//  Created by Juan Francisco Bazan Carrizo on 25/03/2022.
//

import UIKit

class MyTimelineStepper: UIView {
    
    // MARK: - Private Properties
    
    private var contentStackView: UIStackView = {
        let view = UIStackView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .horizontal
        view.distribution = .fill
        view.isLayoutMarginsRelativeArrangement = true
        view.layoutMargins = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 2)
        view.alignment = .center
        return view
    }()
    
    /// Halo Circle
    private var haloCircleView: UIView?
    
    /// Properties CurrentStepCircle
    private let sizeStepCircle: CGSize = CGSize(width: 12, height: 12)
    private let sizeView = CGSize(width: 20, height: 20)
    private let sizeAnimation: CGFloat = 26
    
    enum borderCircle: CGFloat {
        /// CurrentStepCircle
        case borderWidthStepCircleAnimation = 2
        case borderWidthStepCircle = 1
    }
    
    //    private var orderStatusStepperConfiguration: OrderStatusStepperProtocol?
    
    private var circleLayerAnimation = "opacity"
    
    private var lineLayerAnimation = "strokeEnd"
    
    private var animationKey = "animation"
    
    
    
    // MARK: - Initializers
    
    public init() {
        super.init(frame: .zero)
        setupView()
        setupConstraints()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Methods
    
    public func update() {
        contentStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        let totalDelayAnimation = 0.0
        let delay = 0.20
        let animated = false
        
        drawStepes(totalDelay: totalDelayAnimation,
                   delay: delay,
                   animated: animated)
    }
    
    // MARK: - Private Methods

    private func drawStepes(totalDelay: Double,
                            delay: Double,
                            animated: Bool ) {
        
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
        
        let line = self.drawLine(color: color, animation: animation, delay: totaldelayAnimation)
        
        self.contentStackView.addArrangedSubview(line)
        contentStackView.sendSubviewToBack(line)
    }
    // MARK: - Helper
    
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
            self.heightAnchor.constraint(equalTo: contentStackView.heightAnchor),
            self.widthAnchor.constraint(equalTo: contentStackView.widthAnchor )
        ])
    }
}
// MARK: - Draw shapes Methods
extension MyTimelineStepper {
    
    // MARK: - ANIMATION
    private func animationCurrentStepCircle(view: UIView, duration: TimeInterval, borders: [borderCircle]) {
        UIView.animateKeyframes(withDuration: duration, delay: 0, options: [.repeat], animations: {
            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.4) { [self] in
                view.transform = CGAffineTransform(scaleX: (sizeAnimation)/sizeView.width,
                                                   y: (sizeAnimation)/sizeView.height)
                view.layer.borderWidth = borderCircle.borderWidthStepCircleAnimation.rawValue
            }
            
            UIView.addKeyframe(withRelativeStartTime: 0.4, relativeDuration: 1.0) {
                view.transform = .identity
                view.layer.borderWidth = borderCircle.borderWidthStepCircle.rawValue
            }
        })
    }

    private func createBaseView(size: CGSize, background: UIColor ) -> UIView {
        let view = UIView(frame: CGRect(x: .zero, y: .zero, width: size.width, height: size.height))
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = background
        return view
    }
    
    private func createCircleViews(size: CGSize, background: UIColor, cornerRadius: CGFloat, borderColor: CGColor? = UIColor.clear.cgColor, opacity: Float? = 1.0, borderWidth: CGFloat? = 0.0 ) -> UIView {
        let view = UIView(frame: CGRect(x: .zero, y: .zero, width: size.width, height: size.height))
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = cornerRadius
        view.layer.borderWidth = borderWidth!
        view.layer.borderColor = borderColor
        view.backgroundColor = background
        view.layer.opacity = opacity!
        return view
    }
    
    // MARK: - StepCircle
    private func createStepCircle(animation: Bool = false) -> UIView {
        let size = CGSize(width: 10, height: 10)
        
        let circleView = createBaseView(size: size, background: UIColor.clear)
        
        let circlePath = createCirclePath(withSize: size.width, withBorder: false)
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = circlePath.cgPath
        //        shapeLayer.fillColor = UIColor(red: 0, green: 166, blue: 80, alpha: 1).cgColor
        shapeLayer.fillColor = UIColor.blue.cgColor
        
        if animation {
            let animation = createAnimation(key: circleLayerAnimation)
            shapeLayer.add(animation, forKey: animationKey)
        }
        
        circleView.layer.addSublayer(shapeLayer)
        setupSizeConstraints(view: circleView, height: size.height, width: size.width)
        
        return circleView
    }
    
    private func createCirclePath(withSize: CGFloat, withBorder: Bool) -> UIBezierPath {
        let borderSize: CGFloat = withBorder ? 0.5 : 0.0
        return UIBezierPath(arcCenter: CGPoint(x: withSize/2, y: withSize/2),
                            radius: CGFloat(withSize/2 - borderSize),
                            startAngle: CGFloat(0),
                            endAngle: CGFloat(Double.pi * 2),
                            clockwise: true)
    }
    
    // MARK: NextStepCircle
    private func createNextStepCircle(animation: Bool = false) -> UIView {
        let size = CGSize(width: 10, height: 10)
        let circleInternalColor = UIColor.white.cgColor
        
        let circleView = createBaseView(size: size, background: UIColor.clear)
        
        let circlePath = createCirclePath(withSize: size.width, withBorder: false)
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = circlePath.cgPath
        shapeLayer.fillColor = circleInternalColor
        circleView.layer.addSublayer(shapeLayer)
        
        let circlePath2 =  createCirclePath(withSize: size.width, withBorder: true)
        
        //        let shapeLayer2 = self.createShapeLayer(strokeColor: UIColor(red: 0, green: 166, blue: 80, alpha: 1), lineWidth: 2)
        let shapeLayer2 = self.createShapeLayer(strokeColor: UIColor.blue, lineWidth: 2)
        shapeLayer2.path = circlePath2.cgPath
        
        if animation {
            let animation = createAnimation(key: circleLayerAnimation)
            shapeLayer2.add(animation, forKey: animationKey)
        }
        
        circleView.layer.addSublayer(shapeLayer2)
        setupSizeConstraints(view: circleView, height: size.height, width: size.width)
        
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
        

        let viewContainer = createBaseView(size: sizeView, background: UIColor.clear)
        
        let filledCircleView = createBaseView(size: sizeView, background: UIColor.clear)
        

        /// Filled Circle
        let filledCircleShapeLayer = CAShapeLayer()
        let filledCirclePath = myCreateCirclePath(withSize: filledCircleView.bounds.size,
                                                  withRadius: sizeStepCircle.width)

        filledCircleShapeLayer.path = filledCirclePath.cgPath
//        filledCircleShapeLayer.fillColor = UIColor(red: 0, green: 166, blue: 80, alpha: 1).cgColor
        filledCircleShapeLayer.fillColor = UIColor(red: 0.000, green: 0.651, blue: 0.314, alpha: 1.00).cgColor
        /// Adding of sublayers to circleView.layer
        filledCircleView.layer.addSublayer(filledCircleShapeLayer)
        
        
        /// Halo Circle
        haloCircleView = createCircleViews(size: sizeView, background: UIColor.clear, cornerRadius: sizeView.width/2, borderColor: UIColor(red: 0.702, green: 0.894, blue: 0.796, alpha: 1.00).cgColor, opacity: 1, borderWidth: 1)
//        let haloCirclePath =  myCreateCirclePath(withSize: haloCircleView!.bounds.size,
//                                                 withRadius: sizeView.width,
//                                              withBorder: 0.5)
//
////        let haloCircleShapeLayer = createShapeLayer(strokeColor: UIColor(red: 0, green: 166, blue: 80, alpha: 1),
////                                           lineWidth: 1)
//        let haloCircleShapeLayer = createShapeLayer(strokeColor: UIColor.blue,
//                                                    lineWidth: 1)
//        haloCircleShapeLayer.opacity = 0.3
//        haloCircleShapeLayer.path = haloCirclePath.cgPath
        
        if animation {
//            let animation = createAnimation(key: circleLayerAnimation)
//            haloCircleShapeLayer.add(animation, forKey: animationKey)
        }

        /// Animacion CurrentStepCircle
        animationCurrentStepCircle(view: haloCircleView!, duration: 2, borders: [.borderWidthStepCircle, .borderWidthStepCircleAnimation])

        viewContainer.addSubview(filledCircleView)
        viewContainer.addSubview(haloCircleView!)

        setupSizeConstraints(view: filledCircleView, height: sizeView.height, width: sizeView.width)
        setupSizeConstraints(view: haloCircleView!, height: sizeView.height, width: sizeView.width)

        setupSizeConstraints(view: viewContainer, height: sizeView.height, width: sizeView.width)

        return viewContainer
    }
    
    // MARK: - DrawLine
    private func drawLine(color: UIColor, animation: Bool, delay: Double = 0) -> UIView {
        let size: CGFloat = 10 // ANTES 13
        let lineView = UIView()
       
        let lineHeight: CGFloat = 2

        lineView.bounds = CGRect(x: .zero, y: .zero, width: size, height: lineHeight)
        lineView.translatesAutoresizingMaskIntoConstraints = false
        lineView.backgroundColor = UIColor.clear

        let path = UIBezierPath()
        path.move(to: CGPoint(x: .zero, y: 1))
        path.addLine(to: CGPoint(x: size/2, y: 1))
        path.addLine(to: CGPoint(x: size, y: 1))

        let shapeLayer = CAShapeLayer()
        shapeLayer.fillColor = color.cgColor
        shapeLayer.strokeColor = color.cgColor
        shapeLayer.lineWidth = 2
        shapeLayer.path = path.cgPath

        if animation {
            let animation = CABasicAnimation(keyPath: lineLayerAnimation)
            animation.fromValue = 0
            animation.toValue = 1
            animation.duration = 0.5
            animation.beginTime = CACurrentMediaTime() + delay
            shapeLayer.add(animation, forKey: animationKey)
        }

        lineView.layer.addSublayer(shapeLayer)

        setupSizeConstraints(view: lineView, height: lineHeight, width: size)

        return lineView
    }
    
    private func setupSizeConstraints(view: UIView, height: CGFloat, width: CGFloat) {
        NSLayoutConstraint.activate([
            view.heightAnchor.constraint(equalToConstant: height),
            view.widthAnchor.constraint(equalToConstant: width)
        ])
    }
    
    //    enum TimeLineStepperDefaultColors {
    //        case currentColor
    //        case selectedColor
    //        case nextColor
    //
    //        var rawValue: UIColor {
    //            switch self {
    //            case .currentColor, .selectedColor:
    //                return UIColor(red: 0, green: 166, blue: 80, alpha: 1)
    //            case .nextColor:
    //                return UIColor(red: 222, green: 222, blue: 222, alpha: 1)
    //            }
    //        }
    //    }
}

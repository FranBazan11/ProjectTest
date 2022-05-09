//: A UIKit based Playground for presenting user interface

import UIKit
import PlaygroundSupport

class MyViewController : UIViewController {
    
    let myView = UIView()
    
    var contentView: UIStackView = {
        let view = UIStackView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .horizontal
        view.distribution = .fill
        view.isLayoutMarginsRelativeArrangement = true
        view.layoutMargins = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 2)
        view.alignment = .center
        return view
    }()
    
    
    override func loadView() {
        self.view = myView
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.clipsToBounds = true
        contentView.layer.masksToBounds = true
        myView.addSubview(contentView)
        
        drawStepes(totalDelay: 0, delay: 0.2, animated: false)
        
        
        NSLayoutConstraint.activate([
            contentView.centerXAnchor.constraint(equalTo: myView.centerXAnchor),
            contentView.centerYAnchor.constraint(equalTo: myView.centerYAnchor),
        ])
    }
    
    
    // MARK: - Private Methods
    func drawStepes(totalDelay: Double, delay: Double, animated: Bool ) {
        
        var totaldelayAnimation = 0.0
        
        for item in 1 ... 3 {
            if (item == 2) {
                if item != 1 {
                    drawLineBetweenStep(selectedLine: true, animation: animated, totaldelayAnimation: totaldelayAnimation)
                }
                contentView.addArrangedSubview(createCurrentStepCircle())
                totaldelayAnimation = totaldelayAnimation + delay
                
            } else if item < 2 {
                if item != 1 {
                    drawLineBetweenStep(selectedLine: true, animation: animated, totaldelayAnimation: totaldelayAnimation)
                }
                contentView.addArrangedSubview(createStepCircle())
                totaldelayAnimation = totaldelayAnimation + delay
                
            } else if item > 2 {
                if item != 1 {
                    drawLineBetweenStep(selectedLine: false, animation: animated, totaldelayAnimation: totaldelayAnimation)
                }
                contentView.addArrangedSubview(createNextStepCircle())
                totaldelayAnimation = totaldelayAnimation + delay
            }
        }
    }
    
    // MARK: - CurrentStepCircle
    func createCurrentStepCircle(animation: Bool = false) -> UIView {
        let sizeStepCircle: CGFloat = 12
        let sizeView = CGSize(width: 20, height: 20)
        let radiusHaloCircle: CGFloat = 20
        let sizeAnimation: CGFloat = 26
        
        let circleView = createBaseView(size: sizeView, background: UIColor.clear)
        
        // Filled Circle
        let filledCircleShapeLayer = CAShapeLayer()
        let filledCirclePath = myCreateCirclePath(withSize: circleView.bounds.size,
                                                  withRadius: sizeStepCircle)
        
        filledCircleShapeLayer.path = filledCirclePath.cgPath
        filledCircleShapeLayer.fillColor = UIColor.blue.cgColor
        
        
        
        // Halo Circle
        let haloCirclePath =  myCreateCirclePath(withSize: circleView.bounds.size,
                                                 withRadius: radiusHaloCircle,
                                                 withBorder: 0.5)
        
        let haloCircleShapeLayer = createShapeLayer(strokeColor: UIColor.blue,
                                                    lineWidth: 1)
        haloCircleShapeLayer.opacity = 0.3
        haloCircleShapeLayer.path = haloCirclePath.cgPath
        
        if animation {
            let animation = createAnimation(key: "opasity")
            haloCircleShapeLayer.add(animation, forKey: "animationKey")
        }
        
        // MARK: ANIMATION
        
        // Changes radius in Halo Circle
        let pathAnimation = CABasicAnimation(keyPath: #keyPath(CAShapeLayer.path))
        pathAnimation.fromValue = myCreateCirclePath(withSize: circleView.bounds.size,
                                                     withRadius: radiusHaloCircle,
                                                     withBorder: 0.5).cgPath
        pathAnimation.toValue = myCreateCirclePath(withSize: circleView.bounds.size,
                                                   withRadius: sizeAnimation,
                                                   withBorder: 1.0).cgPath
        pathAnimation.duration = 2.0
        pathAnimation.repeatCount = .greatestFiniteMagnitude
        pathAnimation.autoreverses = true
        
        // Changes lineWidth in Halo Circle
        let lineWidthAnimation = CABasicAnimation(keyPath: #keyPath(CAShapeLayer.lineWidth))
        lineWidthAnimation.fromValue = 1.0
        lineWidthAnimation.toValue = 2.0
        lineWidthAnimation.duration = 2.0
        lineWidthAnimation.repeatCount = .greatestFiniteMagnitude
        lineWidthAnimation.autoreverses = true
        
        // Adding of sublayers to circleView.layer
        circleView.layer.addSublayer(filledCircleShapeLayer)
        circleView.layer.addSublayer(haloCircleShapeLayer)
        
        // Apply all animations to shapeLayer2
        CATransaction.begin()
        haloCircleShapeLayer.add(pathAnimation, forKey: nil)
        haloCircleShapeLayer.add(lineWidthAnimation, forKey: nil)
        CATransaction.commit()
        
        setupSizeConstraints(view: circleView, height: sizeView.height, width: sizeView.width)
        
        return circleView
    }
    
    func drawLineBetweenStep(selectedLine: Bool, animation: Bool, totaldelayAnimation: Double ) {
        
        contentView.addArrangedSubview(drawLine(color: UIColor.gray, animation: animation, delay: totaldelayAnimation))
    }
    
    func drawLine(color: UIColor, animation: Bool, delay: Double = 0) -> UIView {
        let lineView = UIView()
        let size: CGFloat = 13
        let lineHeight: CGFloat = 2
        
        lineView.bounds = CGRect(x: .zero, y: .zero, width: size, height: lineHeight)
        lineView.translatesAutoresizingMaskIntoConstraints = false
        lineView.backgroundColor = UIColor.clear
        
        let path = UIBezierPath()
        path.move(to: CGPoint(x: .zero, y: 1))
        path.addLine(to: CGPoint(x: size/2, y: 1))
        path.addLine(to: CGPoint(x: size, y: 1))
        
        let lineShapeLayer = CAShapeLayer()
        lineShapeLayer.fillColor = color.cgColor
        lineShapeLayer.strokeColor = color.cgColor
        lineShapeLayer.lineWidth = 2
        lineShapeLayer.path = path.cgPath
        
        if animation {
            let animation = CABasicAnimation(keyPath: "strokeEnd")
            animation.fromValue = 0
            animation.toValue = 1
            animation.duration = 0.5
            animation.beginTime = CACurrentMediaTime() + delay
            lineShapeLayer.add(animation, forKey: "animationKey")
        }
        
        lineView.layer.insertSublayer(lineShapeLayer, at: 0)
        
        setupSizeConstraints(view: lineView, height: lineHeight, width: size)
        
        return lineView
    }
    
    
    
        
    // MARK: NextStepCircle
    func createNextStepCircle(animation: Bool = false) -> UIView {
        let size = CGSize(width: 10, height: 10)
        let circleInternalColor = UIColor.white.cgColor
        
        let circleView = createBaseView(size: size, background: UIColor.clear)
        
        let circlePath = createCirclePath(withSize: size.width, withBorder: false)
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = circlePath.cgPath
        shapeLayer.fillColor = circleInternalColor
        circleView.layer.addSublayer(shapeLayer)
        
        let circlePath2 =  createCirclePath(withSize: size.width, withBorder: true)
        
        let shapeLayer2 = createShapeLayer(strokeColor: .blue, lineWidth: 2)
        shapeLayer2.path = circlePath2.cgPath
        
        if animation {
            let animation = createAnimation(key: "opacity")
            shapeLayer2.add(animation, forKey: "animationKey")
        }
        
        circleView.layer.addSublayer(shapeLayer2)
        setupSizeConstraints(view: circleView, height: size.height, width: size.width)
        
        return circleView
    }
    
    // MARK: - StepCircle
    func createStepCircle(animation: Bool = false) -> UIView {
        let size = CGSize(width: 10, height: 10)
        
        let circleView = createBaseView(size: size, background: UIColor.clear)
        
        let circlePath = createCirclePath(withSize: size.width, withBorder: false)
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = circlePath.cgPath
        shapeLayer.fillColor = UIColor.blue.cgColor
        
        if animation {
            let animation = createAnimation(key: "opacity")
            shapeLayer.add(animation, forKey: "animationKey")
        }
        
        circleView.layer.addSublayer(shapeLayer)
        setupSizeConstraints(view: circleView, height: size.height, width: size.width)
        
        return circleView
    }
    
    
    func createCirclePath(withSize: CGFloat, withBorder: Bool) -> UIBezierPath {
        let borderSize: CGFloat = withBorder ? 0.5 : 0.0
        return UIBezierPath(arcCenter: CGPoint(x: withSize/2, y: withSize/2),
                            radius: CGFloat(withSize/2 - borderSize),
                            startAngle: CGFloat(0),
                            endAngle: CGFloat(Double.pi * 2),
                            clockwise: true)
    }
    
    func createBaseView(size: CGSize, background: UIColor ) -> UIView {
        let view = UIView(frame: CGRect(x: .zero, y: .zero, width: size.width, height: size.height))
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = background
        return view
    }
    
    func createAnimation(key: String) -> CABasicAnimation {
        let animation = CABasicAnimation(keyPath: key)
        animation.duration = 1
        animation.fromValue = 0
        animation.toValue = 1
        return animation
    }
    
    func setupSizeConstraints(view: UIView, height: CGFloat, width: CGFloat) {
        NSLayoutConstraint.activate([
            view.heightAnchor.constraint(equalToConstant: height),
            view.widthAnchor.constraint(equalToConstant: width)
        ])
    }
    
    func createShapeLayer(strokeColor: UIColor, lineWidth: CGFloat) -> CAShapeLayer {
        let shapeLayer = CAShapeLayer()
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = strokeColor.cgColor
        shapeLayer.lineWidth = lineWidth
        return shapeLayer
    }
    
    func myCreateCirclePath(withSize: CGSize, withRadius: CGFloat, withBorder: CGFloat = 0.0) -> UIBezierPath {
            return UIBezierPath(arcCenter: CGPoint(x: withSize.width/2, y: withSize.height/2),
                                radius: CGFloat(withRadius/2 - withBorder),
                                startAngle: CGFloat(0),
                                endAngle: CGFloat(Double.pi * 2),
                                clockwise: true)
        }
        
        
    }
    // Present the view controller in the Live View window
    PlaygroundPage.current.liveView = MyViewController()

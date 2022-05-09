//: A UIKit based Playground for presenting user interface
  
import UIKit
import PlaygroundSupport

class MyViewController : UIViewController {
    override func loadView() {
        
        let view = UIView()
        view.backgroundColor = .white

        let layer = CAShapeLayer()
        layer.path = UIBezierPath(arcCenter: CGPoint(x:60, y: 60),
                                  radius: CGFloat (6),
                                  startAngle: CGFloat(0),
                                  endAngle: CGFloat(Double.pi * 2),
                                  clockwise: true).cgPath
        layer.fillColor = UIColor.blue.cgColor
        view.layer.addSublayer(layer)
        
        let shapeLayer2 = CAShapeLayer()
        let circlePath2 = UIBezierPath(arcCenter: CGPoint(x: 60, y: 60),
                                       radius: CGFloat (10 - 0.5),
                                       startAngle: CGFloat(0),
                                       endAngle: CGFloat(Double.pi * 2),
                                       clockwise: true)
        
        shapeLayer2.strokeColor = UIColor.blue.cgColor
        shapeLayer2.fillColor = UIColor.clear.cgColor
        shapeLayer2.lineWidth = 2
        shapeLayer2.opacity = 0.3
        
        shapeLayer2.path = circlePath2.cgPath
        
        view.layer.addSublayer(shapeLayer2)
        
        let boundsAnimation = CABasicAnimation(keyPath: #keyPath(CAShapeLayer.path))
        boundsAnimation.fromValue = UIBezierPath(arcCenter: CGPoint(x: 60, y: 60),
                                                 radius: CGFloat (10 - 0.5),
                                                 startAngle: CGFloat(0),
                                                 endAngle: CGFloat(Double.pi * 2),
                                                 clockwise: true).cgPath
        boundsAnimation.toValue = UIBezierPath(arcCenter: CGPoint(x: 60, y: 60),
                                               radius: CGFloat (13),
                                               startAngle: CGFloat(0),
                                               endAngle: CGFloat(Double.pi * 2),
                                               clockwise: true).cgPath
        boundsAnimation.duration = 2.0
        boundsAnimation.repeatCount = .greatestFiniteMagnitude
        boundsAnimation.autoreverses = true
        
        
        let layerWidthAnimation = CABasicAnimation(keyPath: #keyPath(CAShapeLayer.lineWidth))
        layerWidthAnimation.fromValue = 1.0
        layerWidthAnimation.toValue = 2.0
        layerWidthAnimation.duration = 2.0
        layerWidthAnimation.repeatCount = .greatestFiniteMagnitude
        layerWidthAnimation.autoreverses = true
        
        
        //Apply all animations to sublayer
        CATransaction.begin()
        shapeLayer2.add(boundsAnimation, forKey: nil)
        shapeLayer2.add(layerWidthAnimation, forKey: nil)
        CATransaction.commit()
        self.view = view
    }
    
}

// Present the view controller in the Live View window
PlaygroundPage.current.liveView = MyViewController()

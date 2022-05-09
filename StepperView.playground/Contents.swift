//: A UIKit based Playground for presenting user interface
  
import UIKit
import PlaygroundSupport

class MyViewController : UIViewController {
    
    private var quantity: Int = 1
    
    
    override func loadView() {
        let view = UIView()
        view.backgroundColor = .white
        
        let stepperView: StepperCartView = {
            let view = StepperCartView()
            view.translatesAutoresizingMaskIntoConstraints = false
            return view
        }()
        
        let layer = CAShapeLayer()
        layer.path = UIBezierPath(arcCenter: CGPoint(x:60, y: 60),
                                  radius: CGFloat (6),
                                  startAngle: CGFloat(0),
                                  endAngle: CGFloat(Double.pi * 2),
                                  clockwise: true).cgPath
        layer.fillColor = UIColor.blue.cgColor
        view.layer.addSublayer(layer)
        
        let layer2 = CAShapeLayer()
        let circlePath2 = UIBezierPath(arcCenter: CGPoint(x: 60, y: 60),
                                       radius: CGFloat (10 - 0.5),
                                       startAngle: CGFloat(0),
                                       endAngle: CGFloat(Double.pi * 2),
                                       clockwise: true)
        
        layer2.strokeColor = UIColor.blue.cgColor
        layer2.fillColor = UIColor.clear.cgColor
        layer2.lineWidth = 2
        layer2.opacity = 0.3
        
        layer2.path = circlePath2.cgPath
        
        view.layer.addSublayer(layer2)
        
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
        layer2.add(boundsAnimation, forKey: nil)
        layer2.add(layerWidthAnimation, forKey: nil)
        CATransaction.commit()
        
        stepperView.delegate = self
        view.addSubview(stepperView)
        format()
        constraints()
        
        
        func createCirclePath(withSize: CGFloat, withBorder: Bool) -> UIBezierPath {
        let borderSize: CGFloat = withBorder ? 0.5 : 0.0
            return UIBezierPath(arcCenter: CGPoint(x: withSize/2, y: withSize/2),
                                radius: CGFloat( withSize/2  - borderSize),
                                startAngle: CGFloat(0),
                                endAngle: CGFloat(Double.pi * 2),
                                clockwise: true)
    }
        
        func constraints() {
            NSLayoutConstraint.activate([
                stepperView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                stepperView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            ])
        }
        
        func setStepper() {
            stepperView.setMinQuantity(with: 1)
            stepperView.setMaxQuantity(with: 10)
        }
        
        func format() {
            view.backgroundColor = .white

            stepperView.layer.borderWidth = 1.0
            stepperView.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
            stepperView.layer.cornerRadius = 6.0
            stepperView.clipsToBounds = true
            stepperView.disabled = false
        }
        
        self.view = view
    }
}

extension MyViewController : StepperViewDelegate {
    func stepperDidChange() {
        //quantity = stepperView.getCurrentQuantity()
    }
    
    
}


//MARK:- StepperView

protocol StepperViewDelegate : AnyObject {
    func stepperDidChange()
}

public class StepperCartView : UIView {
    weak var delegate: StepperViewDelegate?
    
    //MARK:- PRIVATE PROPERTIES
    
    private enum StepperViewConstants: CGFloat {
        case iconSize = 16.0
        case buttonWidth = 48.0
        case buttonInset = 8.0
    }
    private let stepperStackView : UIStackView = {
        let stackView = UIStackView(frame: .zero)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.spacing = 4
        return stackView
    }()
    
    // Esta view tiene que ser de tipe PressebleView
    private let decrementContainerView : UIView = {
        let view = UIView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let decrementShadowView : UIView = {
        let view = UIView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 6.0
        view.clipsToBounds = true
        return view
    }()
    
    private let decrementButton : UIButton = {
        let button = UIButton(frame: .zero)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    
    private let quantityLabel : UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    
    
    private let incrementContainerView : UIView = {
        let view = UIView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let incrementShadowView : UIView = {
        let view = UIView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 6.0
        view.clipsToBounds = true
        return view
    }()
    
    private let incrementButton : UIButton = {
        let button = UIButton(frame: .zero)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private var currentQuantity = 5 {
        didSet {
            // Set current quantity
            quantityLabel.text = "\(currentQuantity)"
            // Update with current quantity value
            updateWithCurrentQuantity()
        }
    }
    
    private var maxQuantity: Int = 99
    private var minQuantity: Int = 0
    private let disabledColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
    private let touchableColor = #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)
    private let untouchableColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
    
    
    var disabled: Bool = false {
        didSet {
            isUserInteractionEnabled = !disabled
            
            if disabled {
                decrementButton.tintColor = disabledColor
                incrementButton.tintColor = disabledColor
                quantityLabel.textColor = disabledColor
            } else {
                updateWithCurrentQuantity()
            }
        }
    }
    
    //MARK:- INITIS
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    init() {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        quantityLabel.text = "5"
        decrementButton.addTarget(self, action: #selector(self.pressedDecrement), for: .touchUpInside)
        incrementButton.addTarget(self, action: #selector(self.pressedIncrement), for: .touchUpInside)
        setup()
        setupConstraint()
    }
    
    @objc func pressedDecrement() {
        if currentQuantity > minQuantity {
            currentQuantity -= 1
        }
        quantityLabel.text = "\(getCurrentQuantity())"
    }
    
    @objc func pressedIncrement() {
        if currentQuantity < maxQuantity {
            currentQuantity += 1
        }
        quantityLabel.text = "\(getCurrentQuantity())"
    }
    
    // MARK:- SETUP
    func setup() {
        decrementContainerView.addSubview(decrementShadowView)
        decrementShadowView.addSubview(decrementButton)
        incrementContainerView.addSubview(incrementShadowView)
        incrementContainerView.addSubview(incrementButton)
        
        stepperStackView.addArrangedSubview(decrementContainerView)
        stepperStackView.addArrangedSubview(incrementContainerView)
        
        addSubview(stepperStackView)
        addSubview(quantityLabel)
    }
    
    // MARK:- CONSTRAINSTS
    
    func setupConstraint() {
        NSLayoutConstraint.activate([
            stepperStackView.topAnchor.constraint(equalTo: topAnchor),
            stepperStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stepperStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stepperStackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            quantityLabel.topAnchor.constraint(equalTo: stepperStackView.topAnchor),
            quantityLabel.leadingAnchor.constraint(equalTo: stepperStackView.leadingAnchor),
            quantityLabel.trailingAnchor.constraint(equalTo: stepperStackView.trailingAnchor),
            quantityLabel.bottomAnchor.constraint(equalTo: stepperStackView.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            decrementContainerView.widthAnchor.constraint(equalToConstant: StepperViewConstants.buttonWidth.rawValue),
            decrementContainerView.heightAnchor.constraint(equalToConstant: StepperViewConstants.buttonWidth.rawValue),
        ])
        
        NSLayoutConstraint.activate([
            incrementContainerView.widthAnchor.constraint(equalToConstant: StepperViewConstants.buttonWidth.rawValue),
            incrementContainerView.heightAnchor.constraint(equalToConstant: StepperViewConstants.buttonWidth.rawValue),
        ])
        
        NSLayoutConstraint.activate([
            decrementButton.widthAnchor.constraint(equalToConstant: StepperViewConstants.iconSize.rawValue),
            decrementButton.heightAnchor.constraint(equalToConstant: StepperViewConstants.iconSize.rawValue),
            decrementButton.centerYAnchor.constraint(equalTo: decrementContainerView.centerYAnchor),
            decrementButton.centerXAnchor.constraint(equalTo: decrementContainerView.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            incrementButton.widthAnchor.constraint(equalToConstant: StepperViewConstants.iconSize.rawValue),
            incrementButton.heightAnchor.constraint(equalToConstant: StepperViewConstants.iconSize.rawValue),
            incrementButton.centerYAnchor.constraint(equalTo: incrementContainerView.centerYAnchor),
            incrementButton.centerXAnchor.constraint(equalTo: incrementContainerView.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            decrementShadowView.topAnchor.constraint(equalTo: decrementContainerView.topAnchor, constant: StepperViewConstants.buttonInset.rawValue),
            decrementShadowView.rightAnchor.constraint(equalTo: decrementContainerView.rightAnchor, constant: -StepperViewConstants.buttonInset.rawValue),
            decrementShadowView.bottomAnchor.constraint(equalTo: decrementContainerView.bottomAnchor, constant: -StepperViewConstants.buttonInset.rawValue),
            decrementShadowView.leftAnchor.constraint(equalTo: decrementContainerView.leftAnchor, constant: StepperViewConstants.buttonInset.rawValue),
        ])
        
        NSLayoutConstraint.activate([
            incrementShadowView.topAnchor.constraint(equalTo: incrementContainerView.topAnchor, constant: StepperViewConstants.buttonInset.rawValue),
            incrementShadowView.rightAnchor.constraint(equalTo: incrementContainerView.rightAnchor, constant: -StepperViewConstants.buttonInset.rawValue),
            incrementShadowView.bottomAnchor.constraint(equalTo: incrementContainerView.bottomAnchor, constant: -StepperViewConstants.buttonInset.rawValue),
            incrementShadowView.leftAnchor.constraint(equalTo: incrementContainerView.leftAnchor, constant: StepperViewConstants.buttonInset.rawValue),
        ])
    }
        // MARK: - FUNCTIONS
        
        func setMaxQuantity(with value: Int) {
            maxQuantity = value
        }
        
        func setMinQuantity(with value: Int) {
            minQuantity = value
            currentQuantity = value
        }
        
        func getCurrentQuantity() -> Int {
            return currentQuantity
        }
        
        func disableIncrement() {
            incrementButton.isUserInteractionEnabled = false
            incrementButton.backgroundColor = untouchableColor
        }
        
        func enableIncrement() {
            incrementButton.isUserInteractionEnabled = true
            incrementButton.backgroundColor = touchableColor
        }
        func disableDecrement() {
            decrementButton.isUserInteractionEnabled = false
            decrementButton.backgroundColor = untouchableColor
        }
        
        func enableDecrement() {
            decrementButton.isUserInteractionEnabled = true
            decrementButton.backgroundColor = touchableColor
        }
    
        private func decrementQuantity() {
            if currentQuantity > minQuantity {
                currentQuantity -= 1
            }
            delegate?.stepperDidChange()
        }
    
        private func incrementQuantity() {
            if currentQuantity < maxQuantity {
                currentQuantity += 1
            }
            delegate?.stepperDidChange()
        }
    
        private func updateWithCurrentQuantity() {
            quantityLabel.textColor = .black
            quantityLabel.isHidden = currentQuantity == 0
            // Disable or enable increment based on current quantity and max quantity
            currentQuantity == minQuantity ? disableDecrement() : enableDecrement()
            currentQuantity == maxQuantity ? disableIncrement() : enableIncrement()
        }
    
}

// Present the view controller in the Live View window
PlaygroundPage.current.liveView = MyViewController()

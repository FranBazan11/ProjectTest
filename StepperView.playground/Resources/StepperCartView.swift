import Foundation
import UIKit

protocol StepperViewDelegate {
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
        stackView.spacing = 12
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
        view.tintColor = .red
        return view
    }()
    
    private let decrementImageView : UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
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
        view.tintColor = .green
        return view
    }()
    
    private let incrementImageView : UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private var currentQuantity = 0 {
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
                decrementImageView.tintColor = disabledColor
                incrementImageView.tintColor = disabledColor
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
        setup()
        setupConstraint()
    }
    
    
    // MARK:- SETUP
    func setup() {
        decrementContainerView.addSubview(decrementShadowView)
        decrementShadowView.addSubview(decrementImageView)
        incrementContainerView.addSubview(incrementShadowView)
        incrementContainerView.addSubview(incrementImageView)
        
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
            quantityLabel.topAnchor.constraint(equalTo: topAnchor),
            quantityLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            quantityLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            quantityLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            decrementContainerView.widthAnchor.constraint(equalToConstant: StepperViewConstants.buttonWidth.rawValue),
        ])
        
        NSLayoutConstraint.activate([
            incrementContainerView.widthAnchor.constraint(equalToConstant: StepperViewConstants.buttonWidth.rawValue),
        ])
        
        NSLayoutConstraint.activate([
            decrementImageView.widthAnchor.constraint(equalToConstant: StepperViewConstants.iconSize.rawValue),
            decrementImageView.heightAnchor.constraint(equalToConstant: StepperViewConstants.iconSize.rawValue),
            decrementImageView.centerYAnchor.constraint(equalTo: decrementContainerView.centerYAnchor),
            decrementImageView.centerXAnchor.constraint(equalTo: decrementContainerView.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            incrementImageView.widthAnchor.constraint(equalToConstant: StepperViewConstants.iconSize.rawValue),
            incrementImageView.heightAnchor.constraint(equalToConstant: StepperViewConstants.iconSize.rawValue),
            incrementImageView.centerYAnchor.constraint(equalTo: incrementContainerView.centerYAnchor),
            incrementImageView.centerXAnchor.constraint(equalTo: incrementContainerView.centerXAnchor)
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
            incrementImageView.isUserInteractionEnabled = false
            incrementImageView.tintColor = untouchableColor
        }
        
        func enableIncrement() {
            incrementImageView.isUserInteractionEnabled = true
            incrementImageView.tintColor = touchableColor
        }
        func disableDecrement() {
            decrementImageView.isUserInteractionEnabled = false
            decrementImageView.tintColor = untouchableColor
        }
        
        func enableDecrement() {
            decrementImageView.isUserInteractionEnabled = true
            decrementImageView.tintColor = touchableColor
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
            //        // Disable or enable increment based on current quantity and max quantity
            currentQuantity == minQuantity ? disableDecrement() : enableDecrement()
            currentQuantity == maxQuantity ? disableIncrement() : enableIncrement()
        }
    
}

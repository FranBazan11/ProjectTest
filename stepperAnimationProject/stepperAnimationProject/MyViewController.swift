//
//  MyViewController.swift
//  stepperAnimationProject
//
//  Created by Juan Francisco Bazan Carrizo on 25/03/2022.
//

import UIKit

class MyViewController: UIViewController {
    let stepper = TimelineStepper()
    let myStepperPancho = MyTimelineStepper()
    
    let myView = UIView()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        myView.backgroundColor = .red
        view = myView
        
        
        myView.addSubview(stepper)
        myView.addSubview(myStepperPancho)
        
        NSLayoutConstraint.activate([
            stepper.centerXAnchor.constraint(equalTo: myView.centerXAnchor),
            stepper.centerYAnchor.constraint(equalTo: myView.centerYAnchor),
        ])
        
        NSLayoutConstraint.activate([
            myStepperPancho.centerXAnchor.constraint(equalTo: myView.centerXAnchor),
            myStepperPancho.topAnchor.constraint(equalTo: stepper.bottomAnchor, constant: 20),
        ])
        
        stepper.update()
        myStepperPancho.update()
    }
}

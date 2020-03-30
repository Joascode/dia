//
//  ViewController.swift
//  workshop-rxswift
//
//  Created by Joas Kramer on 13/03/2019.
//  Copyright © 2019 Joas Kramer. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {
    
    // @IBOutlet weak var counterLabel: UILabel!
    private var counter = Variable(0)
    private var disposeBag = DisposeBag()
    @IBOutlet weak var counterLabel: UILabel!
    @IBOutlet weak var switcher: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        counter
            .asObservable()
            .throttle(1, scheduler: MainScheduler.instance)
            .map({
                value in
                return "New value: \(value)"
            })
            .subscribe(onNext: {[unowned self]
                value in
                self.counterLabel.text = value
                print(value)
        }).disposed(by: disposeBag)
        
        switcher.rx.isOn.changed
            .asObservable()
            .filter({
                value in
                return value == true
            })
            .subscribe(onNext: {
                value in
                print(value)
        }).disposed(by: disposeBag)
    }
    @IBAction func decrementButton(_ sender: UIButton) {
        self.counter.value = self.counter.value - 1
        // self.counterLabel.text = String(counter)
    }
    @IBAction func incrementButton(_ sender: UIButton) {
        self.counter.value = self.counter.value + 1
        // self.counterLabel.text = String(counter)
    }
}


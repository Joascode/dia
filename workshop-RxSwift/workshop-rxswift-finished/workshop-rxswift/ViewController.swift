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

    @IBOutlet weak var counterLabel: UILabel!
    // private var counter = 0
    var counter = Variable(0)
    @IBOutlet weak var switcher: UISwitch!
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up observable on counter, to update the textfield when counter value changes.
        // Throttles, so that the textfield only gets updated every 2 seconds.
        // Map transforms the integer of counter to a text to show in the textfield.
        counter
            .asObservable()
            .throttle(2, scheduler: MainScheduler.instance)
            .map({ value in
                return "New value: \(value)"
            })
            .subscribe(onNext: {[unowned self] value in
                // self.counterLabel.text = value
                self.counterLabel.text = String(value)
                print(value)
            }).disposed(by: disposeBag)
        
        // Listens on the isOn value changes and filters only the true isOn values to the subscribe.
        switcher.rx.isOn.changed.asObservable().filter({ active in active == true }).subscribe(onNext: { (active) in
            print(active)
        }).disposed(by: disposeBag)
    }

    @IBAction func incrementButton(_ sender: UIButton) {
        // self.counter = self.counter + 1
        self.counter.value = self.counter.value + 1
        // self.counterLabel.text = String(self.counter)
    }
    
    @IBAction func decrementButton(_ sender: UIButton) {
        // self.counter = self.counter - 1
        self.counter.value = self.counter.value - 1
        // self.counterLabel.text = String(self.counter)
    }
}


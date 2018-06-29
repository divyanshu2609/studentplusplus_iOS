//
//  ViewController.swift
//  BullsEye
//
//  Created by Divyanshu Goel on 04/06/18.
//  Copyright © 2018 Divyanshu Goel. All rights reserved.
//

import UIKit
import QuartzCore

class ViewController: UIViewController {
    var currentValue: Int = 0
    var targetValue: Int = 0
    var roundCount: Int = 0
    var score: Int = 0
    
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var randomLabel: UILabel!
    @IBOutlet weak var roundLabel: UILabel!
    
    @IBOutlet weak var scoreLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let thumbImageNormal = UIImage(named: "SliderThumb-Normal")
        slider.setThumbImage(thumbImageNormal, for: .normal)
        
        let thumbImageHighlighted = UIImage(named: "SliderThumb-Highlighted")
        slider.setThumbImage(thumbImageHighlighted, for: .highlighted)
        
        let insets = UIEdgeInsets(top: 0, left: 14, bottom: 0, right: 14)
        
        if let trackLeftImage = UIImage(named: "SliderTrackLeft") {
            let trackLeftResizable = trackLeftImage.resizableImage(withCapInsets: insets)
            slider.setMinimumTrackImage(trackLeftResizable, for: .normal)
        }
        
        if let trackRightImage = UIImage(named: "SliderTrackRight") {
            let trackRightResizable = trackRightImage.resizableImage(withCapInsets: insets)
            slider.setMaximumTrackImage(trackRightResizable, for: .normal)
            
        }
        self.startNewGame()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func hitMeButtonPressed(_ sender: UIButton) {
        let difference = abs(self.targetValue - self.currentValue)
        let currentScore = 100 - difference
        
        self.score += currentScore
        let message = "The value of the slider is : \(currentValue) and your score is \(currentScore)"
        
        let alert = UIAlertController(title: "Hello World", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default, handler:
        {
            action in
            self.startNewRound()
        })
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func sliderMoved(_ slider: UISlider) {
        self.currentValue = lroundf(slider.value)
    }
    
    
    @IBAction func startOverButtonPressed(_ sender: UIButton) {
        self.startNewGame()
        
        let transition = CATransition()
        transition.type = kCATransitionFade
        transition.duration = 1
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        view.layer.add(transition, forKey: nil)
    }
    
    func startNewRound(){
        self.roundCount += 1
        self.targetValue = 1 + Int(arc4random_uniform(100))
        self.currentValue = 50;
        self.updateSlider()
        self.updateLabels()
    }
    
    func updateSlider(){
        self.slider.value = Float(self.currentValue)
    }
    
    func updateLabels(){
        self.randomLabel.text = "\(self.targetValue)"
        self.roundLabel.text = "\(self.roundCount)"
        self.scoreLabel.text = "\(self.score)"
    }
    
    func startNewGame(){
        self.roundCount = 0
        self.score = 0
        self.startNewRound()
    }
    
}


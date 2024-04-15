import UIKit

class TimerViewController: UIViewController {

    @IBOutlet weak var timerLabel: UILabel!
    
    @IBOutlet weak var startButton: UIButton!
    
    @IBOutlet weak var stopButton: UIButton!
    
    @IBOutlet weak var durationStepper: UIStepper!
    
    @IBOutlet weak var durationLabel: UILabel!
    
    var timer: Timer?
    var seconds = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateTimerLabel()
        stopButton.isEnabled = false
        updateDurationLabel()
    }
    
    @IBAction func startButtonTapped(_ sender: UIButton) {
        seconds = Int(durationStepper.value)
        startTimer()
        startButton.isEnabled = false
        stopButton.isEnabled = true
    }
    
    @IBAction func stopButtonTapped(_ sender: UIButton) {
        stopTimer()
        startButton.isEnabled = true
        stopButton.isEnabled = false
    }
    
    @IBAction func durationStepperValueChanged(_ sender: UIStepper) {
        updateDurationLabel()
    }
    
    func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            self.seconds -= 1
            self.updateTimerLabel()
            
            if self.seconds <= 0 {
                self.stopTimer()
                self.showAlert()
            }
        }
    }
    
    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    func updateTimerLabel() {
        let minutes = seconds / 60
        let remainingSeconds = seconds % 60
        timerLabel.text = String(format: "%02d:%02d", minutes, remainingSeconds)
    }
    
    func updateDurationLabel() {
        let duration = Int(durationStepper.value)
        durationLabel.text = "\(duration) seconds"
    }
    
    func showAlert() {
        let alert = UIAlertController(title: "Timer Finished", message: "The timer has finished.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

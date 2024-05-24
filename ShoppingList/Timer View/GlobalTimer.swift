import Foundation

// Этот файл содержит реализацию класса `InStoreTimer`, который представляет собой таймер для отслеживания времени в приложении списка покупок. Он может быть запущен, приостановлен и остановлен, а также предоставляет возможность сброса накопленного времени.

// Класс также учитывает различные состояния таймера, такие как запущен, приостановлен и остановлен, и обновляет накопленное время в реальном времени.

let kDisableTimerWhenAppIsNotActive = false

class InStoreTimer: ObservableObject {
    private enum SLTimerMode {
        case stopped
        case running
        case suspended
    }
    
    private weak var timer: Timer? = nil
    private var previouslyAccumulatedTime: TimeInterval = 0
    private var startDate: Date? = nil
    private var lastStopDate: Date? = nil
    private var state: SLTimerMode = .stopped
            
    @Published var totalAccumulatedTime: TimeInterval = 0

    var isSuspended: Bool { return state == .suspended }
    var isRunning: Bool { return state == .running }
    var isStopped: Bool { return state == .stopped }

    private func shutdownTimer() {
        let accumulatedRunningTime = Date().timeIntervalSince(startDate!)
        previouslyAccumulatedTime += accumulatedRunningTime
        totalAccumulatedTime = previouslyAccumulatedTime

        lastStopDate = Date()
        timer!.invalidate()
        timer = nil
    }
    
    func suspend() {
        if state == .running {
            shutdownTimer()
            state = .suspended
        }
    }
    
    func start() {
        if state != .running {
            startDate = Date()
            if state == .suspended && !kDisableTimerWhenAppIsNotActive {
                startDate = lastStopDate
            }
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: (#selector(update)), userInfo: nil, repeats: true)
            state = .running
        }
    }
    
    func stop() {
        if state == .running {
            shutdownTimer()
            state = .stopped
        }
    }
    
    @objc private func update() {
        totalAccumulatedTime = previouslyAccumulatedTime + Date().timeIntervalSince(startDate!)
    }
    
    func reset() {
        guard state == .stopped else { return }
        previouslyAccumulatedTime = 0
        totalAccumulatedTime = 0
    }
    
}

var gInStoreTimer = InStoreTimer()

import Foundation

public class Timer {
	let queue: DispatchQueue
	let timer: DispatchSourceTimer

	public let period: DispatchTimeInterval

	var eventHandlers: [(tag: Int, eventHandler: () -> Void)]

	public init(period: DispatchTimeInterval) {
		self.period = period
		queue = DispatchQueue(label: "waveTimer")
		timer = DispatchSource.makeTimerSource(queue: queue)
		timer.scheduleRepeating(deadline: .now(), interval: period)
		eventHandlers = []
		timer.setEventHandler(handler: performEventHandlers)
	}

	public func startTimer() {
		timer.resume()
	}

	func pauseTimer() {
		timer.suspend()
	}

	func add(eventHandler: @escaping () -> Void, withTag tag: Int) {
		queue.async { [unowned self] in
			self.eventHandlers.append((tag: tag, eventHandler: eventHandler))
		}
	}

	func remove(eventHandlerWithTag tag: Int) {
		queue.async { [unowned self] in
			self.eventHandlers = self.eventHandlers.filter { $0.tag != tag }
		}
	}

	func performEventHandlers() {
		for eventHandler in eventHandlers {
			eventHandler.eventHandler()
		}
	}
}

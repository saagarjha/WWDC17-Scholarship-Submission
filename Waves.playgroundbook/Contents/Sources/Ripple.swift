import Foundation

public class Ripple {
	static let duration = 10
	static let tickSize = DispatchTimeInterval.milliseconds(100)
	static var tag = 0

	static var circles = [Int: [Point]]()

	let waveGrid: WaveGrid
	let timer: Timer
	let row: Int
	let column: Int
	var tick: Int
	var tag: Int

	public init(waveGrid: WaveGrid, timer: Timer, row: Int, column: Int) {
		self.waveGrid = waveGrid
		self.timer = timer
		self.row = row
		self.column = column
		tick = 1
		tag = Ripple.tag
		Ripple.tag += 1
		timer.add(eventHandler: animate, withTag: tag)
	}

	func animate() {
		DispatchQueue.main.async { [weak self] in
			guard let s = self else {
				(self?.tag as Int?).map { self?.timer.remove(eventHandlerWithTag: $0) }
				return
			}
			defer {
				s.tick += 1
			}

			let normalizedTick = s.tick / Int(Ripple.tickSize.value / s.timer.period.value)

			guard normalizedTick <= Ripple.duration else {
				s.timer.remove(eventHandlerWithTag: s.tag)
				return
			}

			guard s.tick % Int(Ripple.tickSize.value / s.timer.period.value) == 0 else {
				return
			}
			for point in Ripple.circleWithRadius(normalizedTick - 2) {
				s.waveGrid.waveTileViews[reflecting: s.row + point.x][reflecting: s.column + point.y].depth += Ripple.duration - normalizedTick + 1
			}
			for point in Ripple.circleWithRadius(normalizedTick - 1) {
				s.waveGrid.waveTileViews[reflecting: s.row + point.x][reflecting: s.column + point.y].depth -= Ripple.duration - normalizedTick + 1
				s.waveGrid.waveTileViews[reflecting: s.row + point.x][reflecting: s.column + point.y].depth -= Ripple.duration - normalizedTick
			}
			for point in Ripple.circleWithRadius(normalizedTick) {
				s.waveGrid.waveTileViews[reflecting: s.row + point.x][reflecting: s.column + point.y].depth += Ripple.duration - normalizedTick
			}
		}
	}

	static func circleWithRadius(_ radius: Int) -> [Point] {
		if let circle = Ripple.circles[radius] {
			return circle
		} else {
			let circle = calculateCircleWithRadius(radius)
			Ripple.circles[radius] = circle
			return circle
		}
	}

	static func calculateCircleWithRadius(_ radius: Int) -> [Point] {
		var points = [Point]()
		var x = radius
		var y = 0
		var decision = 0
		while (y < x) {
			points.append(contentsOf: [
				Point(x: x, y: y),
				Point(x: y, y: x),
				Point(x: -x, y: y),
				Point(x: -y, y: x),
				Point(x: x, y: -y),
				Point(x: y, y: -x),
				Point(x: -x, y: -y),
				Point(x: -y, y: -x),
			])
			y += 1
			if (decision <= 0) {
				decision += 2 * y + 1
			} else {
				x -= 1
				decision += 2 * (y - x) + 1
			}
		}
		return Array(Set<Point>(points))
	}

	struct Point: Hashable {
		let x: Int
		let y: Int

		var hashValue: Int {
			return x ^ y
		}

		static func == (lhs: Point, rhs: Point) -> Bool {
			return lhs.x == rhs.x && lhs.y == rhs.y
		}
	}
}

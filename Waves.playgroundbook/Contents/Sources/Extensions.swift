import Foundation

public extension Array {
	subscript(reflecting index: Index) -> Element {
		var index = index
		if index < startIndex {
			index = -index
		}
		index = index % (2 * (count - 1))
		if count - 1 < index {
			index = 2 * count - index - 1
		}
		return self[index]
	}
}

extension DispatchTimeInterval {
	var value: UInt64 {
		switch self {
		case .seconds(let s): return UInt64(s) * NSEC_PER_SEC
		case .milliseconds(let ms): return UInt64(ms) * NSEC_PER_MSEC
		case .microseconds(let µs): return UInt64(µs) * NSEC_PER_USEC
		case .nanoseconds(let ns): return UInt64(ns)
		}
	}
}

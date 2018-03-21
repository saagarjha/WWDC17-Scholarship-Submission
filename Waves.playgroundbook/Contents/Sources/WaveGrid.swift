import UIKit

public class WaveGrid: TouchListener {
	public let gridView: GridView
	public let waveTileViews: [[WaveTileView]]

	var timer: Timer

	public init?(rows: Int, columns: Int, maxSize: CGFloat, timer: Timer) {
		self.timer = timer
		guard let gv = GridView(rows: rows, columns: columns) else {
			return nil
		}
		waveTileViews =
			(0..<rows).map { row in
				(0..<columns).map { column in
					let waveTileView = WaveTileView(maxDepth: 32, maxSize: maxSize)
					gv.add(view: waveTileView, atRow: row, column: column)
					return waveTileView
				}
		}
		gridView = gv
		gridView.backgroundColor = .white
		gridView.tapLister = self
	}

	public func addTo(view containerView: UIView, with size: CGSize) {
		containerView.addSubview(gridView)
		gridView.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([NSLayoutConstraint(item: gridView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 0, constant: size.height), NSLayoutConstraint(item: gridView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 0, constant: size.width)])
		NSLayoutConstraint.activate([NSLayoutConstraint(item: containerView, attribute: .centerX, relatedBy: .equal, toItem: gridView, attribute: .centerX, multiplier: 1, constant: 0), NSLayoutConstraint(item: containerView, attribute: .centerY, relatedBy: .equal, toItem: gridView, attribute: .centerY, multiplier: 1, constant: 0)])
	}

	func touched(row: Int, column: Int) {
		_ = Ripple(waveGrid: self, timer: timer, row: row, column: column)
	}
}

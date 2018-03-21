import UIKit

public class GridView: UIView {
	let rows: Int
	let columns: Int

	let backgroundViews: [[UIView]]

	var gridViews: [[UIView?]]

	var tapLister: TouchListener?

	public init?(rows: Int, columns: Int) {
		guard 1 < rows, 1 < columns else {
			return nil
		}
		self.rows = rows
		self.columns = columns
		backgroundViews = (0..<rows).map { _ in (0..<columns).map { _ in UIView() } }
		gridViews = Array(repeating: Array(repeating: nil, count: columns), count: rows)
		super.init(frame: .zero)
		var constraints = [NSLayoutConstraint]()
		for row in backgroundViews.startIndex..<backgroundViews.endIndex {
			for column in backgroundViews[row].startIndex..<backgroundViews[row].endIndex {
				let view = backgroundViews[row][column]
				view.translatesAutoresizingMaskIntoConstraints = false
				self.addSubview(view)
				if row == rows - 1 {
					constraints.append(NSLayoutConstraint(item: view, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0))
				} else {
					if row == 0 {
						constraints.append(NSLayoutConstraint(item: view, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0))
					}
					constraints.append(NSLayoutConstraint(item: view, attribute: .bottom, relatedBy: .equal, toItem: backgroundViews[row + 1][column], attribute: .top, multiplier: 1, constant: 0))
				}
				if column == columns - 1 {
					constraints.append(NSLayoutConstraint(item: view, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: 0))
				} else {
					if column == 0 {
						constraints.append(NSLayoutConstraint(item: view, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 0))
					}
					constraints.append(NSLayoutConstraint(item: view, attribute: .trailing, relatedBy: .equal, toItem: backgroundViews[row][column + 1], attribute: .leading, multiplier: 1, constant: 0))
				}
				if row != 0 || column != 0 {
					constraints.append(NSLayoutConstraint(item: view, attribute: .width, relatedBy: .equal, toItem: backgroundViews[0][0], attribute: .width, multiplier: 1, constant: 0))
					constraints.append(NSLayoutConstraint(item: view, attribute: .height, relatedBy: .equal, toItem: backgroundViews[0][0], attribute: .height, multiplier: 1, constant: 0))

				}
			}
		}
		NSLayoutConstraint.activate(constraints)
	}

	public func add(view: UIView, atRow row: Int, column: Int) {
		gridViews[row][column]?.removeFromSuperview()
		gridViews[row][column] = view
		self.addSubview(view)
		let backgroundView = backgroundViews[row][column]
		let constraints = [NSLayoutConstraint(item: view, attribute: .centerX, relatedBy: .equal, toItem: backgroundView, attribute: .centerX, multiplier: 1, constant: 0), NSLayoutConstraint(item: view, attribute: .centerY, relatedBy: .equal, toItem: backgroundView, attribute: .centerY, multiplier: 1, constant: 0)]
		NSLayoutConstraint.activate(constraints)
	}

	public required init?(coder aDecoder: NSCoder) {
		rows = 0
		columns = 0
		backgroundViews = [[]]
		gridViews = [[]]
		super.init(coder: aDecoder)
	}

	override public func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		handleTouches(touches)
	}

	override public func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
		handleTouches(touches)
	}

	func handleTouches(_ touches: Set<UITouch>) {
		for touch in touches {
			let location = touch.location(in: self)
			tapLister?.touched(row: Int(location.y * CGFloat(rows) / frame.width), column: Int(location.x * CGFloat(columns) / frame.width))
		}
	}
}

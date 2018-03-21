import UIKit

public class WaveTileView: UIView {
	let maxDepth: Int
	let maxSize: CGFloat

	public var depth: Int = 0 {
		didSet {
			let ratio = CGFloat(depth) / CGFloat(maxDepth)
			backgroundColor = UIColor(red: 1 - ratio, green: 1 - ratio, blue: 1, alpha: 1)
			sizeConstraint.constant = ratio * maxSize
			layer.cornerRadius = ratio * maxSize / 2
		}
	}

	var sizeConstraint: NSLayoutConstraint!

	public init(maxDepth: Int, maxSize: CGFloat) {
		self.maxDepth = maxDepth
		self.maxSize = maxSize
		super.init(frame: .zero)
		translatesAutoresizingMaskIntoConstraints = false
		sizeConstraint = NSLayoutConstraint(item: self, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: maxSize / 2)
		NSLayoutConstraint.activate([NSLayoutConstraint(item: self, attribute: .width, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 1, constant: 0), sizeConstraint])
		defer {
			depth = maxDepth / 2
		}
	}

	public required init?(coder aDecoder: NSCoder) {
		maxDepth = 0
		maxSize = 0
		super.init(coder: aDecoder)
	}
}

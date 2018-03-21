//#-hidden-code
import PlaygroundSupport
import UIKit
//#-end-hidden-code
/*:
# Waves
*Written for WWDC 2017 by Saagar Jha*

## Introduction
Hello!

Welcome to Waves!

Waves is a wave simimulator written primarly with UIKit and Grand Central Dispatch. Let's try it out–tap "Run My Code" on the bottom right to get started.

- Note:
Before we really get started, you might have to deal with the settings below (sigh…)
The constants below control the size of the live view. Since there doesn't appear to be a way to get the size of the live view beforehand ([Radar 31394871](rdar://problem/31394871)), so if you find that the live view is being cut off or is performing rather slowly you'll need to adjust these by hand. I've tried to choose constants that work well, so it *should* just work. Run the playground and tap around, and leave them alone if it runs fine.

*/
//#-hidden-code

let containerView = UIView()

//#-end-hidden-code
//: This is the size of the frame; adjust this if the live view is too small or too large
let waveFrameSize: CGFloat = /*#-editable-code*/500/*#-end-editable-code*/
//: This is the number of "dots" on each side; if you find the program is not performing well you can decrease this value
let waveSize: Int = /*#-editable-code*/25/*#-end-editable-code*/
//#-hidden-code
/*:
If you've gotten throught the setup, great! We can get started on the fun stuff now.

The live view on the right is a *wave simulator*–you can think of it as a pool of water to interact with. You've probably already tried tapping on it–it should create a circular wave radiating out from where you touched. But that's not all you can do! Waves can simulate other properties as well, such as:
* [Transmission](https://en.wikipedia.org/wiki/Rectilinear_propagation): Waves travel out from the source
* [Absorbtion](https://en.wikipedia.org/wiki/Absorption_(electromagnetic_radiation)): Waves slowly decrease in amplitude as the move
* [Interference](https://en.wikipedia.org/wiki/Interference_(wave_propagation)): Try getting two waves to intersect; they will interfere with each other.
* [Reflection](https://en.wikipedia.org/wiki/Reflection_(physics)): Waves bounce off of walls

It does this by simulating the "disturbance" for each position. Each of the circles on the right represents the value at that position; a smaller, lighter circle is a "negative disturbance" and a larger, darker one is a "positive one".
*/
let waveTileSize = waveFrameSize / CGFloat(waveSize)

let timerPeriod = DispatchTimeInterval.milliseconds(10)
let timer = Timer(period: timerPeriod)

guard let waveGrid = WaveGrid(rows: waveSize, columns: waveSize, maxSize: waveTileSize, timer: timer) else {
	PlaygroundPage.current.finishExecution()
}

let size = CGSize(width: CGFloat(waveSize) * waveTileSize, height: CGFloat(waveSize) * waveTileSize)
containerView.frame = CGRect(origin: .zero, size: size)
waveGrid.addTo(view: containerView, with: size)

PlaygroundPage.current.liveView = containerView

timer.startTimer()

//#-end-hidden-code
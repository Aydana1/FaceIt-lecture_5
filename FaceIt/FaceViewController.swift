//
//  ViewController.swift
//  FaceIt
//
//  Created by Michel Deiman on 16/05/16.
//  Copyright © 2016 Michel Deiman. All rights reserved.
//

import UIKit

class FaceViewController: UIViewController
{
	
	private var expression = FacialExpression(eyes: .Open, eyeBrows: .Normal, mouth: .Frown ) {
		didSet {
			updateUI()
		}
	}
	
	@IBOutlet private weak var faceView: FaceView! {
		didSet {
			faceView.addGestureRecognizer(UIPinchGestureRecognizer(
				target: faceView,
				action: #selector(faceView.changeScale(_:))
			))
			let happierSwipeGestureRecognizer = UISwipeGestureRecognizer(
				target: self,
				action:#selector(FaceViewController.increaseHappiness)
			)
			happierSwipeGestureRecognizer.direction = .Down
			faceView.addGestureRecognizer(happierSwipeGestureRecognizer)
			let sadderSwipeGestureRecognizer = UISwipeGestureRecognizer(
				target: self,
				action:#selector(FaceViewController.decreaseHappiness)
			)
			sadderSwipeGestureRecognizer.direction = .Up
			faceView.addGestureRecognizer(sadderSwipeGestureRecognizer)
			updateUI()
		}
	}
	
	func increaseHappiness() {
		expression.mouth = expression.mouth.happierMouth()
	}
	
	func decreaseHappiness() {
		expression.mouth = expression.mouth.sadderMouth()
	}
	
	@IBAction func toggleEyes(recognizer: UITapGestureRecognizer) {
		if recognizer.state == .Ended {
			switch expression.eyes {
			case .Open: expression.eyes = .Closed
			case .Closed: expression.eyes = .Open
			case .Squinting: break
			}
		}
	}
	
	@IBAction func changeBrows(recognizer: UIRotationGestureRecognizer) {
		let minimumRotationForChangeBrows: CGFloat = 0.1
		guard abs(recognizer.rotation) > minimumRotationForChangeBrows else { return }
		switch recognizer.state {
		case .Changed, .Ended:
			if recognizer.rotation > 0 {
				expression.eyeBrows = expression.eyeBrows.moreRelaxedBrow()
			} else {
				expression.eyeBrows = expression.eyeBrows.moreFurrowedBrow()
			}
			recognizer.rotation = 0.0
		default: break
		}
	}
	
	
	private let mouthCurvatures: [FacialExpression.Mouth : Double] =
		[.Frown: -1.0, .Grin: 0.5, .Smile: 1.0, .Smirk: -0.5, .Neutral: 0.0 ]
	
	private var eyeBrowTilts: [FacialExpression.EyeBrows : Double] =
		[.Relaxed: 0.5, .Furrowed: -0.5, .Normal: 0.0]
	
	private func updateUI() {
		switch expression.eyes {
		case .Open: 	faceView.eyesOpen = true
		case .Closed: 	faceView.eyesOpen = false
		case .Squinting:faceView.eyesOpen = false
		}
		faceView.mouthCurvature = mouthCurvatures[expression.mouth] ?? 0.0
		faceView.eyeBrowTilt = eyeBrowTilts[expression.eyeBrows] ?? 0.0
	}



}


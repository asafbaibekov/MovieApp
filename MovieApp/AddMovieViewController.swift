//
//  AddMovieViewController.swift
//  MovieApp
//
//  Created by Asaf Baibekov on 08/04/2019.
//  Copyright © 2019 Asaf Baibekov. All rights reserved.
//

import UIKit
import AVFoundation

class AddMovieViewController: UIViewController {

	let deviceDiscoverySession = AVCaptureDevice.DiscoverySession(
		deviceTypes: [.builtInDualCamera],
		mediaType: AVMediaType.video,
		position: .back
	)
	var captureSession = AVCaptureSession()

	@IBOutlet weak var qrView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
		captureSession = AVCaptureSession()
		if let videoCaptureDevice = AVCaptureDevice.default(for: .video),
			let videoInput = try? AVCaptureDeviceInput(device: videoCaptureDevice) {
			let metadataOutput = AVCaptureMetadataOutput()
			captureSession.addInput(videoInput)
			captureSession.addOutput(metadataOutput)
			metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
			metadataOutput.metadataObjectTypes = [.qr]
			captureSession.startRunning()
		} else {
			failed(title: "Scanning not supported", message: "Your device does not support scanning a code from an item. Please use a device with a camera.") { (_) in
				self.navigationController?.popViewController(animated: true)
			}
		}
    }
	
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		if captureSession.isRunning {
			let videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
			videoPreviewLayer.frame = qrView.layer.bounds
			videoPreviewLayer.videoGravity = .resizeAspectFill
			qrView.layer.addSublayer(videoPreviewLayer)
			qrView.layer.cornerRadius = min(qrView.bounds.height/4, qrView.bounds.width/4)
			qrView.layer.masksToBounds = true
		}
	}
	
	func failed(title: String, message: String, handler: ((UIAlertAction) -> Void)? = nil) {
		let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
		alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: handler))
		present(alertController, animated: true)
	}
}

extension AddMovieViewController: AVCaptureMetadataOutputObjectsDelegate {
	func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
		captureSession.stopRunning()
		guard let metadataObject = metadataObjects.first,
			let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject,
			let stringValue = readableObject.stringValue else {
				self.navigationController?.popViewController(animated: true)
				return
		}
		AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
		if let data = stringValue.data(using: .utf8),
			let json = try? JSONSerialization.jsonObject(with: data, options: [.allowFragments]) as? [String: Any],
			let title = json["title"] as? String,
			let image = json["image"] as? String,
			let imageURL = URL(string: image),
			let rating = json["rating"] as? Double,
			let releaseYear = json["releaseYear"] as? Int16,
			let genre = json["genre"] as? [String] {
			MovieCoreDataHandler.saveObeject(title: title, image: imageURL, rating: rating, releaseYear: releaseYear, genre: genre)
			self.navigationController?.popViewController(animated: true)
		} else {
			failed(title: "QR not supported", message: "this qr code is not including movie data") { (alertAction) in
				self.captureSession.startRunning()
			}
		}
	}
}

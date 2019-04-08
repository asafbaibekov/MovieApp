//
//  AddMovieViewController+AVCaptureMetadataOutputObjectsDelegate.swift
//  MovieApp
//
//  Created by Asaf Baibekov on 09/04/2019.
//  Copyright © 2019 Asaf Baibekov. All rights reserved.
//

import UIKit
import AVFoundation

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

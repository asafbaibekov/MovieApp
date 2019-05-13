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
		let decoder = JSONDecoder()
		if let data = stringValue.data(using: .utf8), let movie = try? decoder.decode(MovieJSON.self, from: data) {
			if MovieCoreDataHandler.cleanDelete() {
				MovieCoreDataHandler.saveObeject(movie: movie)
				self.navigationController?.popViewController(animated: true)
			}
		} else {
			failed(title: "QR not supported", message: "this qr code is not including movie data") { (alertAction) in
				self.captureSession.startRunning()
			}
		}
	}
}

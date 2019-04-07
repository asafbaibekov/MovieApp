//
//  ViewController.swift
//  MovieApp
//
//  Created by Asaf Baibekov on 07/04/2019.
//  Copyright © 2019 Asaf Baibekov. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view.
		
		let url = URL(string: "https://api.androidhive.info/json/movies.json")!
		if let data: Data = try? Data(contentsOf: url),
			let jsonResponse = try? JSONSerialization.jsonObject(with: data, options: [.allowFragments]),
			let jsonArray = jsonResponse as? [[String: Any]] {
			
		}
	}


}


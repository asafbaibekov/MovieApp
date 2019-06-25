//
//  ViewController+UITableViewDataSource.swift
//  MovieApp
//
//  Created by Asaf Baibekov on 09/04/2019.
//  Copyright © 2019 Asaf Baibekov. All rights reserved.
//

import UIKit

extension ViewController: UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return self.movies?.count ?? 0
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		return tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
	}
}

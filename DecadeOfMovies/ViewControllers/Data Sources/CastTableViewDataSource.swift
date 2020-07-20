//
//  CastTableViewDataSource.swift
//  DecadeOfMovies
//
//  Created by Yousef Hamza on 7/20/20.
//  Copyright © 2020 yousefahmza. All rights reserved.
//

import UIKit

class CastTableViewDataSource: NSObject, UITableViewDataSource {
    let cast: [String]
    let reuseIdentifier: String

    init(cast: [String], reuseIdentifier: String) {
        self.cast = cast
        self.reuseIdentifier = reuseIdentifier
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
          cast.count
      }

      func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
          let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
          cell.textLabel?.text = cast[indexPath.row]
          return cell
      }
}

//
//  Kits.swift
//  openWeather
//
//  Created by user on 2021/12/24.
//

import Foundation
import UIKit

public func localString(from timestamp: Double, dateFormat: String = "yyyy-MM-dd") -> String {
  let date = Date(timeIntervalSince1970: timestamp)
  let dateFormatter = DateFormatter()
  dateFormatter.timeZone = NSTimeZone.local
  dateFormatter.dateFormat = dateFormat
  return dateFormatter.string(from: date)
}


public protocol RoyUIInterface {
  static var id: String { get }
}

extension RoyUIInterface {
  public static var id: String {
    String(describing: Self.self)
  }
}

///
extension UITableViewCell {
  public static var reuseIdentifier: String {
    String(describing: Self.self)
  }
}


//
//  MenuItemProtocol.swift
//  PizzaGuysFoodCost
//
//  Created by Reza Enayati on 10/24/24.
//

import Foundation

protocol MenuItem: Codable, Identifiable {
    var id: Int { get }
    var name: String { get }
    var imageName: String { get }
}

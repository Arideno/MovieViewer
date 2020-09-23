//
//  FavoriteMovie+CoreDataProperties.swift
//  
//
//  Created by Andrii Moisol on 22.09.2020.
//
//

import Foundation
import CoreData


extension FavoriteMovie {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FavoriteMovie> {
        return NSFetchRequest<FavoriteMovie>(entityName: "FavoriteMovie")
    }

    @NSManaged public var id: Int32
    @NSManaged public var releaseDate: String?
    @NSManaged public var title: String?
    @NSManaged public var overview: String?
    @NSManaged public var poster: String?
    @NSManaged public var backdrop: String?

}

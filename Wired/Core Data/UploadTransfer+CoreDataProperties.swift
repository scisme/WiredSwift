//
//  UploadTransfer+CoreDataProperties.swift
//  WiredSwift
//
//  Created by Rafael Warnault on 22/02/2020.
//  Copyright © 2020 Read-Write. All rights reserved.
//
//

import Foundation
import CoreData


extension UploadTransfer {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UploadTransfer> {
        return NSFetchRequest<UploadTransfer>(entityName: "UploadTransfer")
    }


}

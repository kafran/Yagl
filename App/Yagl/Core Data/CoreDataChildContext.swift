//
//  CoreDataChildContext.swift
//  Yagl
//
//  Created by Kolmar Kafran on 29/11/22.
//

import CoreData

/// A helper object to manage Core Data childContext for creating and editing an Item.
struct CoreDataChildContext<Entity: NSManagedObject> {
    let parentContext: NSManagedObjectContext
    let childContext: NSManagedObjectContext?
    let childObject: Entity

    init(
        editEntity: Entity? = nil,
        parentContext viewContext: NSManagedObjectContext? = nil
    ) {
        guard let parentContext = editEntity?.managedObjectContext ?? viewContext else {
            fatalError(
                """
                Attempting to edit/create a managed object that's not \
                associated with a context nor passing a parent context \
                explicitly.
                """
            )
        }

        self.parentContext = parentContext

        let childContext =
            NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        childContext.parent = parentContext
        self.childContext = childContext

        if let editEntity,
           let childObject = try? childContext
           .existingObject(with: editEntity.objectID) as? Entity
        {
            self.childObject = childObject
        } else {
            childObject = .init(context: childContext)
        }
    }
}

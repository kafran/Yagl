//
//  Persistence.swift
//  Yagl
//
//  Created by Kolmar Kafran on 22/11/22.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        for i in 0 ..< 10 {
            let newItem = Item(context: viewContext)
            newItem.name = "Item \(i)"
            newItem.inCart = false
            newItem.isArchived = false
            // Adds multiple random historical transactions to the Item
            for h in 1 ..< Int.random(in: 1 ... 11) {
                let newTransaction = Transaction(context: viewContext)
                newTransaction.item = newItem
                newTransaction.price = Decimal(h) as NSDecimalNumber
                newTransaction.quantity = Int16(h)
                newTransaction.date = Date.now
            }
        }
        do {
            try viewContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and
            // terminate. You should not use this function in a shipping application,
            // although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "Yagl")
        if inMemory {
            container.persistentStoreDescriptions.first!
                .url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { _, error in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error
                // appropriately.
                // fatalError() causes the application to generate a crash log and
                // terminate. You should not use this function in a shipping
                // application, although it may be useful during development.

                // Typical reasons for an error here include:
                // * The parent directory does not exist, cannot be created, or
                // disallows writing.
                // * The persistent store is not accessible, due to permissions or data
                // protection when the device is locked.
                // * The device is out of space.
                // * The store could not be migrated to the current model version.
                // Check the error message to determine what the actual problem was.
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
}

#if DEBUG
    // Provide a single Item to be used on PreviewProvider
    extension Item {
        static var example: Item {
            // Get one random Item from the in-memory Core Data store.
            let context = PersistenceController.preview.container.viewContext
            let fetchRequest: NSFetchRequest<Item> = Item.fetchRequest()
            fetchRequest.fetchLimit = 1

            if let results = try? context.fetch(fetchRequest) {
                if let item = results.first {
                    return item
                }
            }
            return Item(context: context)
        }
    }
#endif

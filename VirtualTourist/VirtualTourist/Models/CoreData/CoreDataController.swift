//
//  CoreDataController.swift
//  VirtualTourist
//
//  Created by Kuei-Jung Hu on 2020/4/22.
//  Copyright © 2020 Kuei-Jung Hu. All rights reserved.
//

import CoreData
import MapKit

class CoreDataController {
    static var shared = CoreDataController(modelName: "VirtualTourist")
    
    let persistentContainer:NSPersistentContainer
    
    var viewContext:NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    let backgroundContext:NSManagedObjectContext!
    
    init(modelName:String) {
        persistentContainer = NSPersistentContainer(name: modelName)
        
        backgroundContext = persistentContainer.newBackgroundContext()
    }
    
    func configureContexts() {
        viewContext.automaticallyMergesChangesFromParent = true
        backgroundContext.automaticallyMergesChangesFromParent = true
        
        backgroundContext.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
        viewContext.mergePolicy = NSMergePolicy.mergeByPropertyStoreTrump
    }
    
    func load(completion: (() -> Void)? = nil) {
        persistentContainer.loadPersistentStores { storeDescription, error in
            guard error == nil else {
                fatalError(error!.localizedDescription)
            }
            self.configureContexts()
            completion?()
        }
    }
    
    func saveContext() -> Bool {
        if viewContext.hasChanges {
            do {
                try viewContext.save()
                return true
            } catch {
                let nserror = error as NSError
                print("Unresolved error \(nserror), \(nserror.userInfo)")
                return false
            }
        } else {
            return false
        }
    }
}

// MARK: - CoreData Manipulation

extension CoreDataController {
    
    func loadPins() -> [Pin] {
        var pins: [Pin] = []
        let fetchRequest: NSFetchRequest<Pin> = Pin.fetchRequest()
        if let result = try? viewContext.fetch(fetchRequest) {
            pins = result
        }
        return pins
    }
    
    func addPin(coordinate: CLLocationCoordinate2D, completionHandler: (Pin) -> Void) {
        let pin = Pin(context: viewContext)
        pin.lat = coordinate.latitude
        pin.lon = coordinate.longitude
        if saveContext() {
            completionHandler(pin)
        }
    }
    
    func loadPhotos(pin: Pin) -> [Photo] {
        var photos: [Photo] = []
        let fetchRequest: NSFetchRequest<Photo> = Photo.fetchRequest()
        let predicate = NSPredicate(format: "pin = %@", pin)
        fetchRequest.predicate = predicate
        if let result = try? viewContext.fetch(fetchRequest) {
            photos = result
        }
        return photos
    }
    
    func fetchPhotoBy(id: String) -> Photo? {
        let fetchRequest: NSFetchRequest<Photo> = Photo.fetchRequest()
        let predicate = NSPredicate(format: "id = %@", id)
        fetchRequest.predicate = predicate
        if let result = try? viewContext.fetch(fetchRequest), result.count > 0 {
            return result[0]
        } else {
            return nil
        }
    }
    
    func addPhoto(id:String, imageURL: String, imageData: Data?, pin: Pin, completionHandler: (Photo) -> Void) {
        if let photo = fetchPhotoBy(id: id) {
            completionHandler(photo)
            return
        }
        let photo = Photo(context: viewContext)
        photo.id = id
        photo.imageUrl = imageURL
        photo.imageData = imageData
        photo.pin = pin
        if saveContext() {
            completionHandler(photo)
        }
    }
    
    func addPhotos(images: [FlickerImage], pin: Pin, completionHandler: ([Photo]) -> Void) {
        var photos: [Photo] = []
        for image in images {
            let photo = Photo(context: viewContext)
            photo.id = image.id
            photo.imageUrl = image.photoImageURL()
            photo.imageData = nil
            photo.pin = pin
            photos.append(photo)
        }
        if saveContext() {
            completionHandler(photos)
        }
    }
    
    func deletePhoto(photo: Photo, completionHandler: () -> Void) {
        viewContext.delete(photo)
        if saveContext() {
            completionHandler()
        }
    }
    
    func deletePhotos(pin: Pin, completionHandler: (() -> Void)? = nil) {
        let photos  = loadPhotos(pin: pin)
        for photo in photos {
            viewContext.delete(photo)
        }
        if saveContext() {
            completionHandler?()
        }
    }
    
    func saveImageDataToPhoto(photo: Photo, imageData: Data, completionHandler: () -> Void) {
        photo.imageData = imageData
        if saveContext() {
            completionHandler()
        }
    }
    
}

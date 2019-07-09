//
//  LocalServices.swift
//  Bantu
//
//  Created by Steven Muliamin on 07/07/19.
//  Copyright © 2019 Steven Muliamin. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class LocalServices{
    private init(){}
    
    static var context: NSManagedObjectContext{
        return persistentContainer.viewContext
    }
    
    static var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "LocalModel")
        container.loadPersistentStores(completionHandler: {(storeDescription, error) in
            if let error = error as NSError? {
                fatalError("error has occured")
            }
        })
        return container
    }()
    
    static func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges{
            do{
                try context.save()
                print("save success")
            }
            catch{
                let nserror = error as NSError
                fatalError("Error has occured: \(nserror)")
            }
        }
    }
}

extension LocalServices {
    static func imagesToNSData(images: [UIImage]) -> NSData {
        let CDataArray = NSMutableArray()
        
        for img in images {
            let data: NSData = NSData(data: img.jpegData(compressionQuality: 0.1)!)
            CDataArray.add(data)
        }
        
        let coreDataObject = NSKeyedArchiver.archivedData(withRootObject: CDataArray)
        return (coreDataObject as NSData)
    }
    
    static func saveToDraft(draft: DraftEntityModel) {
        let newDraft = DraftEntity(context: LocalServices.context)
        
        let roadImages = imagesToNSData(images: draft.roadImages)
        let schoolImages = imagesToNSData(images: draft.schoolImages)
        
        newDraft.timeStamp = draft.timeStamp
        newDraft.schoolName = draft.schoolName
        newDraft.about = draft.about
        newDraft.studentNo = Int64(draft.studentNo)
        newDraft.teacherNo = Int64(draft.teacherNo)
        newDraft.address = draft.address
        newDraft.accessNotes = draft.accessNotes
        newDraft.notes = draft.notes
        newDraft.contactNumber = draft.contactNumber
        newDraft.locationAOI = draft.locationAOI
        newDraft.locationName = draft.locationName
        newDraft.locationLocality = draft.locationLocality
        newDraft.locationAdminArea = draft.locationAdminArea
        newDraft.locationLatitude = draft.locationLatitude
        newDraft.locationLongitude = draft.locationLongitude
        newDraft.roadImages = roadImages
        newDraft.schoolImages = schoolImages
        
        LocalServices.saveContext()
        print("saved to core data yeah!!!")
    }
    
    static func fetchAllDrafts() -> [DraftEntityModel] {
        func draftEntityToDraftModel(entity: DraftEntity) -> DraftEntityModel {
            var schoolImages: [UIImage] = []
            var roadImages: [UIImage] = []
            
            if let schoolData = NSKeyedUnarchiver.unarchiveObject(with: entity.schoolImages as! Data) as? NSArray {
                for data in schoolData {
                    let image = UIImage(data: data as! Data)
                    schoolImages.append(image!)
                }
            }
            
            if let roadData = NSKeyedUnarchiver.unarchiveObject(with: entity.roadImages as! Data) as? NSArray {
                for data in roadData {
                    let image = UIImage(data: data as! Data)
                    roadImages.append(image!)
                }
            }
            
            let draftModel = DraftEntityModel(timeStamp: entity.timeStamp!,
                                              schoolName: entity.schoolName!,
                                              about: entity.about!,
                                              studentNo: Int(entity.studentNo),
                                              teacherNo: Int(entity.teacherNo),
                                              address: entity.address!,
                                              accessNotes: entity.accessNotes!,
                                              notes: entity.notes!,
                                              contactNumber: entity.contactNumber!,
                                              locationAOI: entity.locationAOI!,
                                              locationName: entity.locationName!,
                                              locationLocality: entity.locationLocality!,
                                              locationAdminArea: entity.locationAdminArea!,
                                              locationLatitude: entity.locationLatitude,
                                              locationLongitude: entity.locationLongitude,
                                              roadImages: roadImages,
                                              schoolImages: schoolImages
            )
            return draftModel
        }
        
        let fetchRequest: NSFetchRequest<DraftEntity> = DraftEntity.fetchRequest()
        do{
            let fetchData = try LocalServices.context.fetch(fetchRequest)
            var draftArray: [DraftEntityModel] = []
            
            for draft in fetchData {
                draftArray.append(draftEntityToDraftModel(entity: draft))
            }
            return draftArray
        } catch {
            print("Fetch from core data fail")
            return []
        }
    }
    
    static func deleteFromCoreData(withSchoolName name: String) {
        let managedContext = LocalServices.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<DraftEntity> = DraftEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "schoolName = %@", name)
        do
        {
            let fetchData = try LocalServices.context.fetch(fetchRequest)
            
            let node = fetchData[0]
            managedContext.delete(node)
            
            do {
                try managedContext.save()
                print("Success Delete From Core Data")
            } catch let error as NSError {
                print("Error While Deleting Note: \(error.userInfo)")
            }
        }
        catch _ {
            print("Could not delete")
        }
    }
    
    static func updateFromCoreData(withSchoolName name: String, updatedDraft draft: DraftEntityModel) {
        let context = LocalServices.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<DraftEntity> = DraftEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "schoolName = %@", name)
        
        do {
            let results = try context.fetch(fetchRequest)
            fetchRequest.returnsObjectsAsFaults = false
            print("Results Count :", results.count)
            
            if(results.count > 0 ){
                let newDraft = results[0]
                
                let roadImages = imagesToNSData(images: draft.roadImages)
                let schoolImages = imagesToNSData(images: draft.schoolImages)
                
                newDraft.timeStamp = draft.timeStamp
                newDraft.schoolName = draft.schoolName
                newDraft.about = draft.about
                newDraft.studentNo = Int64(draft.studentNo)
                newDraft.teacherNo = Int64(draft.teacherNo)
                newDraft.address = draft.address
                newDraft.accessNotes = draft.accessNotes
                newDraft.notes = draft.notes
                newDraft.contactNumber = draft.contactNumber
                newDraft.locationAOI = draft.locationAOI
                newDraft.locationName = draft.locationName
                newDraft.locationLocality = draft.locationLocality
                newDraft.locationAdminArea = draft.locationAdminArea
                newDraft.locationLatitude = draft.locationLatitude
                newDraft.locationLongitude = draft.locationLongitude
                newDraft.roadImages = roadImages
                newDraft.schoolImages = schoolImages
                
//                results[0].setValue(roadImages, forKey: "roadImages")
                
                try context.save();
                print("Updated Core Data")
                //                } endfor
            } else {
                print("No Audios to save")
            }
        } catch{
            print("There was an error")
        }
    }
}

//
//  CoreData.swift
//  WikiSearch
//
//  Created by Manjunath Naragund on 24/06/18.
//  Copyright © 2018 Manjunath. All rights reserved.
//

import Foundation
import CoreData

/**
 @breif: SearchResultDB is for handling coreData Create/Update/Delete reuqests.
 This is singleton class.
**/
class SearchResultDB {
    
    fileprivate var managedObjectContext: NSManagedObjectContext!
    fileprivate var readManagedObjectContext: NSManagedObjectContext!
    fileprivate var managedObjectModel: NSManagedObjectModel!
    fileprivate var persistnaceStoreCoodinator: NSPersistentStoreCoordinator!
    
    private static var sharedInstance: SearchResultDB = {
        let searchDataInstance = SearchResultDB()
        return searchDataInstance
    }()
    
    private init() {
        setupManagedObjectContext()
    }
    
    class func shared() -> SearchResultDB {
        return sharedInstance
    }
    
    /**
     @breif: This method is to setup modelObjectContext , modelObjectModel, persitanceStorePath.
    **/
    private func setupManagedObjectContext() {
        let fileManager = FileManager.default
        guard let documentDirectoryUrl = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
            print("No Directory")
            return
        }
        let persitantUrl = documentDirectoryUrl.appendingPathComponent("WikiSearch.sqlite")
        guard let modelUrl = Bundle.main.url(forResource: "WikiSearch", withExtension: "momd") else {
            print("No Core data Model momd")
            return
        }
        managedObjectModel = NSManagedObjectModel(contentsOf: modelUrl)
        persistnaceStoreCoodinator = NSPersistentStoreCoordinator(managedObjectModel: managedObjectModel)
        
        do {
            let _ = try persistnaceStoreCoodinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: persitantUrl, options: nil)
            managedObjectContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
            managedObjectContext.persistentStoreCoordinator = persistnaceStoreCoodinator
            
            readManagedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
            readManagedObjectContext.parent = managedObjectContext
        } catch let exception {
            print("Core data \(exception.localizedDescription)")
        }
    }
    
    /**
     @breif: This method to save data using managed object context.
    **/
    fileprivate func saveDataInManagedObjectContextUsing(completionBlock block: @escaping(_ isSaved: Bool)-> Void) {
        do {
            try managedObjectContext.save()
            print("SAVE")
            block(true)
        } catch let error {
            block(false)
            print("Failed to Save data \(error.localizedDescription)")
        }
    }
}

/**
 Here we handle CoreData request/Queries.
**/
extension SearchResultDB {
    
    func saveResults(_ resultModel: ResultModel) {
        let resultDBObjc = ResultDB(context: managedObjectContext)
        
        if let batchcomplete = resultModel.batchcomplete {
            resultDBObjc.batchcomplete = batchcomplete
        }
        
        if let query = resultModel.query {
            let queryDbObjc = QueryDB(context: managedObjectContext)
            
            if let pages = query.pages {
                for page in pages {
                    let pagesDBObjc = PagesDB(context: managedObjectContext)
                    
                    if let id = page.pageid {
                        pagesDBObjc.pageId = Int32(id)
                    }
                    if let title = page.title {
                        pagesDBObjc.title = title
                    }
                    
                    if let terms = page.terms {
                        let termsDBObjc = TermsDB(context: managedObjectContext)
                        if let desc = terms.description {
                            var i = 0
                            var message: String!
                            for des in desc {
                                if i == 0 {
                                    message =  des
                                } else {
                                    message.append(" \(des)")
                                }
                                i += 1
                            }
                            termsDBObjc.wikiDescription = message
                            pagesDBObjc.setValue(termsDBObjc, forKey: "pageAndTermRelation")
                            saveDataInManagedObjectContextUsing { (isSaved) in}
                        }
                    }
                    
                    if let thumbnail = page.thumbnail {
                        let thumbnailDBObjc = ThumbnailDB(context: managedObjectContext)
                        if let imagePath = thumbnail.source {
                            thumbnailDBObjc.source = imagePath
                            pagesDBObjc.setValue(thumbnailDBObjc, forKey: "pageAndThumbnaiRelation")
                        }
                    }
                    
                    let page = queryDbObjc.mutableSetValue(forKey: "pageQueryRelation")
                    
                    queryDbObjc.setValue(page, forKey: "pageQueryRelation")
                    saveDataInManagedObjectContextUsing { (isSaved) in}
                }
            }
            resultDBObjc.setValue(queryDbObjc, forKey: "resultQueryRelation")
            saveDataInManagedObjectContextUsing { (isSaved) in}
        }
        saveDataInManagedObjectContextUsing { (isSaved) in}
    }
}


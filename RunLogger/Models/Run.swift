//
//  Run.swift
//  RunLogger
//
//  Created by Scott on 7/19/21.
//

import Foundation
import RealmSwift

public final class Run: Object {
    
    @objc dynamic public private(set) var id = UUID().uuidString.lowercased()
    @objc dynamic public private(set) var pace = 0
    @objc dynamic public private(set) var distance = 0.0
    @objc dynamic public private(set) var duration = 0
    @objc dynamic public private(set) var date = Date()
    
    public private(set) var locations = List<Location>()
    
    public override class func primaryKey() -> String? {
        return "id"
    }
    
    public override class func indexedProperties() -> [String] {
        return [
            "pace",
            "date",
            "duration"
        ]
    }
    
    convenience init(pace: Int, distance: Double, duration: Int, locations: List<Location>) {
        self.init()
        self.date = Date()
        self.pace = pace
        self.distance = distance
        self.duration = duration
        self.locations = locations
    }
    
    static func addRunToRealm(pace: Int, distance: Double, duration: Int, locations: List<Location>) {
        Constants.realmQueue.sync {
            do {
                let realm = try Realm()
                try realm.write({
                    realm.add(Run(pace: pace, distance: distance, duration: duration, locations: locations))
                    try realm.commitWrite()
                })
            } catch let error {
                debugPrint("\(error) Error adding Run to Realm.")
            }
        }
    }
    
    static func getAllRuns() -> Results<Run>? {
        do {
            let realm = try Realm()
            var runCollection = realm.objects(Run.self)
            runCollection = runCollection.sorted(byKeyPath: "date", ascending: false)
            return runCollection
        } catch let error {
            debugPrint("\(error) Error add getting all runs.")
            return nil
        }
    }
    
}

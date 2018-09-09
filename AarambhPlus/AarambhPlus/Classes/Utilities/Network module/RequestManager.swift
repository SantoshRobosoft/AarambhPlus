//
//  RequestManager.swift
//  AarambhPlus
//
//  Created by Santosh Kumar Sahoo on 9/7/18.
//  Copyright © 2018 Santosh Dev. All rights reserved.
//

import Alamofire
import Foundation

class RequestManager {
    static let shared = RequestManager()
    
    ///Map table for holding URLSessionTask's, Key will be request ID string.
    private var taskDictionary = NSMapTable<NSString, URLSessionTask>.strongToWeakObjects()
    private var requestDictionary = NSMapTable<NSString, Request>.strongToWeakObjects()

    ///Array to hold `DataResource`'s which has to be re-executed.
    private var retryDataResources: [DataResourceRetrier] = [DataResourceRetrier]()
    
    ///Flag will indicate accessToken renewal is in progress.
    var isRenewTokenRunning: Bool = false
    
    /**
     Adds URLSessionTask to the map table
    */
    func setTask(_ task: URLSessionTask?, forKey key: String) {
        self.taskDictionary.setObject(task, forKey: key as NSString)
    }
    
    /**
     Gives the URLSessionTask for the specified request ID string.
    */
    func task(forKey key: String) -> URLSessionTask? {
        return self.taskDictionary.object(forKey: key as NSString)
    }
    
    func removeTask(forKey key: String) {
        self.taskDictionary.removeObject(forKey: key as NSString)
    }
    
    /**
     Adds URLSessionTask to the map table
     */
    func setRequest(_ task: Request?, forKey key: String) {
        self.requestDictionary.setObject(task, forKey: key as NSString)
    }
    
    /**
     Gives the URLSessionTask for the specified request ID string.
     */
    func request(forKey key: String) -> Request? {
        return self.requestDictionary.object(forKey: key as NSString)
    }
    
    func removeRequest(forKey key: String) {
        self.requestDictionary.removeObject(forKey: key as NSString)
    }
    
    /**
     Cancels all the URLSessionTask's.
    */
    func cancelAllRequests() {
        if let objects = self.taskDictionary.objectEnumerator() {
            for task in objects {
                (task as? URLSessionTask)?.cancel()
            }
        }
    }
    
    /**
     Cancels URLSessionTask's for the specified request ID's
     
     - parameter requestIds: Request ID array.
    */
    func cancelRequests(_ requestIds: [String]) {
        for requestId in requestIds {
            if let task = self.task(forKey: requestId) {
                task.cancel()
                self.removeTask(forKey: requestId)
            }
        }
    }
        
    /**
     Adds data resource to retrier array
    */
    func appendPendingDataResourceRequest(_ req: DataResourceRetrier) {
        print("Adding data resource to pending list")
        self.retryDataResources.append(req)
    }
    
    /**
     Executes web requests queued in retrier array
     After executing removes all data resource from the array.
    */
    func executePendingDataResourceRequests() {
        for resource in self.retryDataResources {
            resource.retryWebFetcher()
        }
        self.retryDataResources.removeAll()
    }
    
    /**
     Completes the data request with error for all requests queued in retrier array
     After executing removes all data resource from the array.
     */
    func clearPendingRequestQueue() {
        self.retryDataResources.forEach { dataResource in
            dataResource.clearRequest()
        }
        self.retryDataResources.removeAll()
    }
    
    func flushRequestQueue() {
        self.retryDataResources.removeAll()
    }
    
    deinit {
        cancelAllRequests()
    }
}

class NetworkSessionManager {
    static let shared = NetworkSessionManager()
    
    //var session: SessionManager!
    
    private init() {
//        isServerTrusted = true
//        session = SessionManager(
//            serverTrustPolicyManager: CustomServerTrustPolicyManager(policies: [:], isServerTrusted: isServerTrusted
//            ))
    }
    
    /*var isServerTrusted: Bool = true {
        didSet {
            session = SessionManager(
                serverTrustPolicyManager: CustomServerTrustPolicyManager(policies: [:], isServerTrusted: isServerTrusted
            ))
        }
    }*/
    
    private let ntwReachabilityMgr = NetworkReachabilityManager()
    var isServerReachable: Bool {
        print("network reachability check")
        print(self.ntwReachabilityMgr?.isReachable ?? false)
        return self.ntwReachabilityMgr?.isReachable ?? false
    }
}

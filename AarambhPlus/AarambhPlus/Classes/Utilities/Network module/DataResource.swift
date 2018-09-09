//
//  DataResource.swift
//  AarambhPlus
//
//  Created by Santosh Kumar Sahoo on 9/7/18.
//  Copyright © 2018 Santosh Dev. All rights reserved.
//

import Foundation

typealias CODE = Int

protocol DataResourceRetrier {
    func retryWebFetcher()
    func clearRequest()
}

// MARK: Data options

struct DataOptions: OptionSet {
    let rawValue: UInt8
    /// Data preferred from RAM memory
    static let memory = DataOptions(rawValue: 1 << 0) // 00000001
    /// Data preferred from device file system
    static let database = DataOptions(rawValue: 1 << 1) // 00000010
    /// Data preferred from Server.
    static let server = DataOptions(rawValue: 1 << 2) // 00000100
}

// MARK: Data resource

class DataResource<D>: DataResourceRetrier {
    typealias FetcherCompletion = ((_ completion: @escaping ((DataResult<D>) -> Void)) -> Void)
    typealias WebFetcherCompletion = ((_ completion: @escaping ((DataResult<D>) -> Void)) -> DataRequestID)
    typealias DataProcessorFormat = ((_ response: APIResponse<D>, _ completion: @escaping ((DataResult<D>) -> Void)) -> Void)
    
    private var memoryFetcher: FetcherCompletion?
    private var dbFetcher: FetcherCompletion?
    private var webFetcher: WebFetcherCompletion?
    private var dataProcessing: DataProcessorFormat?
    private let options: [DataOptions]?
    private var completionBlock: ((DataResult<D>) -> Void)?
    
    /**
     DataResource constructor
     `DataResource` will provide completion closure for data fetching block.
     **Pass atleast one data fetching closure.**
     
     - parameter dataOptions: Prefered data options array. Default is nil.
     - parameter loadFromMemory: Closure for getting data from memory. Default is nil.
     - parameter loadFromDatabase: Closure for getting data local database. Default is nil.
     - parameter loadFromServer: Closure for getting data from remote server. Default is nil.
     - parameter processor: Closure for processing the response after fetching. Post processor closure will receive `APIResponse` and completion block
     */
    init(dataOptions: [DataOptions]? = nil, loadFromMemory: FetcherCompletion? = nil, loadFromDatabase: FetcherCompletion? = nil, loadFromServer: WebFetcherCompletion? = nil, postDataProcessing processor: DataProcessorFormat? = nil) {
        self.options = dataOptions
        self.memoryFetcher = loadFromMemory
        self.dbFetcher = loadFromDatabase
        self.webFetcher = loadFromServer
        self.dataProcessing = processor
    }
    
    /**
     Executes data fetching closure's
     - parameter completion: Closure to be called once data fetching & data processing completes. **Completion will be called on main thread**
     - Returns: Data request ID string.
     */
    @discardableResult func executeWith(completion: ((DataResult<D>) -> Void)?) -> DataRequestID? {
        self.completionBlock = completion
        return self.executeDataRequest()
    }
    
    /**
     Performs the data fetching by calling provided data fetching closures.
     - Returns: Data request ID string.
     */
    fileprivate func executeDataRequest() -> DataRequestID? {
        /// Closure to be passed as completion block for data fetching block's
        let fetchCompletion = { (result: (DataResult<D>)) -> Void in
            
            print("data resource completion")
            switch result {
            case .success(let response):
                /// Data fetching is success.
                /// now check for any data processing function block
                /// if it is there we pass the response alongwith completion block to the data processor function block.
                if let dataProcessor = self.dataProcessing {
                    dataProcessor(response, { processedResult in
                        DispatchQueue.main.async {
                            self.completionBlock?(processedResult)
                        }
                    })
                } else {
                    /// No data processing. Send the result in actual completion block.
                    DispatchQueue.main.async {
                        self.completionBlock?(result)
                    }
                }
            case .failure(let error):
                /// If data fetching is failed, we check for retry error. This error will occur whenever accesstoken renewal is in progress.
                /// Then we add the complete `DataResource` into retrier.
                if case APIError.needRetry = error {
                    RequestManager.shared.appendPendingDataResourceRequest(self)
                } else {
                    DispatchQueue.main.async {
                        self.completionBlock?(DataResult.failure(error))
                    }
                }
            }
        }
        
        if let dataOptions = self.options {
            /// If data option is specified. we execute the data fetching block by checking the data option.
            
            /// First we combine all data options.
            /// Then we do bitwise AND operation to check for particular data option.
            let combinedOption = dataOptions.reduce(0, { res, opt in
                res | opt.rawValue
            })
            
            if let memfetch = memoryFetcher, combinedOption & DataOptions.memory.rawValue > 0 {
                memfetch(fetchCompletion)
            }
            if let dbfetch = dbFetcher, combinedOption & DataOptions.database.rawValue > 0 {
                dbfetch(fetchCompletion)
            }
            if let webfetch = webFetcher, combinedOption & DataOptions.server.rawValue > 0 {
                /// If it is server operation. We check for any SSL problem
                /// `canConnectToServer` will return false if SSL checking is pending or user is aborted.
               // if SSLHandler.shared.canConnectToServer {
                    return webfetch(fetchCompletion)
//                } else {
//                    /// If we cannot connect at this moment, we add web fetching function to SSLHandler.
//                    SSLHandler.shared.addCompletion(listioner: {
//                        _ = webfetch(fetchCompletion)
//                    })
//                }
            }
            
        } else {
            /// Here comes when data options not specified.
            if let memfetch = memoryFetcher {
                memfetch(fetchCompletion)
            } else if let dbfetch = dbFetcher {
                dbfetch(fetchCompletion)
            } else if let webfetch = webFetcher {
                /// If it is server operation. We check for any SSL problem
                /// `canConnectToServer` will return false if SSL checking is pending or user is aborted.
               // if SSLHandler.shared.canConnectToServer {
                    return webfetch(fetchCompletion)
//                } else {
//                    /// If we cannot connect at this moment, we add web fetching function to SSLHandler.
//                    SSLHandler.shared.addCompletion(listioner: {
//                        _ = webfetch(fetchCompletion)
//                    })
//                }
            }
        }
        return nil
    }
    
    // MARK: Request retry.
    
    func retryWebFetcher() {
        print("retrying the request")
        /// Closure to be passed as completion block for data fetching block's
        let fetchCompletion = { (result: (DataResult<D>)) -> Void in
            
            print("data resource completion")
            switch result {
            case .success(let response):
                if let dataProcessor = self.dataProcessing {
                    dataProcessor(response, { processedResult in
                        DispatchQueue.main.async {
                            self.completionBlock?(processedResult)
                        }
                    })
                } else {
                    DispatchQueue.main.async {
                        self.completionBlock?(result)
                    }
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.completionBlock?(DataResult.failure(error))
                }
            }
        }
        
        /// During retry we don't check for data option because web fetching is tried already once.
        /// It means `.server` is mentioned if data option is passed.
        if let webfetch = webFetcher {
            _ = webfetch(fetchCompletion)
        }
    }
    
    /**
     closing the request with error.
     */
    func clearRequest() {
        self.completionBlock?(DataResult.failure(APIError.somethingWentWrong))
    }
    
    deinit {
        print("Deinit of data resource class")
    }
}

// MARK: DATA result

public enum DataResult<D> {
    case success(APIResponse<D>)
    case failure(APIError)
    
    /// Gives the response if result is success. else returns nil
    public var response: APIResponse<D>? {
        switch self {
        case .success(let value):
            return value
        case .failure:
            return nil
        }
    }
}

//
//  NetworkManager.swift
//  MovieViewer
//
//  Created by Andrii Moisol on 22.09.2020.
//

import Foundation
import Network

protocol NetworkManagerProtocol {
    func networkStatusChanged(satisfied: Bool)
}

class NetworkManager: NSObject {
    var delegate: NetworkManagerProtocol?
    let monitor = NWPathMonitor()
    
    override init() {
        super.init()
        
        monitor.pathUpdateHandler = { path in
            DispatchQueue.main.async {
                if path.status == .satisfied {
                    self.delegate?.networkStatusChanged(satisfied: true)
                } else {
                    self.delegate?.networkStatusChanged(satisfied: false)
                }
            }
        }
        
        let queue = DispatchQueue(label: "Monitor")
        monitor.start(queue: queue)
    }
}

//
//  MessageFilterExtension.swift
//  Butters Filter
//
//  Created by kanj on 14/09/18.
//  Copyright © 2018 kanj. All rights reserved.
//

import IdentityLookup

final class MessageFilterExtension: ILMessageFilterExtension {}

extension MessageFilterExtension: ILMessageFilterQueryHandling {
    
    func handle(_ queryRequest: ILMessageFilterQueryRequest, context: ILMessageFilterExtensionContext, completion: @escaping (ILMessageFilterQueryResponse) -> Void) {

        guard let sender = queryRequest.sender, !sender.isEmpty else {
            return self.block(completion: completion)
        }
        
        var containsLetter = false
        let letters = CharacterSet.letters
        for uni in sender.unicodeScalars {
            if letters.contains(uni) {
                containsLetter = true
                break
            }
        }
        
        if !containsLetter {
            return self.allow(completion: completion)
        } else {
            let whitelist = UserDefaults.standard.stringArray(forKey: "STUFF")
            whitelist?.forEach({ (stuff) in
                if sender.contains(stuff) {
                    return allow(completion: completion)
                }
            })
        }
        
        return self.block(completion: completion)
    }
    
    private func block(completion: (ILMessageFilterQueryResponse) -> Void) {
        let response = ILMessageFilterQueryResponse()
        response.action = .filter
        completion(response)
    }
    
    private func allow(completion: (ILMessageFilterQueryResponse) -> Void) {
        let response = ILMessageFilterQueryResponse()
        response.action = .allow
        completion(response)
    }
    
}

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
        
        var isSpammer = false
        let letters = CharacterSet.letters

        if sender.count < 8 {
            // Normal mobile numbers are expected to have atleast 8 characters
            isSpammer = true
        } else {
            // Spammers has alphabetical "number"
            for uni in sender.unicodeScalars {
                if letters.contains(uni) {
                    isSpammer = true
                    break
                }
            }
        }


        if !isSpammer {
            return self.allow(completion: completion)
        } else {
            let whitelist = UserDefaults(suiteName: "group.butters")?.stringArray(forKey: "STUFF")
            whitelist?.forEach({ (stuff) in
                if sender.contains(stuff.lowercased()) {
                    return self.allow(completion: completion)
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

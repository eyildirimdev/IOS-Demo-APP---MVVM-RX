//
//  User.swift
//  tmob-demo
//
//  Created by emir on 17.10.2021.
//

import Foundation
struct User: Codable {
    
    let login: String
    let id: Int
    let node_id: String
    let avatar_url: String
    let gravatar_id:String
    let url: String
    let html_url: String
    let followers_url: String
    let following_url:String
    let starred_url:String
    let gists_url:String
    let subscriptions_url:String
    let organizations_url:String
    let repos_url:String
    let events_url:String
    let received_events_url:String
    let type:String
    let site_admin: Bool
    
    init(user:User) {
        self.login = user.login
        self.id = user.id
        self.node_id = user.node_id
        self.avatar_url = user.avatar_url
        self.gravatar_id = user.gravatar_id
        self.url = user.url
        self.html_url = user.html_url
        self.followers_url = user.followers_url
        self.following_url = user.following_url
        self.starred_url = user.starred_url
        self.gists_url = user.gists_url
        self.subscriptions_url = user.subscriptions_url
        self.organizations_url = user.organizations_url
        self.repos_url = user.repos_url
        self.events_url = user.events_url
        self.received_events_url = user.received_events_url
        self.type = user.type
        self.site_admin = user.site_admin
    }
    var userDataList: [String] {
        return [login,
                String(id),
                node_id,
                avatar_url,
                gravatar_id,
                gravatar_id,
                url,
                html_url,
                followers_url,
                following_url,
                starred_url,
                gists_url,
                subscriptions_url,
                organizations_url,
                repos_url,
                events_url,
                received_events_url,
                type,
                String(site_admin)]
    }
}

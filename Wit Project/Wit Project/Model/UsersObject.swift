//
//  UsersObject.swift
//  Wit Project
//
//  Created by Hugo Regadas on 23/09/2021.
//

import Foundation


class UsersObject : Codable{
    let login: String
    let idObject: Int
    let nodeID: String?
    let avatarUrl: String?
    let gravatarId: String?
    let url: String?
    let htmlUrl: String?
    let followersUrl: String?
    let subscriptionsUrl: String?
    let organizationsUrl: String
    let reposUrl: String?
    let receivedEventsUrl: String?
    let type: String?
    let followingUrl: String?
    let gistsUrl: String?
    let starredUrl: String?
    let eventsUrl: String?
    let siteAdmin: Bool?
    

    
    private enum CodingKeys: String, CodingKey{
        case idObject = "id", nodeID = "node_id", avatarUrl = "avatar_url", gravatarId = "gravatar_id",
             htmlUrl = "html_url", followersUrl = "followers_url", subscriptionsUrl = "subscriptions_url", organizationsUrl = "organizations_url",
             reposUrl = "repos_url", receivedEventsUrl = "received_events_url", followingUrl = "following_url", gistsUrl = "gists_url", starredUrl = "starred_url",
             eventsUrl = "events_url", siteAdmin = "site_admin"
        case login,
             url,
             type
    }
}



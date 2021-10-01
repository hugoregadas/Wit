//
//  InfoUserObject.swift
//  Wit Project
//
//  Created by Hugo Regadas on 24/09/2021.
//

import Foundation

class InfoUserObject : Codable{
    let login: String
    let idObject: Int
    let nodeID: String?
    let avatarUrl: String?
    let gravatarId: String?
    let url: String?
    let htmlUrl: String?
    let followersUrl: String?
    let followingUrl: String?
    let gistsUrl: String?
    let starredUrl: String?
    let subscriptionsUrl: String?
    let organizationsUrl: String?
    let reposUrl: String?
    let type: String?
    let siteAdmin: Bool?
    let eventsUrl: String?
    let receivedEventsUrl: String?
    let name: String?
    let company: String?
    let blog: String?
    let location: String?
    let email: String?
    let hireable: String?
    let bio: String?
    let twitterUsername: String?
    let publicRepos: Int?
    let publicGists: Int?
    let followers: Int?
    let following: Int?
    let createdAt: String?
    let updatedAt: String?

    
    private enum CodingKeys: String, CodingKey{
        case idObject = "id", nodeID = "node_id", avatarUrl = "avatar_url", gravatarId = "gravatar_id",
             htmlUrl = "html_url", followersUrl = "followers_url", subscriptionsUrl = "subscriptions_url", organizationsUrl = "organizations_url",
             reposUrl = "repos_url", receivedEventsUrl = "received_events_url", followingUrl = "following_url", gistsUrl = "gists_url", starredUrl = "starred_url",
             eventsUrl = "events_url", siteAdmin = "site_admin", twitterUsername = "twitter_username", publicRepos = "public_repos", publicGists = "public_gists",
             createdAt = "created_at", updatedAt = "updated_at"
        case login,
             url,
             type,
             name,
             company,
             blog,
             location,
             email,
             hireable,
             bio,
             followers,
             following
             
    }
}

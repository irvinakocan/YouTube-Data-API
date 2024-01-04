//
//  Requests.swift
//  YouTube Data API
//
//  Created by Macbook Air 2017 on 27. 12. 2023..
//

import Foundation

func fetchPlaylistItems() {
    
    // Very important: GET Requests have no body to the request, instead everything goes on the URL
    
    // Create URL Components
    guard var urlComponents = URLComponents(string: YOUTUBE_API + GET_PLAYLIST_ITEMS_ENDPOINT) else {
        return
    }
    
    // Add parameters as query items
    urlComponents.queryItems = [
        URLQueryItem(name: "part", value: "snippet"),
        URLQueryItem(name: "playlistId", value: MY_PLAYLIST_ID),
        URLQueryItem(name: "maxResults", value: "10"),
        URLQueryItem(name: "key", value: API_KEY)
    ]
    
    // Create URL
    guard let url = urlComponents.url else {
        return
    }
    
    let task = URLSession.shared.dataTask(with: url, completionHandler: {
        (data, response, error) in
        
        if error != nil {
            print("Error occured.")
            return
        }
        
        if let response = response as? HTTPURLResponse {
            print("Response Status code: \(response.statusCode)\n")
        }
        
        // Converting json data into eye-readable data
        if let data = data {
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                print(json)
            }
            catch {
                return
            }
        }
    })
    task.resume()
}

// OAuth2 Authentification needed

func addItemIntoPlaylist() {
    
    // Create URL Components
    guard var urlComponents = URLComponents(string: YOUTUBE_API + POST_PLAYLIST_ITEMS_ENDPOINT) else {
        return
    }
    
    // Add query parameters
    urlComponents.queryItems = [
        URLQueryItem(name: "key", value: API_KEY),
        URLQueryItem(name: "part", value: "snippet")
    ]
    
    // Create URL
    guard let url = urlComponents.url else {
        return
    }
    
    // Create URL Request
    var urlRequest = URLRequest(url: url)
    
    // Specify HTTP Request Method
    urlRequest.httpMethod = "POST"
    
    // Set HTTP Request Headers
    urlRequest.setValue("Bearer " + "ACCESS_TOKEN", forHTTPHeaderField: "Authorization")
    urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")
    urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
    
    // Specify Request Body
    let requestBody: [String: Any] = [
        "snippet": [
            "playlistId": MY_PLAYLIST_ID,
            "resourceId": [
                "channelId": POST_CHANEL_ID,
                "kind": "youtube#video",
                "playlistId": POST_PLAYLIST_ID,
                "videoId": POST_VIDEO_ID
            ]
        ]
    ]
    
    // Turn request body parameters into json and set them
    guard let httpBody = try? JSONSerialization.data(withJSONObject: requestBody) else {
        return
    }
    urlRequest.httpBody = httpBody
    
    let task = URLSession.shared.dataTask(with: urlRequest, completionHandler: {
        (data, response, error) in
        
        guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
        }
        
        guard let responseJSON = try? JSONSerialization.jsonObject(with: data) else {
            return
        }
        if let responseJSON = responseJSON as? [String: Any] {
                print(responseJSON)
        }
    })
    task.resume()
}

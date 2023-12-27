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
        URLQueryItem(name: "playlistId", value: PLAYLIST_ID),
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

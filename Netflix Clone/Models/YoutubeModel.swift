//
//  YoutubeModel.swift
//  Netflix Clone
//
//  Created by Burak AKCAN on 13.09.2022.
//

import Foundation

struct YoutubeModel:Codable {
    let items:[VideoElement]
    
}

struct VideoElement:Codable{
    let id:IdVideo
}
struct IdVideo:Codable{
    let kind:String
    let videoId:String
}





//items =     (
//            {
//        etag = "QkJ1fZbVUqVBkbv-1QP0mv9_AZU";
//        id =             {
//            kind = "youtube#video";
//            videoId = 13aQKxOg9uU;
//        };
//        kind = "youtube#searchResult";
//    }

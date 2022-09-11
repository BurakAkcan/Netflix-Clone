//
//  AppError.swift
//  Netflix Clone
//
//  Created by Burak AKCAN on 11.09.2022.
//

import Foundation


enum AppError:LocalizedError{
    case invalidUrl
    case unAbleToComplete
    case invalidResponse
    case invalidData
    case errorDecoding
   
    
    var errorDescription: String?{
        switch self {
        case .invalidUrl:
            return "This url an invalid request"
        case .unAbleToComplete:
            return "Unable to complete your request."
        case .invalidResponse:
            return "Invalid response from server"
        case .invalidData :
            return "The data received from server was invalid"
        case .errorDecoding:
            return "The data could not decode"
        
        }
    }
    
  
}


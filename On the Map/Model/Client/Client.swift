//
//  Client.swift
//  On the Map
//
//  Created by Ivan Zandonà on 06/11/2020.
//

import Foundation

class Client {
        
    struct Auth {
        static var accountKey = ""
        static var sessionId = ""
    }
    
    enum Endpoints {
        static let base = "https://onthemap-api.udacity.com/v1"
        
        case login
        case webSignUp
        case logout
        case getUserData
        case getStudentLocations
        case addStudentLocation
        
        var stringValue: String {
            switch self {
            case .login: return Endpoints.base + "/session"
            case .webSignUp: return "https://auth.udacity.com/sign-up"
            case .logout: return Endpoints.base + "/session"
            case .getUserData: return Endpoints.base + "/users/\(Auth.accountKey)"
            case .getStudentLocations: return Endpoints.base + "/StudentLocation?limit=100&order=updatedAt"
            case .addStudentLocation: return Endpoints.base + "/StudentLocation"
            }
        }
        
        var url: URL {
            return URL(string: stringValue)!
        }
    }
    
    class func taskForPOSTRequest<RequestType: Encodable, ResponseType: Decodable>(url: URL, responseType: ResponseType.Type, body: RequestType, completion: @escaping (ResponseType?, Error?) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let body = body
        request.httpBody = try! JSONEncoder().encode(body)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                completion(nil, error)
                return
            }
            
            let responseWithoutUselessSymbols = String(data: data, encoding: .utf8)?.replacingOccurrences(of: ")]}\'\n", with: "") ?? ""
            let correctData = responseWithoutUselessSymbols.data(using: .utf8)!
            
            let decoder = JSONDecoder()
            do {
                
                let responseObject = try decoder.decode(ResponseType.self, from: correctData)
                DispatchQueue.main.async {
                    completion(responseObject, nil)
                }
            } catch {
                do {
                    let errorResponse = try decoder.decode(ErrorResponse.self, from: correctData)
                    DispatchQueue.main.async {
                        completion(nil, errorResponse)
                    }
                } catch {
                    DispatchQueue.main.async {
                        completion(nil, error)
                    }
                }
            }
        }
        task.resume()
    }
    
    @discardableResult class func taskForGETRequest<ResponseType: Decodable>(url: URL, responseType: ResponseType.Type, completion: @escaping (ResponseType?, Error?) -> Void) -> URLSessionTask {
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }

            let responseWithoutUselessSymbols = String(data: data, encoding: .utf8)?.replacingOccurrences(of: ")]}\'\n", with: "") ?? ""
            let correctData = responseWithoutUselessSymbols.data(using: .utf8)!
            
            let decoder = JSONDecoder()
            do {
                let responseObject = try decoder.decode(ResponseType.self, from: correctData)
                DispatchQueue.main.async {
                    completion(responseObject, nil)
                }
            } catch {
                do {
                    let errorResponse = try decoder.decode(ErrorResponse.self, from: correctData)
                    DispatchQueue.main.async {
                        completion(nil, errorResponse)
                    }
                } catch {
                    DispatchQueue.main.async {
                        print(error.localizedDescription)
                        completion(nil, error)
                    }
                }
            }
        }
        task.resume()
        return task
    }
    
    class func login(username: String, password: String, completion: @escaping (Bool, Error?) -> Void) {
        let body = LoginRequest(udacity: LoginParameters(username: username, password: password))
        taskForPOSTRequest(url: Endpoints.login.url, responseType: LoginResponse.self, body: body) { (response, error) in
            if let response = response {
                if(response.account.registered) {
                    Auth.accountKey = response.account.key
                    Auth.sessionId = response.session.id
                    completion(true, nil)
                } else {
                    completion(false, nil)
                }
            } else {
                completion(false, error)
            }
        }
    }
    
    class func logout(completion: @escaping (Error?) -> Void) {
        var request = URLRequest(url: Endpoints.logout.url)
        request.httpMethod = "DELETE"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
          if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
          request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            completion(nil)
        }
        task.resume()
    }
    
    class func addLocation(locationData: NewLocation, completion: @escaping (Bool, Error?) -> Void) {
        let body = AddLocationRequest(uniqueKey: Auth.accountKey, firstName: UserModel.firstName, lastName: UserModel.lastName, mapString: locationData.locationText ?? "", mediaURL: locationData.locationLink ?? "", latitude: locationData.latitude ?? 0.0, longitude: locationData.longitude ?? 0.0)
        taskForPOSTRequest(url: Endpoints.addStudentLocation.url, responseType: AddLocationResponse.self, body: body) { (response, error) in
            if let response = response {
                completion(true, nil)
            } else {
                completion(false, error)
            }
        }
    }
    
    class func getStudentLocations(completion: @escaping ([StudentInformation], Error?) -> Void) {
        taskForGETRequest(url: Endpoints.getStudentLocations.url, responseType: GetStudentLocationsResponse.self) { (response, error) in
            if let response = response {
                completion(response.results, nil)
            } else {
                completion([], error)
            }
        }
    }
    
    class func getUserData(completion: @escaping (Bool, Error?) -> Void) {
        taskForGETRequest(url: Endpoints.getUserData.url, responseType: PublicUserDataResponse.self) { (response, error) in
            if let response = response {
                UserModel.firstName = response.firstName ?? ""
                UserModel.lastName = response.lastName ?? ""
                completion(true, nil)
            } else {
                completion(false, error)
            }
        }
    }
}

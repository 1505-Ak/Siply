import Foundation
import Combine

// MARK: - API Client
class APIClient {
    static let shared = APIClient()
    
    private let baseURL: String
    private let session: URLSession
    private var authToken: String?
    
    private init() {
        // Change this to your backend URL
        #if DEBUG
        self.baseURL = "http://localhost:8080/api"
        #else
        self.baseURL = "https://your-production-api.com/api"
        #endif
        
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 30
        config.timeoutIntervalForResource = 300
        self.session = URLSession(configuration: config)
        
        // Load saved tokens
        self.authToken = UserDefaults.standard.string(forKey: "accessToken")
    }
    
    // MARK: - Token Management
    func setAuthTokens(accessToken: String, refreshToken: String) {
        self.authToken = accessToken
        UserDefaults.standard.set(accessToken, forKey: "accessToken")
        UserDefaults.standard.set(refreshToken, forKey: "refreshToken")
    }
    
    func clearAuthToken() {
        self.authToken = nil
        UserDefaults.standard.removeObject(forKey: "accessToken")
        UserDefaults.standard.removeObject(forKey: "refreshToken")
    }
    
    func refreshAccessToken() -> AnyPublisher<AuthResponse, Error> {
        guard let refreshToken = UserDefaults.standard.string(forKey: "refreshToken") else {
            return Fail(error: APIError.serverError("No refresh token available")).eraseToAnyPublisher()
        }
        
        return request(
            endpoint: "/auth/refresh",
            method: "POST",
            body: ["refreshToken": refreshToken],
            requiresAuth: false
        )
    }
    
    // MARK: - Generic Request
    private func request<T: Decodable>(
        endpoint: String,
        method: String = "GET",
        body: [String: Any]? = nil,
        requiresAuth: Bool = true
    ) -> AnyPublisher<T, Error> {
        guard let url = URL(string: "\(baseURL)\(endpoint)") else {
            return Fail(error: APIError.invalidURL).eraseToAnyPublisher()
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Add auth token if required
        if requiresAuth, let token = authToken {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        // Add body if present
        if let body = body {
            request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        }
        
        return session.dataTaskPublisher(for: request)
            .tryMap { data, response in
                guard let httpResponse = response as? HTTPURLResponse else {
                    throw APIError.invalidResponse
                }
                
                if !(200...299).contains(httpResponse.statusCode) {
                    if let errorResponse = try? JSONDecoder().decode(ErrorResponse.self, from: data) {
                        throw APIError.serverError(errorResponse.message)
                    }
                    throw APIError.httpError(httpResponse.statusCode)
                }
                
                return data
            }
            .decode(type: T.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    // MARK: - Authentication
    func register(username: String, email: String, password: String, displayName: String) -> AnyPublisher<AuthResponse, Error> {
        request(
            endpoint: "/auth/register",
            method: "POST",
            body: [
                "username": username,
                "email": email,
                "password": password,
                "displayName": displayName
            ],
            requiresAuth: false
        )
    }
    
    func login(username: String, password: String) -> AnyPublisher<AuthResponse, Error> {
        request(
            endpoint: "/auth/login",
            method: "POST",
            body: [
                "username": username,
                "password": password
            ],
            requiresAuth: false
        )
    }
    
    func getCurrentUser() -> AnyPublisher<UserProfile, Error> {
        request(endpoint: "/auth/me")
    }
    
    // MARK: - Drinks
    func getDrinks(category: String? = nil, limit: Int = 50) -> AnyPublisher<DrinksResponse, Error> {
        var endpoint = "/drinks?limit=\(limit)"
        if let category = category {
            endpoint += "&category=\(category)"
        }
        return request(endpoint: endpoint)
    }
    
    func createDrink(drink: DrinkCreate) -> AnyPublisher<DrinkResponse, Error> {
        var body: [String: Any] = [
            "name": drink.name,
            "category": drink.category,
            "rating": drink.rating,
            "price": drink.price ?? NSNull(),
            "notes": drink.notes ?? "",
            "locationName": drink.locationName ?? "",
            "locationCity": drink.locationCity ?? "",
            "locationCountry": drink.locationCountry ?? "",
            "latitude": drink.latitude ?? NSNull(),
            "longitude": drink.longitude ?? NSNull()
        ]
        
        if let imageUrl = drink.imageUrl {
            body["imageUrl"] = imageUrl
        }
        
        return request(
            endpoint: "/drinks",
            method: "POST",
            body: body
        )
    }
    
    func updateDrink(id: String, updates: [String: Any]) -> AnyPublisher<DrinkResponse, Error> {
        request(
            endpoint: "/drinks/\(id)",
            method: "PUT",
            body: updates
        )
    }
    
    func deleteDrink(id: String) -> AnyPublisher<MessageResponse, Error> {
        request(
            endpoint: "/drinks/\(id)",
            method: "DELETE"
        )
    }
    
    // MARK: - Social
    func getFeed(limit: Int = 20, offset: Int = 0) -> AnyPublisher<FeedResponse, Error> {
        request(endpoint: "/social/feed?limit=\(limit)&offset=\(offset)")
    }
    
    func followUser(userId: String) -> AnyPublisher<MessageResponse, Error> {
        request(
            endpoint: "/social/follow/\(userId)",
            method: "POST"
        )
    }
    
    func unfollowUser(userId: String) -> AnyPublisher<MessageResponse, Error> {
        request(
            endpoint: "/social/follow/\(userId)",
            method: "DELETE"
        )
    }
    
    func likeDrink(drinkId: String) -> AnyPublisher<MessageResponse, Error> {
        request(
            endpoint: "/social/likes/\(drinkId)",
            method: "POST"
        )
    }
    
    func unlikeDrink(drinkId: String) -> AnyPublisher<MessageResponse, Error> {
        request(
            endpoint: "/social/likes/\(drinkId)",
            method: "DELETE"
        )
    }
    
    // MARK: - Venues
    func getVenues(city: String? = nil) -> AnyPublisher<VenuesResponse, Error> {
        var endpoint = "/venues"
        if let city = city {
            endpoint += "?city=\(city)"
        }
        return request(endpoint: endpoint)
    }
    
    func getNearbyVenues(latitude: Double, longitude: Double, radius: Double = 5) -> AnyPublisher<VenuesResponse, Error> {
        request(endpoint: "/venues/nearby/search?latitude=\(latitude)&longitude=\(longitude)&radius=\(radius)")
    }
    
    // MARK: - Achievements
    func getUserAchievements() -> AnyPublisher<AchievementsResponse, Error> {
        request(endpoint: "/achievements/user")
    }
    
    func checkAchievements() -> AnyPublisher<CheckAchievementsResponse, Error> {
        request(
            endpoint: "/achievements/check",
            method: "POST"
        )
    }
    
    // MARK: - Media Upload
    func uploadImage(_ imageData: Data, filename: String = "image.jpg") -> AnyPublisher<ImageUploadResponse, Error> {
        guard let url = URL(string: "\(baseURL)/media/upload") else {
            return Fail(error: APIError.invalidURL).eraseToAnyPublisher()
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        // Add auth token
        if let token = authToken {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        let boundary = UUID().uuidString
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        var body = Data()
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"file\"; filename=\"\(filename)\"\r\n".data(using: .utf8)!)
        body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
        body.append(imageData)
        body.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)
        
        request.httpBody = body
        
        return session.dataTaskPublisher(for: request)
            .tryMap { data, response in
                guard let httpResponse = response as? HTTPURLResponse else {
                    throw APIError.invalidResponse
                }
                
                if !(200...299).contains(httpResponse.statusCode) {
                    if let errorResponse = try? JSONDecoder().decode(ErrorResponse.self, from: data) {
                        throw APIError.serverError(errorResponse.message)
                    }
                    throw APIError.httpError(httpResponse.statusCode)
                }
                
                return data
            }
            .decode(type: ImageUploadResponse.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}

// MARK: - API Models
struct AuthResponse: Codable {
    let accessToken: String
    let refreshToken: String
    let user: UserProfile
}

struct UserProfile: Codable {
    let id: String
    let username: String
    let email: String
    let displayName: String
    let bio: String?
    let avatarUrl: String?
    let favoriteDrink: String?
    let followersCount: Int?
    let followingCount: Int?
    let totalDrinks: Int?
    let totalCities: Int?
    let totalCountries: Int?
}

struct DrinksResponse: Codable {
    let drinks: [APIDrink]
    let pagination: Pagination?
}

struct APIDrink: Codable {
    let id: String
    let userId: String
    let name: String
    let category: String
    let rating: Double
    let price: Double?
    let notes: String?
    let locationName: String?
    let locationCity: String?
    let locationCountry: String?
    let latitude: Double?
    let longitude: Double?
    let imageUrl: String?
    let likesCount: Int?
    let isLiked: Bool?
    let createdAt: String
}

struct DrinkCreate {
    let name: String
    let category: String
    let rating: Double
    let price: Double?
    let notes: String?
    let locationName: String?
    let locationCity: String?
    let locationCountry: String?
    let latitude: Double?
    let longitude: Double?
    let imageUrl: String?
}

struct DrinkResponse: Codable {
    let message: String
    let drink: APIDrink
}

struct FeedResponse: Codable {
    let feed: [APIDrink]
    let pagination: Pagination?
}

struct VenuesResponse: Codable {
    let venues: [APIVenue]
    let pagination: Pagination?
}

struct APIVenue: Codable {
    let id: String
    let name: String
    let category: String
    let city: String?
    let country: String?
    let latitude: Double?
    let longitude: Double?
    let hasStudentDiscount: Bool
    let hasHappyHour: Bool
    let isPartner: Bool
}

struct AchievementsResponse: Codable {
    let unlocked: [APIAchievement]
    let locked: [APIAchievement]
    let stats: AchievementStats
}

struct APIAchievement: Codable {
    let id: String
    let code: String
    let name: String
    let description: String?
    let icon: String
    let requirementType: String
    let requirementValue: Int
    let isUnlocked: Bool?
    let unlockedAt: String?
}

struct AchievementStats: Codable {
    let total: Int
    let unlocked: Int
    let locked: Int
}

struct CheckAchievementsResponse: Codable {
    let message: String
    let newlyUnlocked: [APIAchievement]
    let stats: [String: Int]
}

struct MessageResponse: Codable {
    let message: String
}

struct ErrorResponse: Codable {
    let error: String
    let message: String
}

struct Pagination: Codable {
    let limit: Int
    let offset: Int
    let total: Int?
}

struct ImageUploadResponse: Codable {
    let url: String
    let filename: String
    let size: Int
}

// MARK: - API Errors
enum APIError: LocalizedError {
    case invalidURL
    case invalidResponse
    case httpError(Int)
    case serverError(String)
    case decodingError
    case networkError
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .invalidResponse:
            return "Invalid response from server"
        case .httpError(let code):
            return "HTTP error: \(code)"
        case .serverError(let message):
            return message
        case .decodingError:
            return "Failed to decode response"
        case .networkError:
            return "Network error"
        }
    }
}



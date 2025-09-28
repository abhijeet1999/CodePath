//
//  UserAuthenticator.swift
//  BeReal
//
//  Created by Abhijeet Cherungottil on 9/24/25.
//

import UIKit

class UserAuthenticator {
    let userDefaultStorage: UserDefaults

    init(userDefaultStorage: UserDefaults = UserDefaults.standard) {
        self.userDefaultStorage = userDefaultStorage
    }

    func getUserDetails() -> User? {
        guard let value = userDefaultStorage.getCodableObject(dataType: User.self,
                                                              key: UserDefaultsKeys.userProfile) else { return nil }
        return value
    }

    func setUserRegister(_ userDetail: User?) {
        userDefaultStorage.setCodableObject(object: userDetail, forKey: UserDefaultsKeys.userProfile)    }

    func deleteFromUserDefault() {
        userDefaultStorage.removeObject(forKey: UserDefaultsKeys.userProfile)
    }
}

enum UserDefaultsKeys {
    static let userProfile = "userProfile"
}

extension UserDefaults {
    func setCodableObject(object data: (some Codable)?, forKey defaultName: String) {
        let encoded = try? JSONEncoder().encode(data)
        set(encoded, forKey: defaultName)
    }

    func getCodableObject<T: Codable>(dataType: T.Type, key: String) -> T? {
        guard let userDefaultData = data(forKey: key) else {
            return nil
        }
        return try? JSONDecoder().decode(T.self, from: userDefaultData)
    }
}

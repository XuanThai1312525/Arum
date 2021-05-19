//
//  Naver+Extension.swift
//  Arum
//
//  Created by trinhhc on 5/19/21.
//

import NaverThirdPartyLogin

extension NaverThirdPartyLoginConnection {
    static func isNaverLoginUrl(url: URL) -> Bool {
        return url.absoluteString.contains(Constants.Naver.URL_SCHEMA)
    }
}

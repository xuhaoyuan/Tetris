import Foundation

extension URLComponents {
    public mutating func append(querys: [URLQueryItem]?) {
        guard let querys = querys else { return }
        var tmp = queryItems ?? []
        tmp.append(contentsOf: querys)
        self.queryItems = tmp
    }

    public mutating func appendQuery(key: String, value: String) {
        let query = URLQueryItem(name: key, value: value)
        append(querys: [query])
    }
}

extension URLRequest {

    public var errorDescriptionForUser: String {
        guard let url = url, let httpMethod = httpMethod else { return "" }
        return "\(httpMethod) \(url.host ?? "")/\(url.path)"
    }

    public var cURLCommand: String {
        return cURLCommandWithSession(nil)
    }

    func cURLCommandWithSession(_ session: URLSession?, credential: URLCredential? = nil) -> String {

        var components = ["curl -i"]

        if let HTTPMethod = httpMethod, HTTPMethod != "GET" {
            components.append("-X \(HTTPMethod)")
        }

        if let URLString = url?.absoluteString {
            components.append("\"\(URLString)\"")
        }

        if let credentialStorage = session?.configuration.urlCredentialStorage {

            if let host = url?.host, let scheme = url?.scheme {
                let port = (url as NSURL?)?.port?.intValue ?? 0

                let protectionSpace = URLProtectionSpace(
                    host: host,
                    port: port,
                    protocol: scheme,
                    realm: host,
                    authenticationMethod: NSURLAuthenticationMethodHTTPBasic
                )

                if let credentials = credentialStorage.credentials(for: protectionSpace)?.values {

                    for credential in credentials {
                        if let user = credential.user, let password = credential.password {
                            components.append("-u \(user):\(password)")
                        }
                    }

                } else {
                    if let user = credential?.user, let password = credential?.password {
                        components.append("-u \(user):\(password)")
                    }
                }
            }
        }

        if let session = session, let URL = url {
            if session.configuration.httpShouldSetCookies {
                if let
                    cookieStorage = session.configuration.httpCookieStorage,
                    let cookies = cookieStorage.cookies(for: URL), !cookies.isEmpty {
                    let string = cookies.reduce("") { $0 + "\($1.name)=\($1.value);" }
                    components.append("-b \"\(string[..<string.endIndex])\"")
                }
            }
        }

        if let headerFields = allHTTPHeaderFields {

            for (field, value) in headerFields {
                switch field {
                case "Cookie":
                    continue
                default:
                    let escapedValue = value.replacingOccurrences(of: "\"", with: "\\\"")
                    components.append("-H \"\(field): \(escapedValue)\"")
                }
            }
        }

        if let additionalHeaders = session?.configuration.httpAdditionalHeaders as? [String: String] {

            for (field, value) in additionalHeaders {
                switch field {
                case "Cookie":
                    continue
                default:
                    let escapedValue = value.replacingOccurrences(of: "\"", with: "\\\"")
                    components.append("-H \"\(field): \(escapedValue)\"")
                }
            }
        }

        if let httpBody = httpBody {
            if let httpBodyString = String(data: httpBody, encoding: .utf8) {
                let escapedString = httpBodyString.replacingOccurrences(of: "\"", with: "\\\"")
                components.append("-d \"\(escapedString)\"")
            } else {
                print("can not append \(httpBody)")
            }
        }

        return components.joined(separator: " ")
    }
}

extension URLRequest {

    var curlCommandString: String {

        var curlCommandString = ["curl -v \(httpMethod!) "]

        curlCommandString.append("\'\(url!.absoluteURL)\' ")

        allHTTPHeaderFields?.forEach({
            curlCommandString.append("-H \'\($0): \($1)\' ")
        })

        if let cookies = HTTPCookieStorage.shared.cookies(for: url!), !cookies.isEmpty {
            curlCommandString.append("-H \'Cookie:")
            cookies.forEach {
                curlCommandString.append(" \($0.name)=\($0.value);")
            }
            curlCommandString.append("\' ")
        }

        if let tempHttpBody = httpBody, let length = allHTTPHeaderFields?["Content-Length"] {
            if Int(length) ?? 0 < 1024,
                let s = String(data: tempHttpBody, encoding: .utf8) {
                curlCommandString.append("-d \'\(s)\'")
            } else {
                curlCommandString.append("[TOO MUCH DATA TO INCLUDE]")
            }
        }
        return curlCommandString.joined()
    }
}

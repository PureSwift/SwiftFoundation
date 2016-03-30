//
//  URLClient.swift
//  SwiftFoundation
//
//  Created by Alsey Coleman Miller on 7/20/15.
//  Copyright © 2015 PureSwift. All rights reserved.
//

public protocol URLClient {
	
	associatedtype Request: URLRequest
	
	associatedtype Response: URLResponse
	
	func sendRequest(request: Request) throws -> Response
}
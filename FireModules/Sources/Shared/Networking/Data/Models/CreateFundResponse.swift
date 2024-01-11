//
//  CreateFundResponse.swift
//
//
//  Created by Hien Tran on 10/01/2024.
//

import Codextended
import Foundation

public struct CreateFundResponse: Decodable, Equatable, Identifiable {
    public let id: String
    public let creatorId: String
    public let balance: Double
    public let fundType: FundType
    public let name: String
    public let currency: String
    public let description: String?

    public init(from decoder: Decoder) throws {
        self.id = try decoder.decode("fundId")
        self.creatorId = try decoder.decode("creatorId")
        self.balance = try decoder.decode("balance")
        self.fundType = try decoder.decode("fundType")
        self.name = try decoder.decode("name")
        self.currency = try decoder.decode("currency")
        self.description = try decoder.decodeIfPresent("description")
    }
}

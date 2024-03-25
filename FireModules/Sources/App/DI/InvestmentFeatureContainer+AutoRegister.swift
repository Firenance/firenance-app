//
//  InvestmentFeatureContainer+AutoRegister.swift
//
//
//  Created by Hien Tran on 18/03/2024.
//

// swiftlint:disable force_unwrapping

extension InvestmentFeatureContainer: AutoRegistering {
    public func autoRegister() {
        investmentUseCase.register { resolve(\.investmentUseCase) }
        investmentHomeReducer.register {
            InvestmentHomeReducer(investmentUseCase: self.investmentUseCase.resolve()!)
        }
        investmentPortfolioReducer.register {
            InvestmentPortfolioReducer(investmentUseCase: self.investmentUseCase.resolve()!)
        }
        investmentTradeImportOptionsReducer.register {
            InvestmentTradeImportOptionsReducer()
        }
        addInvestmentTradeReducer.register {
            RecordPortfolioTransactionReducer(investmentUseCase: self.investmentUseCase.resolve()!)
        }

        currencyPickerReducer.register {
            CurrencyPickerReducer()
        }
    }
}

// swiftlint:enable force_unwrapping

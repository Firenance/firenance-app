import ComposableArchitecture
import CoreUI
import DomainEntities
import InvestmentFeature
import SwiftUI

public struct MiniApp: View {
    @ObserveInjection private var iO

    struct ViewState: Equatable {
        var logInState: LoadingState<AuthenticatedUserEntity>
    }

    let store: StoreOf<MiniAppReducer>
    @ObservedObject var viewStore: ViewStore<ViewState, MiniAppReducer.Action>

    public init(store: StoreOf<MiniAppReducer>) {
        self.store = store
        self.viewStore = ViewStore(self.store, observe: \.viewState)
    }

    public var body: some View {
        LoadingOverlay(loading: viewStore.logInState.isLoading) {
            NavigationStack {
                VStack(alignment: .leading) {
                    Text("Log in").typography(.titleScreen)
                    Spacer()
                    Button(
                        action: { viewStore.send(.forward(.logIn)) },
                        label: {
                            Text("Retry log in")
                        }
                    )
                    .fireButtonStyle()
                    Spacer()
                }
                .padding()
                .navigationBarHidden(true)
                .navigationDestination(
                    store: store.scope(
                        state: \.$destination.miniAppEntryRoute,
                        action: \.destination.miniAppEntryRoute
                    )
                ) { InvestmentHomePage(store: $0) }
//                ) { StockSearchHomePage(store: $0) }
            }
        }
        .task {
            viewStore.send(.forward(.logIn))
        }
        .enableInjection()
    }
}

extension BindingViewStore<MiniAppReducer.State> {
    var viewState: MiniApp.ViewState {
        // swiftformat:disable redundantSelf
        MiniApp.ViewState(
            logInState: self.logInState
        )
        // swiftformat:enable redundantSelf
    }
}

//
//  Copyright © 2018 Gnosis Ltd. All rights reserved.
//

import XCTest
@testable import IdentityAccessApplication
import IdentityAccessDomainModel
import IdentityAccessImplementations

class ApplicationServiceTestCase: XCTestCase {

    let authenticationService = AuthenticationApplicationService()
    let identityService = IdentityApplicationService()
    let userRepository: UserRepository = InMemoryUserRepository()
    let biometricService = MockBiometricService()
    let encryptionService = MockEncryptionService()
    let gatekeeperRepository = InMemoryGatekeeperRepository()
    let identityDomainService = IdentityService()
    var clockService = MockClockService()

    override func setUp() {
        super.setUp()
        configureIdentityServiceDependencies()
        configureAuthenticationServiceDependencies()
        configureAccountDependencies()
    }

    private func configureIdentityServiceDependencies() {
        ApplicationServiceRegistry.put(service: identityService, for: IdentityApplicationService.self)
        ApplicationServiceRegistry.put(service: clockService, for: Clock.self)
    }

    private func configureAuthenticationServiceDependencies() {
        ApplicationServiceRegistry.put(service: authenticationService,
                                       for: AuthenticationApplicationService.self)
        DomainRegistry.put(service: userRepository, for: UserRepository.self)
        DomainRegistry.put(service: biometricService, for: BiometricAuthenticationService.self)
        DomainRegistry.put(service: encryptionService, for: EncryptionServiceProtocol.self)
        DomainRegistry.put(service: identityDomainService, for: IdentityService.self)
        DomainRegistry.put(service: gatekeeperRepository, for: GatekeeperRepository.self)
        DomainRegistry.put(service: clockService, for: Clock.self)

        XCTAssertNoThrow(try DomainRegistry.identityService.provisionGatekeeper(sessionDuration: 2,
                                                                                maxFailedAttempts: 2,
                                                                                blockDuration: 1))
    }

    private func configureAccountDependencies() {
        DomainRegistry.put(service: MockKeychain(), for: SecureStore.self)
        DomainRegistry.put(service: InMemoryKeyValueStore(), for: KeyValueStore.self)
    }
}

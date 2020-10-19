//
//  Koin.swift
//  EnvidualFinance
//
//  Created by Maximilian Fehrentz on 12.08.20.
//  Copyright © 2020 Maximilian Fehrentz. All rights reserved.
//

import Foundation
import shared

func startKoin() {

    let userDefaults = UserDefaults(suiteName: "EnvidualFinanceDatabase")!
    let iosAppInfo = IosAppInfo()
    let doOnStartup: () -> () = {}


    let koinApplication = KoinIOSKt.doInitKoinIos(userDefaults: userDefaults, appInfo: iosAppInfo, doOnStartup: doOnStartup)
    _koin = koinApplication.koin
}

private var _koin: Koin_coreKoin? = nil
var koin: Koin_coreKoin {
    return _koin!
}

func resolve<T: AnyObject>() -> T {
    koin.get(objCClass: T.self, qualifier: nil) as! T
}

class IosAppInfo: AppInfo {
    let appId: String = Bundle.main.bundleIdentifier!
}


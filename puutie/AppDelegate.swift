//
//  AppDelegate.swift
//  puutie
//
//  Created by Gurhan on 11/18/25.
//

import FirebaseCore
import FirebaseMessaging
import UIKit


@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication
            .LaunchOptionsKey: Any]?
    ) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        // 2) FCM delegate ata (token almak için)
        Messaging.messaging().delegate = self

        // 3) Bildirim izinleri iste
        UNUserNotificationCenter.current().delegate = self

        /*
        Messaging.messaging().token { token, error in
            if let error = error {
                print("Error fetching FCM registration token: \(error)")
            }
            else if let token = token {
                print("FCM registration token: \(token)")
                let splitID = token.components(separatedBy: ":")
                DispatchQueue.main.async {
                    FireBaseFCMID = "\(splitID[0])"
                }
            }
        }
         */

        // izin ayarlari
        let options: UNAuthorizationOptions = [.alert, .badge, .sound]

        // kullanicidan izin iste
        UNUserNotificationCenter.current().requestAuthorization(
            options: options
        ) { granted, error in
            guard granted else {
                if let error = error {
                    print("🔔 Notification permission error: \(error)")
                }
                return
            }
            print("🔔 Notification permission granted: \(granted)")
            // kullanici izin vermis ise
            // 4) APNs'e register ol (device token almak için)
            DispatchQueue.main.async {
                application.registerForRemoteNotifications()
            }
        }
        return true
    }

    // MARK: - APNs device token
    // application.registerForRemoteNotifications()'i hatirla biz burda APNs'e device token istegi yollamistik
    // cevap olumluysa burda bize token'i veriyor
    func application(
        _ application: UIApplication,
        didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
    ) {
        // APNs token'ı FCM'e veriyoruz
        Messaging.messaging().apnsToken = deviceToken
        print("📲 APNs token set on Messaging")
    }

    // application.registerForRemoteNotifications()'i hatirla biz burda APNs'e device token istegi yollamistik
    // cevap olumsuzsa burda bize ilgili error'i veriyoe
    func application(
        _ application: UIApplication,
        didFailToRegisterForRemoteNotificationsWithError error: Error
    ) {
        print("❌ Failed to register for remote notifications: \(error)")
    }

    func application(
        _ application: UIApplication,
        configurationForConnecting connectingSceneSession: UISceneSession,
        options: UIScene.ConnectionOptions
    ) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(
            name: "Default Configuration",
            sessionRole: connectingSceneSession.role
        )
    }

    func application(
        _ application: UIApplication,
        didDiscardSceneSessions sceneSessions: Set<UISceneSession>
    ) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

}

extension AppDelegate: MessagingDelegate {
    func messaging(
        _ messaging: Messaging,
        didReceiveRegistrationToken fcmToken: String?
    ) {
        print("🔥 FCM registration token: \(String(describing: fcmToken))")
        
        guard let token = fcmToken else { return }
        
        AppContainer.shared.pushNotificationTokenService.register(with: token) { result in
            let res = result
        }

        // Burada token'ı backend'ine gönderirsin
        // örn: TokenManager.shared.updateFCMToken(fcmToken)
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {

    // Uygulama öndeyken bildirim gelince nasıl davranacağını belirler
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler:
            @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        // Banner + ses + badge göster
        completionHandler([.banner, .sound, .badge])
    }

    // Bildirime tıklanınca ne olsun (arka plandan/kapalıyken açınca)
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void
    ) {
        let userInfo = response.notification.request.content.userInfo
        print("🔔 Notification tapped, userInfo: \(userInfo)")

        // Burada deep link / belirli sayfaya yönlendirme vb yaparsın

        completionHandler()
    }

}

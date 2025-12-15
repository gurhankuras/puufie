//
//  NotificationService.swift
//  Payload Modification
//
//  Created by Gurhan on 11/28/25.
//

import UserNotifications

class NotificationService: UNNotificationServiceExtension {

    var contentHandler: ((UNNotificationContent) -> Void)?
    var bestAttemptContent: UNMutableNotificationContent?

    override func didReceive(
        _ request: UNNotificationRequest,
        withContentHandler contentHandler:
            @escaping (UNNotificationContent) -> Void
    ) {
        self.contentHandler = contentHandler

        guard
            let content =
                (request.content.mutableCopy() as? UNMutableNotificationContent)
        else {
            contentHandler(request.content)
            return
        }

        print("📩 Extension didReceive çalıştı")
        print("👀 userInfo: \(request.content.userInfo)")

        self.bestAttemptContent = content

        content.title = "\(content.title) [modified]"

        guard
            let urlString = content.userInfo["imageUrl"] as? String,
            let url = URL(string: urlString)
        else {
            // Resim yoksa direkt gönder
            contentHandler(content)
            return
        }

        let tmpDir = URL(fileURLWithPath: NSTemporaryDirectory())
        let tmpFile = tmpDir.appendingPathComponent(
            url.lastPathComponent
        )
        
        defer { contentHandler(content) }


        let data = try? Data(contentsOf: url)
        try? data?.write(to: tmpFile)
        // 4
        let attachment = try! UNNotificationAttachment(
        identifier: "",
        url: tmpFile)
        
        content.attachments = [attachment]
    }

    override func serviceExtensionTimeWillExpire() {
        // Called just before the extension will be terminated by the system.
        // Use this as an opportunity to deliver your "best attempt" at modified content, otherwise the original push payload will be used.
        if let contentHandler = contentHandler,
            let bestAttemptContent = bestAttemptContent
        {
            contentHandler(bestAttemptContent)
        }
    }

}

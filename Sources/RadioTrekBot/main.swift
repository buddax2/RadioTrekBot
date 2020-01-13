//
//  File.swift
//  
//
//  Created by Oleksandr Yakubchyk on 14.01.2020.
//

import Foundation
import Telegrammer

let bot = try! Bot(token: "RADIOTREK_BOT_TOKEN")

struct Song: Codable {
    var id: Int?
    var songID: String
    var rawTitle: String
    var isBanned: Bool
}

extension String {
    /// Escapes HTML entities in a `String`.
    func htmlEscaped() -> String {
        /// FIXME: performance
        return replacingOccurrences(of: "&", with: "&amp;")
            .replacingOccurrences(of: "\"", with: "&quot;")
            .replacingOccurrences(of: "'", with: "&#39;")
            .replacingOccurrences(of: "<", with: "&lt;")
            .replacingOccurrences(of: ">", with: "&gt;")
        .replacingOccurrences(of: " ", with: "+")
    }
}

let commandHandler = CommandHandler(commands: ["/hello"], callback: { (update, _) in
    guard let message = update.message, let user = message.from else { return }
    try! message.reply(text: "Hello \(user.firstName)", from: bot)
})

let dispatcher = Dispatcher(bot: bot)
dispatcher.add(handler: commandHandler)

_ = try! Updater(bot: bot, dispatcher: dispatcher).startLongpolling().wait()

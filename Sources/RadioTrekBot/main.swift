//
//  File.swift
//  
//
//  Created by Oleksandr Yakubchyk on 14.01.2020.
//

import Foundation
import Telegrammer

var bot = try! Bot(token: token)

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

func inlineKeyboard(with buttons: [Song]) -> InlineKeyboardMarkup {
    let inlineButtons: [[InlineKeyboardButton]] = buttons.map {
        let inlineButton = InlineKeyboardButton(text: $0.rawTitle, url: "https://music.youtube.com/search?q=\($0.rawTitle.htmlEscaped())")

        return [inlineButton]
    }

    return InlineKeyboardMarkup(inlineKeyboard: inlineButtons)
}

func getRandomPlaylist(update: Update) {
    let task = URLSession.shared.dataTask(with: URL(string: "\(apiURL)/random")!) { (data, response, error) in
        guard let data = data else { return }
        guard error == nil else { return }
        guard let message = update.message else { return }
        
        do {
            let decoder = JSONDecoder()
            let songs = try decoder.decode([Song].self, from: data)

            let keyboard = inlineKeyboard(with: songs)

            try! message.delete(from: bot)
            try! bot.sendMessage(params: Bot.SendMessageParams(chatId: ChatId.chat(message.chat.id), text: "5 випадкових пісень", parseMode: .markdown, replyMarkup: ReplyMarkup.inlineKeyboardMarkup(keyboard)))
        } catch {
            print(error)
        }
    }
    task.resume()
}

let messageHandler = MessageHandler { (update, context) in
    getRandomPlaylist(update: update)
}
let commandHandler = CommandHandler(commands: ["/hello"], callback: { (update, _) in
    guard let message = update.message, let user = message.from else { return }
    try! message.reply(text: "Hello \(user.firstName)", from: bot)
})

let dispatcher = Dispatcher(bot: bot)
dispatcher.add(handler: commandHandler)
dispatcher.add(handler: messageHandler)

_ = try! Updater(bot: bot, dispatcher: dispatcher).startLongpolling().wait()

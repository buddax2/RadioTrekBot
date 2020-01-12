import Foundation
import TelegramBotSDK

let token = readToken(from: "RADIOTREK_BOT_TOKEN")
let apiURL = readToken(from: "PLAYLIST_API_URL")

let bot = TelegramBot(token: token)

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
        var inlineButton = InlineKeyboardButton()
        inlineButton.text = $0.rawTitle
        inlineButton.url = "https://music.youtube.com/search?q=\($0.rawTitle.htmlEscaped())"

        return [inlineButton]
    }

    var keyboardMarkup = InlineKeyboardMarkup()
    keyboardMarkup.inlineKeyboard = inlineButtons

    return keyboardMarkup
}

while let update = bot.nextUpdateSync() {
    if let message = update.message, let from = message.from {
        
        let task = URLSession.shared.dataTask(with: URL(string: "\(apiURL)/random")!) { (data, response, error) in
            guard let data = data else { return }
            guard error == nil else { return }
            
            do {
                let decoder = JSONDecoder()
                let songs = try decoder.decode([Song].self, from: data)

                let keyboard = inlineKeyboard(with: songs)

                bot.deleteMessageAsync(chatId: from.id, messageId: message.messageId)
                bot.sendMessageAsync(chatId: from.id, parseMode: "markdown", replyMarkup: keyboard, text: "5 випадкових пісень") { message, error in
//                    print(message)
                }
            } catch {
                print(error)
            }
        }
        task.resume()
    }
}

fatalError("Server stopped due to error: \(bot.lastError)")

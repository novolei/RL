//
//  Message.swift
//  RL
//
//  Created by Ryan Liu on 2022/9/17.
//

// var id: String { get }
// var text: String { get }
//
// var sender: String { get }
////    var sentState: MXEventSentState { get }
// var showSender: Bool { get }
// var timestamp: String { get }
//
// var reactions: [Reaction] { get }
class ChatTile {
    
    
    public var chatUser: ChatUser
    public var messageStatus: MessageStatus
    
    init(chatUser: ChatUser, messageStatus: MessageStatus) {
        self.chatUser = chatUser
        self.messageStatus = messageStatus
    }
}
class Message: Identifiable {
    public let id: String
    public let message: String
    public let sender: String
    public let userId: String
    public let toID: String
    public let room: String
//    public let showsender: Bool = true
//    public let timestamp: String

    init(id: String, message: String, sender: String, userId: String, toID: String, room: String) {
        self.id = id
        self.message = message
        self.sender = sender
        self.userId = userId
        self.toID = toID
        self.room = room
//        self.timestamp = timestamp
    }

    public static func from(map: [String: Any]) -> Message {
        return Message(
            id: map["$id"] as? String ?? "",
            message: map["message"] as! String,
            sender: map["sender"] as! String,
            userId: map["userID"] as? String ?? "",
            toID: map["toID"] as? String ?? "",
            room: map["room"] as? String ?? ""
//            timestamp: map["createdAt"] as? Double.dateFormatted(withFormat:"HH:mm")
        )
    }
//    public let sentState: SentState
//    public let timestamp: Date
//    public let reactions: [Reaction]
//    public let type: SentState
//    public let isEdit: Bool
//    public let content: String
//    public let contentHasBeenEdited: Bool
//    public let isMe: Bool
}

public enum MessageStatus {
    case writing
    case sending
    case dilvered
    case newUser
    case read
    case unRead
    case failed
}

public enum SentState {
    case writing
    case sending
    case dilvered
    case read
    case failed

//    MXEventSentStateSent,
//    /**
//     The event is an outgoing event which is preparing by converting the data to sent, or uploading additional data.
//     */
//    MXEventSentStatePreparing,
//    /**
//     The event is an outgoing event which is encrypting.
//     */
//    MXEventSentStateEncrypting,
//    /**
//     The data for the outgoing event is uploading. Once complete, the state will move to `MXEventSentStateSending`.
//     */
//    MXEventSentStateUploading,
//    /**
//     The event is an outgoing event in progress.
//     */
//    MXEventSentStateSending,
//    /**
//     The event is an outgoing event which failed to be sent.
//     See the `sentError` property to check the failure reason.
//     */
//    MXEventSentStateFailed
}

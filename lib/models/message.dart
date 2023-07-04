


// class Message {
//   final String id;
//   final String senderId;
//   final String text;
//   final Timestamp timestamp;

//   Message({
//     required this.id,
//     required this.senderId,
//     required this.text,
//     required this.timestamp,
//   });
// }


//   Map<String, dynamic> toMap() {
//     return {
//       'senderId': senderId,
//       'recieverid': recieverid,
//       'text': text,
//       'type': type.type,rrrrrrrrrrrrrrrrrrrrrrr
//       'timeSent': timeSent.millisecondsSinceEpoch,
//       'messageId': messageId,
//       'isSeen': isSeen,
//       'repliedMessage': repliedMessage,
//       'repliedTo': repliedTo,
//       'repliedMessageType': repliedMessageType.type,
//     };
//   }

//   factory Message.fromMap(Map<String, dynamic> map) {
//     return Message(
//       senderId: map['senderId'] ?? '',
//       recieverid: map['recieverid'] ?? '',
//       text: map['text'] ?? '',
//       type: (map['type'] as String).toEnum(),
//       timeSent: DateTime.fromMillisecondsSinceEpoch(map['timeSent']),
//       messageId: map['messageId'] ?? '',
//       isSeen: map['isSeen'] ?? false,
//       repliedMessage: map['repliedMessage'] ?? '',
//       repliedTo: map['repliedTo'] ?? '',
//       repliedMessageType: (map['repliedMessageType'] as String).toEnum(),
//     );
//   }
// }
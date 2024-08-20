import 'package:beauty_hack/screens/chat/message_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:intl/intl.dart';


class ChatScreen extends StatefulWidget {
  // final String chatID;
  // final int index;
  // final List<dynamic> detail_listing;
  // final bool is_old_chat;
  // final Map<String, List<dynamic>>? messagesList;

 const ChatScreen({super.key});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {

  TextEditingController _messageController = TextEditingController();

  List<Message> messages = [
    Message(
      userID: '123', 
      text: 'text', 
      date: DateTime.now().subtract(Duration(minutes: 1)), 
      isSentByMe: false
    ),
    Message(
      userID: '123', 
      text: 'dsjjkjds text', 
      date: DateTime.now().subtract(Duration(minutes: 1)), 
      isSentByMe: false
    ),
    Message(
      userID: '123', 
      text: 'text hhjdshhjd', 
      date: DateTime.now().subtract(Duration(minutes: 1)), 
      isSentByMe: false
    ),
    Message(
      userID: '123', 
      text: 'text', 
      date: DateTime.now().subtract(Duration(minutes: 1)), 
      isSentByMe: true
    ),

  ].reversed.toList();


  @override
  Widget build(BuildContext context) {
       
    return Scaffold(
      appBar: AppBar(
        leading: IconButton( icon: Icon( Icons.arrow_back,color: Colors.white,), onPressed: () {
            Navigator.pop(context);
            // Navigator.pushReplacement(
            //   context, MaterialPageRoute(builder: (context) => MarketPage())); 
        },),
        backgroundColor: Colors.blueGrey.shade700, title: Text('', style: TextStyle(color: Colors.white, fontSize: 15.sp),)
        ),
        body: 
          Column(
          children: [
           Expanded(
              child: GroupedListView<Message, DateTime>(
                reverse: true,
                order: GroupedListOrder.DESC,
                useStickyGroupSeparators: true,
                floatingHeader: true,
                  padding: EdgeInsets.all(8.sp), 
                  elements: messages, 
                  groupBy: (message) => DateTime(
                    message.date.year,
                    message.date.month,
                    message.date.day,
                  ),
                  groupHeaderBuilder: (Message message) => SizedBox(
                    height: 45.h,
                    child: Center(
                      child: Card(
                        color: Colors.blueGrey.shade700,
                        child: Padding(
                          padding: EdgeInsets.all(8.sp),
                          child: Text(
                            DateFormat.yMMMd().format(message.date),
                            style: const TextStyle(color: Colors.white,),
                          ),
                        ),
                      ),
                    ),
                  ),
                  itemBuilder: (context, Message message) => Align(
                    alignment: message.isSentByMe? Alignment.centerRight: Alignment.centerLeft,
                    child: message.isSentByMe? Padding(
                      padding: EdgeInsets.only(left: 50.0.w),
                      child: Card(
                        color: message.isSentByMe? Colors.grey.shade400 : Colors.blueGrey.shade700,
                        elevation: 8,
                        child: Padding(
                          padding: EdgeInsets.all(12.sp),
                          child: Column(
                            children: [
                              Text(message.text, style: TextStyle(color:  Colors.white, fontSize: 14.sp),),
                              //Text(message.date, style: TextStyle( fontSize: 10.sp,color:  Colors.white54),),
                            ],
                          ),),
                      ),
                    )
                    :Padding(
                      padding: EdgeInsets.only(right: 50.0.w),
                      child: Card(
                        color: message.isSentByMe? Colors.grey.shade400 : Colors.blueGrey.shade700,
                        elevation: 8,
                        child: Padding(
                          padding: EdgeInsets.all(12.sp),
                          child: Column(
                            children: [
                              Text(message.text, style: TextStyle(color:  Colors.white, fontSize: 14.sp),),
                              //Text('', style: TextStyle( fontSize: 10.sp,color:  Colors.white54),),
                            ],
                          ),),
                      ),
                    ),
                  ),

              ),
            ),
            _buildUserInput(),
        ]),
    );
  }

  Widget _buildUserInput() {
    return Container(
      color: Colors.grey.shade200,
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _messageController,
                obscureText: false,
                cursorColor: Colors.black,
                decoration: InputDecoration(
                  hintText: 'Type a message',
                  hoverColor: Colors.blueGrey,
                  contentPadding:  EdgeInsets.all(12.sp),
                  hintStyle: TextStyle(fontSize: 15.sp)
                ),
                onSubmitted: (text) {
                  //widget.is_old_chat == false? sendMessageNew(text): sendMessage(text);
                  final message = Message(
                    userID: '123', 
                    text: text, 
                    date: DateTime.now(), 
                    isSentByMe: true
                  );
                  setState(() {
                    messages.add(message);
                  });
                  _messageController.clear();
                },
              ),
            ),
            IconButton(onPressed: (){
              final message = Message(
                    userID: '123', 
                    text: _messageController.text, 
                    date: DateTime.now(), 
                    isSentByMe: true
                  );
                  setState(() {
                    messages.add(message);
                  });
              _messageController.clear();
              }, icon: Icon(Icons.arrow_upward)),
          ],
        ),
    );
  }
}



import 'package:chatt/core/firebase/firebase_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../Profile/model/users_info.dart';
import '../logic/chat_cubit.dart';
import '../logic/chat_state.dart';
import '../model/chat_model.dart';

class ChatScreen extends StatelessWidget {
  final UserProfile userProfile;

  const ChatScreen({super.key, required this.userProfile});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
        child: Column(
          children: [
            Expanded(
                child: Container(
              child: Column(
                children: [
                  BlocBuilder<MessageCubit, MessageState>(
                      builder: (context, state) {
                    if (state is MessagesLoading) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    if (state is MessagesLoaded) {
                      return ListView.builder(
                          itemCount: state.messages.length,
                          itemBuilder: (context, index) {
                            final mess = state.messages[index];
                            bool isMeChatting =
                                mess.fromId == FireBaseDataAll().myUid;
                            return Align(
                              alignment: isMeChatting
                                  ? Alignment.centerRight
                                  : Alignment.centerLeft,
                              child: Container(
                                width: MediaQuery.of(context).size.width * 0.65,
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    borderRadius: isMeChatting
                                        ? const BorderRadius.only(
                                            topLeft: Radius.circular(12),
                                            bottomLeft: Radius.circular(12),
                                            bottomRight: Radius.circular(12),
                                          )
                                        : const BorderRadius.only(
                                            topLeft: Radius.circular(12),
                                            bottomLeft: Radius.circular(12),
                                            bottomRight: Radius.circular(12),
                                          ),
                                    color: isMeChatting
                                        ? Colors.blue.shade200
                                        : Colors.blue.shade700),
                                margin: const EdgeInsets.all(8),
                                child: Text(
                                  mess.msg,
                                  style: TextStyle(
                                      fontSize: 15,
                                      color: isMeChatting
                                          ? Colors.black
                                          : Colors.white),
                                  textAlign: TextAlign.start,
                                ),
                              ),
                            );
                          });
                    }
                    if (state is MessagesError) {
                      return Center(child: Text(state.error.toString()));
                    }
                    return const Center(
                      child: Text('Get Start'),
                    );
                  }),

                  // ChatMassageTest(
                  //   isMeChatting: true,
                  //   massageBody: 'Hello, Iam ${userProfile.name}',
                  // ),
                  // ChatMassageTest(
                  //   isMeChatting: false,
                  //   massageBody: 'Welcome bro',
                  // ),
                  // ChatMassageTest(
                  //   isMeChatting: true,
                  //   massageBody: 'How are you?',
                  // ),
                  // ChatMassageTest(
                  //   isMeChatting: false,
                  //   massageBody: 'I am fine, what about you?',
                  // ),
                  // ChatMassageTest(
                  //   isMeChatting: true,
                  //   massageBody: 'I am fine',
                  // ),
                  // ChatMassageTest(
                  //   isMeChatting: false,
                  //   massageBody:
                  //       'تجربة تجربة تجربة تجربة تجربة تجربة تجربة تجربة تجربة تجربة تجربة تجربة تجربة تجربة تجربة تجربة تجربة تجربة',
                  // ),
                ],
              ),
            )),
            Row(
              children: [
                //chats test here
                Expanded(
                  child: Card(
                    child: TextField(
                      controller: context.read<MessageCubit>().messageContrller,
                      maxLines: 5,
                      minLines: 1,
                      decoration: InputDecoration(
                        suffixIcon: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              onPressed: () {},
                              icon: const Icon(Icons.add_circle),
                            ),
                            IconButton(
                              onPressed: () {},
                              icon: const Icon(Icons.emoji_emotions_outlined),
                            ),
                            IconButton(
                              onPressed: () {},
                              icon: const Icon(Icons.mic_rounded),
                            ),
                          ],
                        ),
                        border: InputBorder.none,
                        hintText: "Message",
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(0),
                  decoration: BoxDecoration(
                      color: Colors.blue,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2.5)),
                  child: IconButton(
                    onPressed: () {
                      final mes =
                          context.read<MessageCubit>().messageContrller.text;
                      if (mes.isNotEmpty) {
                        context
                            .read<MessageCubit>()
                            .sendMessage(userProfile.id, "text");
                        print(mes);
                      }
                      context.read<MessageCubit>().messageContrller.clear();
                    },
                    icon: const Icon(
                      Icons.send,
                      color: Colors.white,
                      size: 27,
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    final DateTime lastActivated = DateTime.parse(userProfile.lastActivated);
    final formattedTime = DateFormat.jm().format(lastActivated);

    return AppBar(
      toolbarHeight: 80,
      title: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              const CircleAvatar(
                backgroundImage: AssetImage('assets/user-avatar.png'),
                minRadius: 30,
                backgroundColor: Colors.blue,

                // child: Image.asset('assets/user-avatar.png'),
              ),
              if (userProfile.online)
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(2.5),
                    decoration: BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2.5)),
                    child: const Icon(
                      Icons.brightness_1,
                      size: 8,
                      color: Colors.green,
                    ),
                  ),
                )
              else
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(2.5),
                    decoration: BoxDecoration(
                        color: Colors.black38,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2.5)),
                    child: const Icon(
                      Icons.brightness_1_outlined,
                      size: 8,
                      color: Colors.black38,
                    ),
                  ),
                ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  userProfile.name,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 2,
                ),
                if (userProfile.online)
                  const Text(
                    'Active Now',
                    style: TextStyle(
                      color: Colors.green,
                      fontSize: 13,
                      // fontWeight: FontWeight.w300,
                    ),
                  )
                else
                  Text(
                    'Last Active $formattedTime',
                    style: const TextStyle(
                      color: Colors.black54,
                      fontSize: 13,
                      // fontWeight: FontWeight.w300,
                    ),
                  )
              ],
            ),
          ),
        ],
      ),
      actions: const [
        Padding(
          padding: EdgeInsets.only(right: 10),
          child: Icon(
            Icons.call,
            size: 35,
          ),
        ),
        Padding(
          padding: EdgeInsets.only(right: 10),
          child: Icon(
            Icons.videocam,
            size: 35,
          ),
        ),
        Padding(
          padding: EdgeInsets.only(right: 6),
          child: Icon(
            Icons.more_vert,
            size: 35,
          ),
        ),
      ],
    );
  }

  chats() {
    return Expanded(child:
        BlocBuilder<MessageCubit, MessageState>(builder: (context, state) {
      if (state is MessagesLoading) {
        return Center(
          child: CircularProgressIndicator(),
        );
      }
      if (state is MessagesLoaded) {
        return ListView.builder(
            reverse: true,
            itemCount: state.messages.length,
            itemBuilder: (context, index) {
              final meg = state.messages[index];
              bool isme = meg.fromId == FireBaseDataAll().myUid;
              return Align(
                alignment: isme ? Alignment.centerRight : Alignment.centerLeft,
                child: Card(
                  margin: EdgeInsets.all(10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      bottomLeft: isme ? Radius.circular(16) : Radius.zero,
                      bottomRight: isme ? Radius.zero : Radius.circular(16),
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                  ),
                  color: isme ? Colors.blue : Colors.blueGrey,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        meg.type == "text"
                            ? Text(meg.msg)
                            : Image.network(
                                meg.msg,
                                width: 150,
                                height: 150,
                                fit: BoxFit.cover,
                              ),
                        SizedBox(
                          height: 3,
                        ),
                        Text(DateFormat.jm()
                            .format(DateTime.parse(meg.createdAt))),
                      ],
                    ),
                  ),
                ),
              );
            });
      }
      if (state is MessagesError) {
        return Center(
          child: Text(state.error),
        );
      }
      return Center(
        child: Text("get start"),
      );
    }));
  }
}

class ChatMassageTest extends StatelessWidget {
  final Message messageItem;
  // final bool isMeChatting;
  // final String massageBody;
  const ChatMassageTest({
    super.key,
    required this.messageItem,
  });

  @override
  Widget build(BuildContext context) {
    bool isMeChatting = messageItem.fromId == FireBaseDataAll().myUid;
    return Align(
      alignment: isMeChatting ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.65,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            borderRadius: isMeChatting
                ? const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    bottomLeft: Radius.circular(12),
                    bottomRight: Radius.circular(12),
                  )
                : const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    bottomLeft: Radius.circular(12),
                    bottomRight: Radius.circular(12),
                  ),
            color: isMeChatting ? Colors.blue.shade200 : Colors.blue.shade700),
        margin: const EdgeInsets.all(8),
        child: Column(
          children: [
            if (messageItem.type == 'text') ...[
              Text(
                messageItem.msg,
                style: TextStyle(
                    fontSize: 15,
                    color: isMeChatting ? Colors.black : Colors.white),
                textAlign: TextAlign.start,
              ),
            ] else if (messageItem.type == 'image') ...[
              Image.network(
                messageItem.msg,
                width: 200,
                height: 200,
                fit: BoxFit.cover,
              ),
            ],
            const SizedBox(height: 5),
            Text(
              DateFormat.jm().format(
                DateTime.parse(messageItem.createdAt),
              ),
              style: Theme.of(context).textTheme.labelSmall,
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:chat_sdk/consts.dart';
import 'package:chat_sdk/custom_ui/chat_home_card.dart';
import 'package:chat_sdk/pages/contacts_page.dart';
import 'package:chat_sdk/pages/login_page.dart';
import 'package:chat_sdk/pages/search_page.dart';
import 'package:chat_sdk/shardP/shard_p_model.dart';
import 'package:chat_sdk/ui/add_chat.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: baseGroundColor,
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ContactsPage(),
                ));
          },
          shape: const CircleBorder(),
          backgroundColor: baseColor1,
          child: const Icon(
            Icons.chat,
            color: Colors.white,
          ),
        ),
        appBar: AppBar(
          automaticallyImplyLeading: false,
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginPage(),
                    ));
              },
              icon: const Icon(Icons.arrow_back)),
          iconTheme: const IconThemeData(color: Colors.white),
          toolbarHeight: 65,
          backgroundColor: baseAppBarColor,
          actions: [
            IconButton(
              icon: const Icon(Icons.person_add),
              onPressed: () {
                addChat(context);
              },
              color: Colors.white,
            ),
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                showSearch(context: context, delegate: SearchPage());
              },
              color: Colors.white,
            ),
            IconButton(
              icon: const Icon(Icons.more_vert),
              onPressed: () {},
              color: Colors.white,
            ),
          ],
          title: FutureBuilder(
            future: ShardpModel().getUserName(),
            builder: (context, snapshot) {
              return Text(snapshot.data ?? 'No Data',
                  style: const TextStyle(color: Colors.white, fontSize: 25));
            },
          ),
        ),
        body: ListView(
          padding: const EdgeInsets.only(top: 20, bottom: 5, left: 8, right: 8),
          children: const [
            ChatHomeCard(),
            ChatHomeCard(),
            ChatHomeCard(),
            ChatHomeCard(),
            ChatHomeCard(),
            ChatHomeCard(),
          ],
        ));
  }
}

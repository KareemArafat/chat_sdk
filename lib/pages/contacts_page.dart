import 'package:chat_sdk/consts.dart';
import 'package:chat_sdk/custom_ui/contact_card.dart';
import 'package:chat_sdk/pages/search_page.dart';
import 'package:flutter/material.dart';

class ContactsPage extends StatelessWidget {
  const ContactsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: baseGroundColor,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        toolbarHeight: 65,
        backgroundColor: baseAppBarColor,
        title: const Text(
          'Contacts',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: IconButton(
              onPressed: () {
                showSearch(context: context, delegate: SearchPage());
              },
              icon: const Icon(Icons.search),
            ),
          )
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.only(top: 8,bottom: 5 ,left: 8 ,right: 8),
        children: const [
          ContactCard(),
          ContactCard(),
          ContactCard(),
          ContactCard(),
          ContactCard(),
          ContactCard(),
        ],
      ),
    );
  }
}

import 'package:chat_sdk/core/consts.dart';
import 'package:chat_sdk/cubits/chat_cubit/chat_cubit.dart';
import 'package:chat_sdk/cubits/rooms_cubit/rooms_cubit.dart';
import 'package:chat_sdk/cubits/rooms_cubit/room_state.dart';
import 'package:chat_sdk/SDK/models/room_model.dart';
import 'package:chat_sdk/ui/custom_ui/add_group_chat.dart';
import 'package:chat_sdk/ui/custom_ui/ai_card.dart';
import 'package:chat_sdk/ui/custom_ui/chat_home_card.dart';
import 'package:chat_sdk/pages/contacts_page.dart';
import 'package:chat_sdk/pages/sign_page.dart';
import 'package:chat_sdk/pages/search_page.dart';
import 'package:chat_sdk/core/shardP/shard_p_model.dart';
import 'package:chat_sdk/ui/custom_ui/add_chat.dart';
import 'package:chat_sdk/ui/custom_ui/menu_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.token, required this.apiKey});
  final String token;
  final String apiKey;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<RoomModel> rooms = [];
  final GlobalKey menuKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    server.connectToServer(widget.token, widget.apiKey);
    BlocProvider.of<ChatCubit>(context).receiveMess();
    BlocProvider.of<ChatCubit>(context).receiveReact();
    getRoomsCards();
  }

  void getRoomsCards() async {
    BlocProvider.of<RoomsCubit>(context).getRoomsList();
  }

  @override
  void dispose() {
    super.dispose();
    server.closeServerConnection();
  }

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
        leadingWidth: MediaQuery.of(context).size.width * 0.1,
        automaticallyImplyLeading: false,
        leading: IconButton(
            onPressed: () async {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SignPage(),
                  ));
              final prefs = await SharedPreferences.getInstance();
              await prefs.clear();
              await ShardpModel().setLoginValue(flag: false);
            },
            icon: const Icon(Icons.arrow_back)),
        iconTheme: const IconThemeData(color: Colors.white),
        toolbarHeight: MediaQuery.of(context).size.height / 13,
        backgroundColor: baseAppBarColor,
        actions: [
          IconButton(
              onPressed: () {
                addGroupChat(context);
              },
              icon: const Icon(Icons.group_add)),
          IconButton(
            icon: const Icon(Icons.person_add_alt_1),
            onPressed: () {
              addChat(context);
            },
          ),
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearch(context: context, delegate: SearchPage());
            },
          ),
          IconButton(
            key: menuKey,
            icon: const Icon(Icons.more_vert),
            onPressed: () {
              menuSheet(context, menuKey);
            },
          ),
        ],
        title: FutureBuilder(
          future: ShardpModel().getUserName(),
          builder: (context, snapshot) {
            return Text(snapshot.data ?? '',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: MediaQuery.of(context).size.width * 0.055));
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 10, bottom: 5, left: 8, right: 8),
        child: BlocConsumer<RoomsCubit, RoomsState>(
          listener: (context, state) {
            if (state is ListsSuccess) {
              rooms = state.rooms!;
            }
            if (state is CreateFailure) {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text('Failed .. Room not created',
                    style:
                        TextStyle(fontWeight: FontWeight.w500, fontSize: 17)),
                backgroundColor: Color.fromARGB(255, 176, 12, 0),
                duration: Duration(seconds: 1),
              ));
            }
            if (state is CreateSuccess) {
              rooms = state.rooms!;
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text('Room created Success',
                    style:
                        TextStyle(fontWeight: FontWeight.w500, fontSize: 17)),
                backgroundColor: Color.fromARGB(255, 0, 144, 5),
                duration: Duration(seconds: 1),
              ));
            }
          },
          builder: (context, state) {
            if (state is ListsFailure) {
              return const Center(
                child: Text(
                  'Connection Error ..',
                  style: TextStyle(
                      color: Color.fromARGB(107, 255, 255, 255), fontSize: 18),
                ),
              );
            }
            if (state is ListsLoading) {
              return const Align(
                alignment: Alignment.topCenter,
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  color: baseColor1,
                  backgroundColor: Colors.white,
                  strokeAlign: -5,
                ),
              );
            }
            return SingleChildScrollView(
              child: Column(
                children: [
                  const AiCard(),
                  ListView.builder(
                    reverse: true,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: rooms.length,
                    itemBuilder: (context, index) {
                      return ChatHomeCard(
                        room: rooms[index],
                      );
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

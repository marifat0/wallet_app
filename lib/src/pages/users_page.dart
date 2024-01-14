import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../model/user.dart';

class UsersPage extends StatefulWidget {
  const UsersPage({super.key});

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  late Future<List<User>> futureUser;
  @override
  void initState() {
    super.initState();
    futureUser = fetchUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Users Page'),
        actions: [
          IconButton(onPressed: () => fetchUsers(), icon: Icon(Icons.adb))
        ],
      ),
      body: FutureBuilder<List<User>>(
        future: futureUser,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.separated(
                itemBuilder: (context, index) => ListTile(
                      leading: CircleAvatar(
                        backgroundImage:
                            NetworkImage(snapshot.data![index].avatar!),
                      ),
                      title: Text(snapshot.data![index].firstName!),
                      subtitle: Text(snapshot.data![index].email!),
                    ),
                separatorBuilder: (context, index) => Divider(height: 0),
                itemCount: snapshot.data!.length);
          } else {
            return Center(child: const CircularProgressIndicator());
          }
        },
      ),
    );
  }
}

Future<List<User>> fetchUsers() async {
  await Future.delayed(Duration(seconds: 2));
  final response =
      await http.get(Uri.parse('https://reqres.in/api/users?page=2'));

  if (response.statusCode != 200) {
    throw Exception('Failed to load Users');
  } else {
    final data = json.decode(response.body);
    return (data['data'] as List).map((e) => User.fromJson(e)).toList();
  }
}

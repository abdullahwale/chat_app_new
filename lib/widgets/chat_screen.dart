import 'package:chat_app_new/widgets/chat_list.dart';
import 'package:chat_app_new/widgets/text_composer.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';

enum MenuItem { signout }

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final List<Map<String, dynamic>> _dummySnapshot = [];
  final _googleSignIn = GoogleSignIn();
  GoogleSignInAccount _currentUser;
  @override
  void inState() {
    super.initState();
    _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount account) {
      setState(() {
        _currentUser = account;
      });
      _googleSignIn.signInSilently();
    });
  }

  Future<Null> _handleSignin() async {
    var user = _googleSignIn.currentUser;
    if (user == null) user = await _googleSignIn.signInSilently();
    if (user == null) user = await _googleSignIn.signIn();
  }

  Future<void> _handleSignOut() async {
    _googleSignIn.disconnect();
  }

  void _sendMessageCallback(String text) {
    setState(() {
      _dummySnapshot.insert(0, {
        'name': '_googleSignIn.currentUser.displayName',
        ' avatarUrl': '_googleSignIn.currentUser.photoUrl',
        'photoUrl': '',
        'text': text,
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_currentUser == null)
      return Scaffold(
        backgroundColor: Colors.purple.shade400,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SignInButton(Buttons.Google, onPressed: () {
              _handleSignin();
            })
          ],
        ),
      );
    else
      return Scaffold(
        backgroundColor: Colors.purple.shade400,
        appBar: AppBar(
          title: Text('Coffee Chat'),
          actions: <Widget>[
            PopupMenuButton<MenuItem>(
              onSelected: (MenuItem menuItem) {
                setState(() {
                  _handleSignOut();
                });
              },
              itemBuilder: (BuildContext context) => <PopupMenuEntry<MenuItem>>[
                PopupMenuItem<MenuItem>(
                  value: MenuItem.signout,
                  child: Text('Google Signout'),
                )
              ],
            ),
          ],
        ),
        body: Column(
          children: <Widget>[
            ChatList(
              snapshot: _dummySnapshot,
            ),
            Divider(
              height: 1.0,
            ),
            TextComposer(
              sendCallback: _sendMessageCallback,
            ),
          ],
        ),
      );
  }
}

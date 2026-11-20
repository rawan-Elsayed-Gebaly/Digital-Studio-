import 'dart:async';

import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final cloud = Supabase.instance.client;

  Future<bool> register(String email, String password) async {
    try {
      await cloud.auth.signUp(password: password, email: email);
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> login(String email, String password) async {
    try {
      await cloud.auth.signInWithPassword(password: password, email: email);
      return true ;
    } catch (e) {
      print(e);
      return false ;
    }
  }

  Future<bool> logout() async {
    // invalid Session with logout
    try {
      await cloud.auth.signOut();
      return true ;
    } catch (e) {
      print(e);
      return false  ;
    }
  }


  bool logOut ()=> cloud.auth.currentSession!=null ;
}

import 'dart:convert';
import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:home_market/models/facilities_model.dart';
import 'package:home_market/models/message_model.dart';
import 'package:home_market/models/post_model.dart';
import 'package:home_market/models/user_model.dart';
import 'package:home_market/services/firebase/auth_service.dart';
import 'package:home_market/services/firebase/store_service.dart';

sealed class DBService {
  static final db = FirebaseDatabase.instance;

  /// post
  static Future<bool> storePost({
    required String title,
    required String content,
    required List<Facilities> facilities,
    required String area,
    required String bathrooms,
    required bool isApartment,
    required String phone,
    required String price,
    required String rooms,
    required List<File?> gridImages,
    required String lat,
    required String long,
  }) async {
    try {
      final folder = db.ref(Folder.post);
      final child = folder.push();
      final id = child.key!;
      final userId = AuthService.user.uid;
      final userName = AuthService.user.displayName;

      List<String> images = [];

      for (var i = 0; i < gridImages.length; i++) {
        final image = await StoreService.uploadFile(gridImages[i]!);
        images.add(image);
      }
      final post = Post(
          isLiked: ['isLiked'],
          userName: userName!,
          gridImages: images,
          facilities: facilities,
          id: id,
          title: title,
          content: content,
          userId: userId,
          createdAt: DateTime.now(),
          comments: [],
          area: area,
          bathrooms: bathrooms,
          email: AuthService.user.email!,
          isApartment: isApartment,
          phone: phone,
          price: price,
          rooms: rooms,
          lat: lat,
          long: long);
      await child.set(post.toJson());
      print("created");
      return true;
    } catch (e, s) {
      debugPrint("DB ERROR: $e $s");
      return false;
    }
  }

  static Future<List<Post>> readAllPost() async {
    final folder = db.ref(Folder.post);
    final data = await folder.get();
    final json = jsonDecode(jsonEncode(data.value)) as Map;
    return json.values
        .map((e) => Post.fromJson(e as Map<String, Object?>))
        .toList();
  }

  static Future<bool> deletePost(String postId, List<String> imagePath) async {
    try {
      final fbPost = db.ref(Folder.post).child(postId);
      await fbPost.remove();
      await StoreService.removeFiles(imagePath);
      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> updatePost({
    required String postId,
    required String title,
    required String content,
    required String area,
    required String bathrooms,
    required bool isApartment,
    required String phone,
    required String price,
    required String rooms,
    required List<Facilities> facilities,
    required List<String> isLiked,
    required List<File?> gridImages,
    List<String>? imagesUri,
    required String lat,
    required String long,
  }) async {
    try {
      final fbPost = db.ref(Folder.post).child(postId);
      final userId = AuthService.user.uid;
      final userName = AuthService.user.displayName;
      List<String> images = [];
      print(imagesUri);
      for (var i = 0; i < gridImages.length; i++) {
        final image = await StoreService.uploadFile(gridImages[i]!);
        images.add(image);
      }
      // final lat = LatLong.lat;
      // final long = LatLong.long;
      final post = Post(
          lat: lat,
          long: long,
          userName: userName!,
          isLiked: isLiked,
          gridImages: imagesUri ?? images,
          facilities: facilities,
          id: postId,
          title: title,
          content: content,
          userId: userId,
          createdAt: DateTime.now(),
          comments: [],
          area: area,
          bathrooms: bathrooms,
          email: AuthService.user.email!,
          isApartment: isApartment,
          phone: phone,
          price: price,
          rooms: rooms);
      await fbPost.update(post.toJson());

      return true;
    } catch (e) {
      debugPrint("DB ERROR: $e ");
      return false;
    }
  }

  static Future<bool> updateLikePost(
      {required String postId,
      required String title,
      required String content,
      required String area,
      required String bathrooms,
      required bool isApartment,
      required List<String> isLiked,
      required String phone,
      required String price,
      required String rooms,
      required List<Facilities> facilities,
      required List<String> gridImages,
      List<String>? imagesUri,
      required String lat,
      required String long,
      required String userName,
      required String email,
      required String userId}) async {
    try {
      final fbPost = db.ref(Folder.post).child(postId);

      final post = Post(
        userName: userName,
        gridImages: gridImages,
        facilities: facilities,
        id: postId,
        title: title,
        content: content,
        userId: userId,
        createdAt: DateTime.now(),
        comments: [],
        area: area,
        bathrooms: bathrooms,
        email: email,
        isApartment: isApartment,
        isLiked: isLiked,
        phone: phone,
        price: price,
        rooms: rooms,
        lat: lat,
        long: long,
      );
      await fbPost.update(post.toJson());

      return true;
    } catch (e) {
      debugPrint("DB ERROR: $e ");
      return false;
    }
  }

  static Future<List<Post>> searchPost(String text,
      [SearchType type = SearchType.all]) async {
    try {
      final folder = db.ref(Folder.post);
      final event = await folder
          .orderByChild("title")
          .startAt(text)
          .endAt("$text\uf8ff")
          .once();
      final json = jsonDecode(jsonEncode(event.snapshot.value)) as Map;
      debugPrint("JSON: $json");
      final data = json.values
          .map((e) => Post.fromJson(e as Map<String, Object?>))
          .toList();

      switch (type) {
        case SearchType.all:
          return data;
        case SearchType.me:
          return data
              .where((element) => element.userId == AuthService.user.uid)
              .toList();
      }
    } catch (e) {
      debugPrint("ERROR: $e");
      return [];
    }
  }

  static Future<List<Post>> myPost() async {
    try {
      final folder = db.ref(Folder.post);
      final event = await folder
          .orderByChild("userId")
          .equalTo(AuthService.user.uid)
          .once();
      final json = jsonDecode(jsonEncode(event.snapshot.value)) as Map;
      debugPrint("JSON: $json");
      return json.values
          .map((e) => Post.fromJson(e as Map<String, Object?>, isMe: true))
          .toList();
    } catch (e) {
      debugPrint("ERROR: $e");
      return [];
    }
  }

  static Future<List<Post>> likedPost() async {
    try {
      //.child(post.id).child("isLiked")
      final folder = db.ref(Folder.post);
      final event = await folder.get();
      final json = jsonDecode(jsonEncode(event.value)) as Map;
      final data = json.values
          .map((e) => Post.fromJson(e as Map<String, Object?>))
          .toList();

      return data
          .where((element) => element.isLiked.contains(AuthService.user.uid))
          .toList();
    } catch (e) {
      debugPrint("ERROR: $e");
      return [];
    }
  }

  /// user
  static Future<bool> storeUser(
      String email, String password, String username, String uid) async {
    try {
      final folder = db.ref(Folder.user).child(uid);

      final member = Member(
          uid: uid, username: username, email: email, password: password);
      await folder.set(member.toJson());

      return true;
    } catch (e) {
      debugPrint("DB ERROR: $e");
      return false;
    }
  }

  static Future<Member?> readUser(String uid) async {
    try {
      final data = db.ref(Folder.user).child(uid).get();
      final member =
          Member.fromJson(jsonDecode(jsonEncode(data)) as Map<String, Object>);
      return member;
    } catch (e) {
      debugPrint("DB ERROR: $e");
      return null;
    }
  }

  /// Message
  static Future<bool> writeMessage(
      String postId, String message, List<Message> old) async {
    try {
      final post = db.ref(Folder.post).child(postId);

      final msg = Message(
          id: "${old.length + 1}",
          message: message,
          writtenAt: DateTime.now(),
          userId: AuthService.user.uid,
          userImage: AuthService.user.photoURL,
          username: AuthService.user.displayName!);
      old.add(msg);

      post.update({
        "comments": old.map((e) => e.toJson()).toList(),
      });
      return true;
    } catch (e) {
      debugPrint("DB ERROR: $e");
      return false;
    }
  }
}

sealed class Folder {
  static const post = "Houses";
  static const user = "User";
  static const postImages = "HouseImage";
}

enum SearchType {
  all,
  me,
}

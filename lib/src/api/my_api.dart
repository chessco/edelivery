import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:edelivery/src/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:edelivery/src/models/user.dart';
import 'package:edelivery/src/utils/auth.dart';
import 'package:edelivery/src/utils/dialogs.dart';
import 'package:edelivery/src/utils/extras.dart';

const baseUrl = 'https://delivery.cdobregon.net';

class MyAPI {
  MyAPI._internal();
  static MyAPI _instance = MyAPI._internal();
  static MyAPI get instance => _instance;

  final Dio _dio = Dio(
    BaseOptions(baseUrl: baseUrl),
  );

  Future<void> register(
    BuildContext context, {
    @required String username,
    @required String email,
    @required String password,
  }) async {
    final ProgressDialog progressDialog = ProgressDialog(context);
    try {
      progressDialog.show();
      final Response response = await this._dio.post(
        '/api/Account/register',
        data: {
          "displayName": username,
          "email": email,
          "password": password,
        },
      );
      await Auth.instance.setSession(response.data);
      progressDialog.dismiss();

      Navigator.pushNamedAndRemoveUntil(
        context,
        HomePage.routeName,
        (_) => false,
      );
    } catch (e) {
      progressDialog.dismiss();
      if (e is DioError) {
        print(e.response.statusCode);
        print(e.response.data);
        Dialogs.info(
          context,
          title: "ERROR",
          content: e.response.statusCode == 409
              ? 'Duplicated email or username'
              : e.message,
        );
      } else {
        print(e);
      }
    }
  }

  Future<void> login(
    BuildContext context, {
    @required String email,
    @required String password,
  }) async {
    final ProgressDialog progressDialog = ProgressDialog(context);
    try {
      progressDialog.show();
      final Response response = await this._dio.post(
        '/api/Account/login',
        data: {
          "email": email,
          "password": password,
        },
      );

      await Auth.instance.setSession(response.data);
      progressDialog.dismiss();

      Navigator.pushNamedAndRemoveUntil(
        context,
        HomePage.routeName,
        (_) => false,
      );
    } catch (e) {
      progressDialog.dismiss();
      if (e is DioError) {
        print(e.response.statusCode);
        print(e.response.data);
        String message = e.message;
        if (e.response.statusCode == 404) {
          message = "User not found";
        } else if (e.response.statusCode == 403) {
          message = "Invalid password";
        }

        Dialogs.info(
          context,
          title: "ERROR",
          content: message,
        );
      } else {
        print(e);
      }
    }
  }

  Future<dynamic> refresh(String expiredToken) async {
    try {
      final Response response = await this._dio.post(
            '/api/v1/refresh-token',
            options: Options(headers: {
              'token': expiredToken,
            }),
          );
      return response.data;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<User> getUserInfo() async {
    try {
      final String token = await Auth.instance.accessToken;
      print(token);
      final String email = "chesssco@gmail.com";
      final String displayName = "Chessco";
      final Response response = await this._dio.get(
            '/api/Account',
            options: Options(headers: {
             'Authorization': 'Bearer '+token,
            }),
          );
          // headers = headers.set('Authorization', `Bearer ${token}`);

      print(response.data);
      return User.fromJson(response.data);
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<String> updateAvatar(Uint8List bytes, String filePath) async {
    try {
      final String token = await Auth.instance.accessToken;

      FormData formData = FormData.fromMap({
        'attachment': MultipartFile.fromBytes(
          bytes,
          filename: Extras.getFilename(filePath),
        ),
      });

      final Response response = await this._dio.post(
            '/api/v1/update-avatar',
            options: Options(headers: {
              'token': token,
            }),
            data: formData,
          );
      return baseUrl + response.data;
    } catch (e) {
      print(e);
      if (e is DioError) {
        print(e.response.data);
      }
      return null;
    }
  }
}

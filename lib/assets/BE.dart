import 'dart:convert';

import 'package:flutter/services.dart';

class AuthResult {
  final bool success;
  final String message;
  final Map<String, dynamic>? user;

  const AuthResult({required this.success, required this.message, this.user});
}

class FakeAuthApi {
  FakeAuthApi._();

  static final FakeAuthApi instance = FakeAuthApi._();

  final List<Map<String, dynamic>> _users = [];
  bool _loaded = false;

  Future<void> _loadDbIfNeeded() async {
    if (_loaded) {
      return;
    }

    final rawJson = await rootBundle.loadString('lib/assets/db.json');
    final decoded = jsonDecode(rawJson) as Map<String, dynamic>;
    final rawUsers = (decoded['users'] as List<dynamic>? ?? <dynamic>[])
        .cast<Map<String, dynamic>>();

    _users
      ..clear()
      ..addAll(rawUsers.map((user) => Map<String, dynamic>.from(user)));

    _loaded = true;
  }

  Future<void> _simulateNetworkDelay() async {
    await Future<void>.delayed(const Duration(seconds: 1));
  }

  Future<AuthResult> register({
    required String fullName,
    required String email,
    required String password,
    required String confirmPassword,
    required bool acceptedTerms,
  }) async {
    await _simulateNetworkDelay();
    await _loadDbIfNeeded();

    final normalizedEmail = email.trim().toLowerCase();

    if (fullName.trim().isEmpty) {
      return const AuthResult(
        success: false,
        message: 'Họ và tên không được để trống.',
      );
    }

    if (normalizedEmail.isEmpty) {
      return const AuthResult(
        success: false,
        message: 'Email không được để trống.',
      );
    }

    if (password.isEmpty || confirmPassword.isEmpty) {
      return const AuthResult(
        success: false,
        message: 'Mật khẩu không được để trống.',
      );
    }

    if (password != confirmPassword) {
      return const AuthResult(
        success: false,
        message: 'Mật khẩu xác nhận không khớp.',
      );
    }

    if (!acceptedTerms) {
      return const AuthResult(
        success: false,
        message: 'Bạn cần đồng ý điều khoản để đăng ký.',
      );
    }

    final emailExists = _users.any(
      (user) => (user['email'] as String).toLowerCase() == normalizedEmail,
    );

    if (emailExists) {
      return const AuthResult(success: false, message: 'Email đã tồn tại.');
    }

    final nextId = _users.isEmpty
        ? 1
        : _users
                  .map((user) => (user['id'] as num).toInt())
                  .reduce((max, id) => id > max ? id : max) +
              1;

    final newUser = <String, dynamic>{
      'id': nextId,
      'fullName': fullName.trim(),
      'email': normalizedEmail,
      'password': password,
      'confirmPassword': confirmPassword,
      'acceptedTerms': acceptedTerms,
    };

    _users.add(newUser);

    return AuthResult(
      success: true,
      message: 'Đăng ký thành công.',
      user: Map<String, dynamic>.from(newUser),
    );
  }

  Future<AuthResult> login({
    required String email,
    required String password,
  }) async {
    await _simulateNetworkDelay();
    await _loadDbIfNeeded();

    final normalizedEmail = email.trim().toLowerCase();

    final matchedUser = _users.where(
      (user) => (user['email'] as String).toLowerCase() == normalizedEmail,
    );

    if (matchedUser.isEmpty) {
      return const AuthResult(success: false, message: 'Email không tồn tại.');
    }

    final user = matchedUser.first;

    if (user['password'] != password) {
      return const AuthResult(success: false, message: 'Sai mật khẩu.');
    }

    return AuthResult(
      success: true,
      message: 'Đăng nhập thành công.',
      user: Map<String, dynamic>.from(user),
    );
  }
}

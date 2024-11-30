import 'package:flutter_riverpod/flutter_riverpod.dart';

enum AuthForm { login, signUp }

final authFormProvider = StateProvider<AuthForm>((ref) => AuthForm.login);

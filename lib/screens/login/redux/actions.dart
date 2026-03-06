class LoginEmailChangedAction {
  final String email;

  const LoginEmailChangedAction(this.email);
}

class LoginPasswordChangedAction {
  final String password;

  const LoginPasswordChangedAction(this.password);
}

class LoginToggleShowPasswordAction {
  const LoginToggleShowPasswordAction();
}

class LoginSubmitRequestedAction {
  const LoginSubmitRequestedAction();
}

class LoginSubmitStartedAction {
  const LoginSubmitStartedAction();
}

class LoginSubmitSucceededAction {
  final String fullName;
  final String email;

  const LoginSubmitSucceededAction({
    required this.fullName,
    required this.email,
  });
}

class LoginSubmitFailedAction {
  final String message;

  const LoginSubmitFailedAction(this.message);
}

class LoginClearStatusAction {
  const LoginClearStatusAction();
}

abstract class SignInEvent{
}

class SignInTextChangedEvent extends SignInEvent{
final String emailValue;
final String passwordValue;
SignInTextChangedEvent(this.emailValue,this.passwordValue);
}

class SignInSubmittedBtn extends SignInEvent{
  final String email;
  final String password;
  SignInSubmittedBtn(this.email,this.password);
}
import 'package:blocprovider/bloc/validationBloc/signin/bloc/sign_event.dart';
import 'package:blocprovider/bloc/validationBloc/signin/bloc/signin_state.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignIn extends Bloc<SignInEvent,SignInState>{
      SignIn() : super(SignInInitialState()){
        on<SignInTextChangedEvent>((event,emit) {
         if(EmailValidator.validate(event.emailValue) == false){
           emit(SignInErrorState("Please Enter Valid Email Address"));
         }
         else if(event.passwordValue.length <= 7){
           emit(SignInErrorState("Please Enter password"));

         }
         else{
           emit(SignInValidState());
         }
        });
        on<SignInSubmittedBtn>((event,emit) {

          emit(SignInLoading());
        } );
      }


}
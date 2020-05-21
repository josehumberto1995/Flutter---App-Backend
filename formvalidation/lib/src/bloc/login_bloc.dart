import 'dart:async';

import 'package:formvalidation/src/bloc/validators.dart';
import 'package:rxdart/rxdart.dart';

class LoginBloc with Validators{

//final _emailController    = StreamController<String>.broadcast(); para utilizar el RXdart modificamos el StreamController con el BehaviorSubject
//final _passwordController = StreamController<String>.broadcast();

final _emailController    = BehaviorSubject<String>();
final _passwordController = BehaviorSubject<String>();

// Recuperar los datos del Stream

Stream<String> get emailStream     => _emailController.stream.transform(validarEmail);
Stream<String> get passwordStream  => _passwordController.stream.transform( validarPassword );

Stream<bool> get formValidStream => 
    CombineLatestStream.combine2(emailStream, passwordStream, (e, p) => true);


// Insertar valores al STREAM

Function(String) get changeEmail     => _emailController.sink.add;
Function(String) get changePassword  => _passwordController.sink.add;

//OBTENER EL ULTIMO VALOR INGRESADO

String get email    => _emailController.value;
String get password => _passwordController.value;


dispose(){
  _emailController?.close();
  _passwordController?.close();
}



}
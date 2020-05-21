import 'dart:io';

import 'package:flutter/material.dart';
import 'package:formvalidation/src/bloc/providers.dart';
import 'package:image_picker/image_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:formvalidation/src/models/producto_model.dart';
import 'package:formvalidation/src/utils/utils.dart' as utils;

//import 'package:formvalidation/src/providers/productos_provider.dart';
//import 'package:formvalidation/src/bloc/productos_bloc.dart';


class ProductoPage extends StatefulWidget {

  @override
  _ProductoPageState createState() => _ProductoPageState();
}

class _ProductoPageState extends State<ProductoPage> {

  final formKey           = GlobalKey<FormState>();
  final scaffoldKey       = GlobalKey<ScaffoldState>();

  ProductosBloc productosBloc;
  ProductoModel producto  = new ProductoModel();

  bool _guardando = false;

  File foto;

  @override
  Widget build(BuildContext context) {

    productosBloc = Provider.productosBloc(context);

    final ProductoModel prodData = ModalRoute.of(context).settings.arguments;
    if( prodData != null) {
      producto = prodData;
    }

    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text('PRODUCTO'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.photo_size_select_actual), 
            onPressed: _seleccionarFoto,
          ),
           IconButton(
            icon: Icon(Icons.camera_alt), 
            onPressed: _tomarFoto,
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(15.0),
          child: Form(
            key: formKey,
            child: Column(
              children: <Widget>[
                _mostrarFoto(),
                _crearNombreP(),
                _crearPrecio(),
                _crearDisponible(),
                _crearBoton()
              ],
            )
         ),
        ),
      ),
      
    );
  }

 Widget _crearNombreP() {
   
   return TextFormField(
     initialValue: producto.titulo,
     textCapitalization: TextCapitalization.sentences,
     decoration: InputDecoration(
       labelText: 'Nombre del producto'
     ),
     onSaved: (value) => producto.titulo = value,
     validator: (value){
       if ( value.length < 3){
         return 'Ingrese el nombre del producto';
       } else {
         return null;
       }
     },
   );

 }

Widget _crearPrecio() {
   
   return TextFormField(
     initialValue: producto.valor.toString(),
     keyboardType: TextInputType.numberWithOptions(decimal: true),
     decoration: InputDecoration(
       labelText: 'Precio del producto'
     ),
     onSaved: (value) => producto.valor = double.parse(value),
     validator: (value){
       if(utils.isNumeric(value)) {
         return null;
       } else {
         return 'Solo números';
       }
     },
   );

 }

Widget _crearDisponible() {

  return SwitchListTile(
    value: producto.disponible, 
    title: Text('Disponible'),
    activeColor: Colors.deepPurple,
    onChanged: (value) => setState((){
      producto.disponible = value;
    }),
  );

}

Widget _crearBoton() {

  return RaisedButton.icon(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20.0),      
    ),
    color: Colors.deepPurple,
    textColor: Colors.white,
    icon: Icon (Icons.save),
    label: Text('GUARDAR'),
    onPressed: ( _guardando ) ? null: _submit,
  );
}

void _submit() async {

  if (!formKey.currentState.validate() ) return;

  formKey.currentState.save();
  setState(() {_guardando = true; });

  if ( foto !=  null)  {
    producto.fotoUrl = await productosBloc.subirFoto(foto);

  }

  if (producto.id == null){
     productosBloc.agregarProductos(producto);
  }else{
     productosBloc.editarProductos(producto);
  }

 //mostrarSnackbar('Regsitro Esxitoso'); 

 Fluttertoast.showToast(
        msg: "Producto Registrado",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 2,
        backgroundColor: Colors.deepPurple,
        textColor: Colors.white,
        fontSize: 16.0
    );

 Navigator.pop(context);
 setState(() {});

 
}

/*void mostrarSnackbar(String mensaje){

  final snackbar = SnackBar (
    content: Text(mensaje),
    duration: Duration(milliseconds: 2500),

  );

  scaffoldKey.currentState.showSnackBar(snackbar);

}*/

Widget _mostrarFoto() {

   if ( producto.fotoUrl != null ) {
      
      return FadeInImage(
        image: NetworkImage( producto.fotoUrl ),
        placeholder: AssetImage('assets/original.gif'),
        height: 300.0,
        fit: BoxFit.contain,
      );
 
    } else {
 
      if( foto != null ){
        return Image.file(
          foto,
          fit: BoxFit.cover,
          height: 300.0,
        );
      }
      return Image.asset('assets/original.png');
    }
  }
_seleccionarFoto() async {

    _procesarImage( ImageSource.gallery );
  }

_tomarFoto() async {

     _procesarImage( ImageSource.camera );
  }

  _procesarImage( ImageSource origen ) async {

    foto = await ImagePicker.pickImage(
      source: origen,
    );
    if ( foto != null){
      producto.fotoUrl = null;
    }
    setState(() {});
  }


  
}
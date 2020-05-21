import 'package:flutter/material.dart';
import 'package:formvalidation/src/bloc/providers.dart';
import 'package:formvalidation/src/models/producto_model.dart';
//import 'package:formvalidation/src/providers/productos_provider.dart';


class HomePage extends StatefulWidget {

  //final productosProrvider = new ProductosProvider();

  
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {

    final productosBloc = Provider.productosBloc(context);
    productosBloc.cargarProductos();

      
    return Scaffold(
      appBar: AppBar(
        title: Text('Listado De Productos')
      ),
      body: _crearListado(productosBloc),
      floatingActionButton:  _crearBotonFlotante(context),
    );
    
  }

 Widget _crearBotonFlotante(BuildContext context) {

   return FloatingActionButton(
     child: Icon(Icons.add),
     backgroundColor: Colors.deepPurple,
     onPressed: () => Navigator.pushNamed(context, 'producto').then((value) {
      setState(() {
    
       });
    }),
     
    );
 }

Widget _crearListado(ProductosBloc productosBloc) {

  return StreamBuilder(
    stream: productosBloc.productosStream,
    builder: (BuildContext context, AsyncSnapshot<List<ProductoModel>> snapshot){
      if ( snapshot.hasData){

        final productos = snapshot.data;

        return ListView.builder(
          itemCount: productos.length,
          itemBuilder: (context, i) => _crearItem(context, productosBloc, productos[i]),
          
        );

      }else {
        return Center(child: CircularProgressIndicator() );
      }
    },
  );

}

  Widget _crearItem(BuildContext context, ProductosBloc productosBloc, ProductoModel producto) {

    return Dismissible(
      key: UniqueKey(),
      background: Container(
        padding: EdgeInsets.only(right: 20),
        color: Colors.blueAccent,
        child: Align(
          alignment: Alignment.center,
          child: Text('Eliminando ${producto.titulo}',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
      onDismissed: ( direccion )=> productosBloc.borrarProductos(producto.id),
        //productosProrvider.borrarProducto(producto.id);
      child: Card(
        child: Column(
          children: <Widget>[

            (producto.fotoUrl == null)
             ? Image(image: AssetImage('assets/original.png'))
             : FadeInImage(
               placeholder: AssetImage('assets/original.gif'), 
               image: NetworkImage(producto.fotoUrl), 
               height: 300.0,
               width: double.infinity,
               fit: BoxFit.cover,
             ),
              ListTile(
               title: Text('Producto: ${producto.titulo} - Precio: ${producto.valor}'),
              subtitle: Text(producto.id),
              onTap: () => Navigator.pushNamed(context, 'producto', 
                arguments: producto
                ).then((value) {
                setState(() {});
              })
            ),
          ],
        ),
      )
    );

   }
}
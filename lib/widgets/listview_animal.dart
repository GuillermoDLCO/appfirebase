import 'dart:async';

import 'package:appfirebase/classes/animal.dart';
import 'package:appfirebase/widgets/cardview_animal.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ListViewAnimal extends StatefulWidget {
  BuildContext context;
  ListViewAnimal(this.context);

  @override
  _ListViewAnimalState createState() => _ListViewAnimalState();
}

class _ListViewAnimalState extends State<ListViewAnimal> {
  List<Animal> animals = new List();
  DatabaseReference reference=FirebaseDatabase.instance.reference().child("Animal");
  StreamSubscription<Event> onAddedSubs;
  StreamSubscription<Event> onChangeSubs;
  @override
  Widget build(BuildContext context) {
    

    //ListView.builder para q detecte cambios y los actualice
    return ListView.builder(
      //Este atributo es para que el list view se adapte al contenido y no se expanda por toda la ventana
      shrinkWrap: true,
      itemCount: animals.length,
      //Recorre la lista de elementos y la muestra en el listview
      itemBuilder: (BuildContext context, int index){
        return Dismissible(
          key: ObjectKey(animals[index]),
          child: CardViewAnimal(animals[index],context),
          onDismissed: (direction){
            deleteItem(index);
          },);
      },
    );
    
  }

  void deleteItem(index){
    setState(() {
     //Eliminamos el elemento de firebase
     reference.child(animals[index].key).remove(); 
     //Eliminamos el elemento de la lista
     animals.removeAt(index);
    });
  }

  void initState(){
      //Cuando se agregue un nuevo elemento vamos a recontruir nuestro widget
      onAddedSubs=reference.onChildAdded.listen(onEntryAdded);
      onChangeSubs=reference.onChildChanged.listen(onEntryChanged);
    }

    onEntryAdded(Event event){
      setState(() {
        //Con snapshot podemos obtener todos los elementos que estan dados de alta en nuestra base de datos
       animals.add(Animal.getAnimal(event.snapshot)); 
      });
    }

    onEntryChanged(Event event){
      //Vamos a recibir el elemento q se modifico y vamos a compararlo con todos los elementos de nuestr lista
      //Una vez que lo encuentre lo almacena en oldEntry
      Animal oldEntry=animals.singleWhere((entry){
       return entry.key==event.snapshot.key;
     });
      setState(() {
        //Obtenemos el index del elemento y actualizamos ese elemento
        animals[animals.indexOf(oldEntry)]=Animal.getAnimal(event.snapshot);
      });
    }
  //Se ejecuta cuando nuestro widget sea eliminado del arbol de widget
  void disponse(){
    onAddedSubs.cancel();
    onChangeSubs.cancel();
  }
}
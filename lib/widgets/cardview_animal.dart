import 'package:appfirebase/classes/animal.dart';
import 'package:appfirebase/pages/animal_form_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CardViewAnimal extends StatelessWidget {
  Animal animal;
  BuildContext context;

  CardViewAnimal(this.animal, this.context);

  @override
  Widget build(BuildContext context) {
    //Para detectar el click en el card view se coloca el widget InkWell
    return InkWell(
      onTap: (){
        Navigator.push(context,
        //De esta manera enviamos el objeto a nuestra clase form animal para editarlo
        MaterialPageRoute(builder: (context)=>FormAnimal("Editar Animal",animal)));
      },
      child: Card(
        child: Column(
          children: <Widget>[
            Container(
              height: 144.0,
              width: 500.0,
              color: Colors.green,
              child: FadeInImage.assetNetwork(
                placeholder: "img/go.png",
                image: animal.image,
                height: 144.0,
                width: 160.0,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(7.0),
              child: Row(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(7.0),
                    child: Icon(Icons.pets),
                  ),
                  Padding(
                    padding: EdgeInsets.all(7.0),
                    child: Text(animal.name, style: TextStyle(fontSize: 18.0)),
                  ),
                  Padding(
                    padding: EdgeInsets.all(7.0),
                    child: Icon(Icons.cake),
                  ),
                  Padding(
                    padding: EdgeInsets.all(7.0),
                    child: Text(animal.age, style: TextStyle(fontSize: 18.0)),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

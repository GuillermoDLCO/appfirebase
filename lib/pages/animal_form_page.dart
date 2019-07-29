import 'dart:io';

import 'package:appfirebase/classes/animal.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class FormAnimal extends StatefulWidget {
  @override
  String title;
  Animal animal;
  FormAnimal(this.title,this.animal);
  _FormAnimalState createState() => _FormAnimalState();
}

class _FormAnimalState extends State<FormAnimal> {
  var nameController=TextEditingController();
  var ageController=TextEditingController();
  File galleryFile;
  String urlImage;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: getFormAnimal(),
      ),
    );
  }

  void initState(){
    //Para rellenar con los datos ya guardados en storage
    if(widget.animal!=null){
      nameController.text = widget.animal.name;
      ageController.text = widget.animal.age;
    }
    
  }

  Widget getFormAnimal(){
    return Column(
      children: <Widget>[
        TextFormField(
          decoration: InputDecoration(icon: Icon(Icons.pets),
          hintText: "Cual es el nombre del animal?",
          labelText: "Nombre",
          ),
          controller: nameController,
        ),
        TextFormField(
          decoration: InputDecoration(icon: Icon(Icons.cake),
          hintText: "Cual es la edad?",
          labelText: "Edad",
          ),
          controller: ageController,
        ),
        RaisedButton(
          onPressed: imageSelectorGallery,
          child: Text("Selecciona una imagen"),
        ),
        SizedBox(
          child: showImage(),
        ),
        RaisedButton(
          onPressed: sendData,
          child: Text("Guardar"),
        )
      ],
    );
  }

  sendData(){
    //La imagen se guardara con el nombre del animal
    saveFirebase(nameController.text).then((_){
      DatabaseReference db=FirebaseDatabase.instance.reference().child("Animal");
      if (widget.animal!= null){
        db.child(widget.animal.key).set(getAnimal()).then((_){
          //Cerramos formulario
          Navigator.pop(context);
        });
      } else {
        //Al agregar uno nuevo aun no se tiene la llave, por lo q solo se enviaran los datos
        db.push().set(getAnimal()).then((_){
          //Cerramos formulario
          Navigator.pop(context);
        });
    }
    });
    
  }

  Map<String,dynamic> getAnimal(){
    Map<String,dynamic> data=new Map();
    data["name"]=nameController.text;
    data["age"]=ageController.text;
    if(widget.animal!=null && galleryFile==null){
      //Si no seleccionamos ningun elemento de la galeria mostramos la misma imagen del objeto
      data["image"] = widget.animal.image;
    } else {
      data["image"] = urlImage!=null ? urlImage:"";
    }
    return data;
  }

  Future<void> saveFirebase(String imageId) async {
    if(galleryFile!=null){
      StorageReference reference=FirebaseStorage.instance.ref().child("animal").child(imageId);
      //Se gyarda el archivo en storage
      StorageUploadTask uploadTask=reference.putFile(galleryFile);
      //Obtenemos la url para guardarlo en la db
      StorageTaskSnapshot downloadUrl=(await uploadTask.onComplete);
      urlImage = (await downloadUrl.ref.getDownloadURL());
    }
  }

  showImage(){
    //Mostramos la imagen si es q selecciono uno de la galeria de imagenes
    if (galleryFile!=null)
      return Image.file(galleryFile);
    else {
      if(widget.animal!=null){
        //Para cargar un imagen desde internet
        return FadeInImage.assetNetwork(
          placeholder: "img/go.png",
          image: widget.animal.image,
          height: 800.0,
          width: 700.0,
        );
      } else {
        return Text("Imagen no seleccionada");
      }
    }
  }

  imageSelectorGallery() async {
    galleryFile= await ImagePicker.pickImage(
      source: ImageSource.gallery,
      maxHeight: 800.0,
      maxWidth: 700.0
    );
    setState(() {
      
    });
  }
}
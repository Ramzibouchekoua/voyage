import 'package:flutter/material.dart';
import 'gallery-details.page.dart';

class GalleriePage extends StatelessWidget {
  TextEditingController txt_gallerie = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Page Gallerie')),
        body: Column(
          children: [
            Container(
              padding: EdgeInsets.all(10),
              child: TextFormField(
                controller: txt_gallerie,
                decoration: InputDecoration(
                    prefixIcon: Icon(Icons.photo_library),
                    hintText: "Keyword",
                    border: OutlineInputBorder(
                        borderSide: BorderSide(width: 1),
                        borderRadius: BorderRadius.circular(10))),
              ),
            ),
            Container(
              padding: EdgeInsets.all(10),
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(50)),
                  onPressed: () {
                    onGetGallerieDetails(context);
                  },
                  child: Text('Chercher', style: TextStyle(fontSize: 22))),
            ),
          ],
        ));
  }

  void onGetGallerieDetails(BuildContext context) {
    String keyword = txt_gallerie.text;
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => GallerieDetailsPage(keyword)));
    txt_gallerie.text = "";
  }
}

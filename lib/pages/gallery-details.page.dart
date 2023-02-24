import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class GallerieDetailsPage extends StatefulWidget {
  String keyword = '';

  GallerieDetailsPage(this.keyword);
  @override
  State<GallerieDetailsPage> createState() => _GallerieDetailsPageState();
}

class _GallerieDetailsPageState extends State<GallerieDetailsPage> {
  int currentPage = 1;
  int size = 10;
  late num totalPages = 100;
  ScrollController _scrollController = new ScrollController();
  List<dynamic> hits = [];
  var gallerieData;

  @override
  void initState() {
    super.initState();
    getGallerieDate(widget.keyword);
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        if (currentPage < totalPages) {
          ++currentPage;
          getGallerieDate(widget.keyword);
        }
      }
    });
  }

  void getGallerieDate(String keyword) {
    print("Gallerie de " + keyword);
    String url =
        "https://pixabay.com/api/?key=15646595-375eb91b3408e352760ee72c8&q=${keyword}&pages=${currentPage}&per_page=${size}";
    http.get(Uri.parse(url)).then((resp) {
      setState(() {
        this.gallerieData = json.decode(resp.body);
        hits.addAll(gallerieData['hits']);
        if (gallerieData['totalHits'] % size == 0)
          totalPages = gallerieData['totalHits'] ~/ size;
        else {
          totalPages = 1 + (gallerieData['totalHits'] / size).floor();
        }
        hits = gallerieData['hits'];
        print(hits);
      });
    }).catchError((err) {
      print(err);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Galleries Details ${widget.keyword} '
              '${currentPage}/${totalPages}'),
        ),
        body: (gallerieData == null
            ? Center(child: CircularProgressIndicator())
            : ListView.builder(
                itemCount: (gallerieData == null ? 0 : hits.length),
                controller: _scrollController,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.only(left: 10, right: 10),
                        child: Card(
                          child: Padding(
                            padding: EdgeInsets.all(10),
                            child: Center(
                              child: Text(hits[index]['tags'],
                                  style: TextStyle(
                                    fontSize: 22,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  )),
                            ),
                          ),
                          color: Colors.blue,
                        ),
                      ),
                      Container(
                        child: Card(
                          child: Image.network(
                            hits[index]['webformatURL'],
                            fit: BoxFit.fitWidth,
                          ),
                        ),
                        padding: EdgeInsets.only(left: 10, right: 10),
                      )
                    ],
                  );
                },
              )));
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }
}

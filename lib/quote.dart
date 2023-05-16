import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as parser;

class quotepage extends StatefulWidget {
  final String categoryname;
  quotepage(this.categoryname);
  @override
  State<quotepage> createState() => _quotepageState();
}

class _quotepageState extends State<quotepage> {
  List<String> Categories = ["love", "inspirational", "Life", "humar"];
  List quotes=[];
  List authors=[];
  bool isDataThere = false;
  @override
  void initState() {
    super.initState();
    setState(() {
      getquotes();
    });
  }
  getquotes() async {
    String url="https://quotes.toscrape.com/tag/${widget.categoryname}/";
    Uri uri=Uri.parse(url);
    http.Response response=await http.get(uri);
    dom.Document document = parser.parse(response.body);
    final quotesclass=document.getElementsByClassName("quote");
    quotes=
        quotesclass.map((element) => element.getElementsByClassName('text')[0].innerHtml).toList();
    authors=
        quotesclass.map((element) => element.getElementsByClassName('author')[0].innerHtml).toList();
    setState(() {
      isDataThere = true;
    }
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal,
      body:isDataThere== false? Center(child: CircularProgressIndicator(),):
      SingleChildScrollView(
        physics: ScrollPhysics(),
        child: Column(
          children: [
            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.only(top: 40),
              child: Text(
                'QUOTES APP',
                style: TextStyle(
                    fontSize: 30,
                    color: Colors.brown,fontWeight: FontWeight.w700
                ),
              ),
            ),
            ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: 8,
                itemBuilder: (context ,index){
                  return Container(
                      child: Card(
                          color: Colors.white.withOpacity(0.8),
                          elevation: 10,
                          child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 20,left: 20,bottom: 20),
                                  child: Text(quotes[index],
                                      style: TextStyle(fontSize: 18,color: Colors.blue,fontWeight: FontWeight.w700)),
                                ),
                                Padding(padding: const EdgeInsets.only(bottom: 10),
                                    child: Text(authors[index],
                                      style: TextStyle(fontSize: 15,color: Colors.blue,fontWeight: FontWeight.w700),

                                    )
                                )
                              ]
                          )
                      )
                  );
                }
            )
          ],
        ),
      ),
    );
  }
}
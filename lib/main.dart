import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HttpApp(),
    );
  }
}

class HttpApp extends StatefulWidget {
  const HttpApp({Key? key}) : super(key: key);

  @override
  _HttpAppState createState() => _HttpAppState();
}

class _HttpAppState extends State<HttpApp> {
  String result = '';
  TextEditingController? _editingController;
  ScrollController? _scrollController;
  List? data;
  int page = 1;

  @override
  void initState(){
    super.initState();
    data = new List.empty(growable: true);
    _editingController = new TextEditingController();
    _scrollController = new ScrollController();
    _scrollController!.addListener(() {
      if (_scrollController!.offset >=
          _scrollController!.position.maxScrollExtent &&
          !_scrollController!.position.outOfRange) {
        print('bottom');
        page++;
        getJSONData();
      }
    });
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _editingController,
          style: TextStyle(color: Colors.white),
          keyboardType: TextInputType.text,
          decoration: InputDecoration(hintText: '검색어를 입력하세요'),
        ),
      ),
      body: Container(
        child: Center(
          child: data!.length == 0
            ? Text('데이터가 없습니다.\n검색해주세요',
            style: TextStyle(fontSize: 20),
          textAlign: TextAlign.center,
          )
              : ListView.builder(itemBuilder: (context, index) {
                return Card(
                  child:Container(
                    child: Row(
                      children: [
                        Text(data![index]['prgsStts']),
                      ],
                    ),
                  ),
                );
          },
          )
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          getJSONData();
        },
        child: Icon(Icons.file_download),
      ),
    );
  }
  Future<String> getJSONData() async {
    var url =
        'https://unipass.customs.go.kr:38010/ext/rest/cargCsclPrgsInfoQry/retrieveCargCsclPrgsInfo?crkyCn=s200v271w100q115q010v000q0&cargMtNo=00ANLU083N59007001';

    var response = await http.get(Uri.parse(url));

   setState(() {
     var dataConvertedToJSON = json.decode(response.body);
     List result = dataConvertedToJSON['cargCsclPrgsInfoQryRtnVo'];
     data!.addAll(result);
   });

    return response.body ;
  }
}

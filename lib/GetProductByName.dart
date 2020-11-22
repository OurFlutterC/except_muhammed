import 'package:flutter/material.dart';
import 'package:web_scraper/web_scraper.dart';
import 'package:qrscan/qrscan.dart' as scanner;

class GetByName extends StatefulWidget {
  GetByName({Key key}) : super(key: key);

  @override
  _GetByNameState createState() => _GetByNameState();
}

class _GetByNameState extends State<GetByName> {
  final webScraper = WebScraper('https://world.openfoodfacts.org');
  bool loading = false;
  List<Map<String, dynamic>> productNames = [];
  List<Map<String, dynamic>> productImage = [];
  String searchTxt = "";
  int pg = 0;
  bool searching = false;
  String barcode;
  void fetchProducts(String product,{String page}) async {
    // Loads web page and downloads into local state of library
    String index = page==null?"":"&page=$page";
    setState(() {
      loading = true;
    });
    if (await webScraper.loadWebPage(
        '/cgi/search.pl?action=process&search_terms=$product&sort_by=unique_scans_n&page_size=50$index&origins=france')) {
      setState(() {
        // getElement takes the address of html tag/element and attributes you want to scrap from website
        // it will return the attributes in the same order passed
        productNames =
            webScraper.getElement('ul.products > li > a ', ['title']);
        productImage = webScraper
            .getElement('ul.products > li > a > div  > img ', ['srcset']);
        loading = false;
      });
      
    }
    setState(() {
      searching = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    print(barcode);
    return Scaffold(
       floatingActionButton: FloatingActionButton(
          child: Icon(Icons.qr_code),
          onPressed: _scan,
        ),
      body: Container(
        child: Center(
          child: SingleChildScrollView(
                      child: Column(
              children: [
                SizedBox(
                  height:MediaQuery.of(context).size.height * .05
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                   !searching?Container(): IconButton(icon: Icon(Icons.arrow_back_ios),onPressed: pg==0?(){}:(){
                      pg-=1;
                      fetchProducts(searchTxt,page:pg.toString());
                      }),
                    Container(
                  width: MediaQuery.of(context).size.width * 0.75,
                  height: 55.0,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                            blurRadius: 3,
                            spreadRadius: 0.6,
                            color: Colors.black12,
                            offset: Offset(0, 2))
                      ],
                      borderRadius: BorderRadius.circular(20.0)),
                  child: TextField(
                    onSubmitted: (t) {
                      fetchProducts(t);
                    },
                    onChanged: (t) {
                      setState(() {
                        searchTxt = t;
                      });
                    },
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(vertical: 22.0),
                        prefixIcon: IconButton(
                          onPressed: () {
                            fetchProducts(searchTxt);
                          },
                          icon: Icon(
                            Icons.search,
                            color: Colors.black,
                          ),
                        ),
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                          borderRadius: BorderRadius.all(
                            Radius.circular(20.0),
                          ),
                        )),
                  ),
                ),
               !searching?Container(): IconButton(icon: Icon(Icons.arrow_forward_ios),onPressed: (){
                  pg+=1;
                  fetchProducts(searchTxt,page:pg.toString());
                },)
                  ],
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.01,
                ),
               loading?Center(child:CircularProgressIndicator()):productNames.isNotEmpty?Wrap(children: productNames.map((e) {
                  return items(e['title'],productImage[productNames.indexOf(e)]["attributes"]['srcset']?.replaceFirst(" 2x",""),productNames.indexOf(e).toString());
                }).toList()):Text(getResult())
              ],
            ),
          ),
        ),
      ),
    );
  }

  String getResult(){
    barcode = barcode?.substring(0,3);
    return barcode==null?"قم بتحقق من المنتج قبل شراءه":check(int.parse(barcode))?"هذا المنتج فرنسي":"المنتج ليس فرنسي";

    
  }
    bool check(int nm){
    return nm>=300 && nm<=379;
  }

  Future _scan() async {
    String bar = await scanner.scan();
    setState(() {
      barcode = bar;
    });
    showDialog(context: context,builder: 
    (c)=>Directionality(
      textDirection: TextDirection.rtl,
          child: AlertDialog(
  title: Text('النتيجة'),
  content: Row(
    children: [
      Text(getResult()),
      getResult().contains("ليس")?Icon(Icons.done,size: 50.0,color: Colors.green,):Icon(Icons.close,size: 50.0,color: Colors.red,)
    ],
  ),
  actions: [
      FlatButton(
        textColor: Color(0xFF6200EE),
        onPressed: () =>Navigator.pop(context),
        child: Text('تم'),
      ),
  ],
),
    )
    );
  }
  Widget items(String title,String img,String id) {
    return Padding(
      padding: const EdgeInsets.only(top: 15.0),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 20.0)]),
        child: ListTile(
          onTap: ()=>Navigator.of(context).push(
            MaterialPageRoute(builder: (c)=>Details(title,img,id))
          ),
          trailing: Icon(Icons.close,size: 50.0,color:Colors.red),
          leading: Hero(
            tag: id,
                      child: Container(
              width: MediaQuery.of(context).size.width * 0.2,
              height: MediaQuery.of(context).size.width * 0.2,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(
                          img??"https://bitsofco.de/content/images/2018/12/broken-1.png"))),
            ),
          ),
          title: Text(title.trim()),
        ),
      ),
    );
  }
}

class Details extends StatelessWidget {
  final String title,img,id;
  Details(this.title,this.img,this.id);

  @override
  Widget build(BuildContext context) {
    return Container(
      child:  Hero(
                tag: id,
                  child: Container(
                  width: MediaQuery.of(context).size.width * 0.2,
                  height: MediaQuery.of(context).size.width * 0.2,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          fit: BoxFit.contain,
                          image: NetworkImage(
                              img??"https://bitsofco.de/content/images/2018/12/broken-1.png"))),
                )),
    );
  }
}
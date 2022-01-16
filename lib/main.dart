import 'dart:async';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:recase/recase.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
Future main() async{

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp( MyApp());
}

class MyApp extends StatelessWidget {
   MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    Map<int, Color> color =
    {
      50:Color.fromRGBO(136,14,79, .1),
      100:Color.fromRGBO(136,14,79, .2),
      200:Color.fromRGBO(136,14,79, .3),
      300:Color.fromRGBO(136,14,79, .4),
      400:Color.fromRGBO(136,14,79, .5),
      500:Color.fromRGBO(136,14,79, .6),
      600:Color.fromRGBO(136,14,79, .7),
      700:Color.fromRGBO(136,14,79, .8),
      800:Color.fromRGBO(136,14,79, .9),
      900:Color.fromRGBO(136,14,79, 1),
    };

    final MaterialColor colorCustom = MaterialColor(0xFF880E4F, color);
    return MaterialApp(
      title: 'TMC Subang Jaya Registration',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: colorCustom,
      ),
      home: const MyHomePage(title: 'TMC Subang Jaya Registration'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late double _height;
  late double _width;
  String displayText = 'Welcome Home!';
  String displayTitle = 'Service: ';
  String displayDate = 'Date: ';
  String displayTime = 'Time: ';
  var titlesList2;
  var currentTitle;
  var currentDate;
  var currentChildname;
  var collectResponses=true;
  String totalLimit = "Unspecified";
  int _counter = 0;
  GlobalKey<FormState> _key = new GlobalKey();
  late String name;

  late StreamSubscription _subscription ;
  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    _activateList();
  }
  void getint() {
    final DatabaseReference ref2 = FirebaseDatabase.instance.reference();
    _subscription = ref2.child('new').onValue.listen((event) {
      final String desc = event.snapshot.value;
    });

  }
  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }
  void _activateList(){
    final titlesList = <ListTile>[];
      StreamSubscription currentService = FirebaseDatabase.instance.reference().child('details').limitToLast(1).onValue.listen((event) {
        final curServicedata = new Map<String,dynamic>.from(event.snapshot.value);
        final curServicedate = curServicedata.forEach((key, value)
        {
          final nextNameService = Map.from(value);
          final currentDateService = nextNameService['date'];
          final currentDateTitle = nextNameService['title'];
          collectResponses = nextNameService['collect'];
          currentTitle = currentDateTitle;
          currentDate = nextNameService['time'] + ', ' + nextNameService['date'];
          setState((){
            currentChildname= currentDateService.substring(0,6)+currentDateTitle;

          });
          print(currentTitle+" i am the title");
        });
    });
      print("I am child");
      print(currentChildname);
  }
  int fieldCount = 1;
  var names2;
  var counter = 0;
  var listcounter = 0;
  bool countworks = false;
  var limitCount = 200;
  var currentCount=0;
  var childname = "new";
  var listOfFields = <Widget>[];
  var listOfNames = [];

  Widget FormUI(){
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    if (currentChildname != null){
    var currentRecord = FirebaseDatabase.instance.reference().child(currentChildname).onValue.listen((event) {
      final curdata = new Map<String,dynamic>.from(event.snapshot.value);
      print(curdata);
      titlesList2 = curdata;
      print(titlesList2);
      final curdate = curdata.forEach((key, value)
      {
        final nextName = Map.from(value);
        final orderTile = ListTile(
          title: Text(nextName['name']),
        );
        //titlesList.add(orderTile);
      });
    });
    final DatabaseReference ref2 = FirebaseDatabase.instance.reference();
    var lencount = ref2.child('new').onChildAdded.length;
    print(lencount);
    counter++;
    if (listOfFields.length==0){
      print("field list empty");
      listOfFields.add(TextFormField(
        decoration: new InputDecoration(hintText: 'Name',fillColor: Colors.white),
        maxLength: 64,
        onSaved: (val){
          listOfNames.add(val!);
          //listOfNames = val;
          print(listOfNames);
          print("we have saved "+listOfNames.toString());
        },
        validator: (val){
          if(titlesList2.toString().contains(ReCase(val!).titleCase)){
            print(val!+"contains");
            return 'Name has been registered already';
          }
          else if (val==null){
            return 'Enter a valid name';
          }

          return null;
        },
        //validator: validateName,
      ));
    }


    print("i am couonteer $counter");
    return new Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
    Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,


        children: <Widget>[
          Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[

                Container(
                  margin: EdgeInsets.only(top: 10),
                  //width: _width / 1.2,
                  //height: _height / 9,
                  padding: EdgeInsets.all(10),
                  alignment: Alignment.center,

                  child: ListTile(
                    title: Text(currentTitle+" Registration", style: GoogleFonts.spartan(fontWeight: FontWeight.bold, fontSize: 20),),
                    subtitle: Text(currentDate, style: GoogleFonts.spartan( fontSize: 18,color: Colors.black45,fontWeight: FontWeight.bold),),
                  ),
                ),

              ]
          ),

        ]
    ) ,
        /*Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              ]),*/
        StreamBuilder(
            stream: ref2.child('details').limitToLast(1).onValue,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                print("Hasvalsss");
                final names = Map.from((snapshot.data! as Event).snapshot.value);
                print(names);
                names.forEach((key, value) {
                final nextService = Map<String, dynamic>.from(value);
                final date = nextService['date'];
                final time = nextService['time'];
                final limit = nextService['limit'] ;
                final name = nextService['title'];
                collectResponses = nextService['collect'];
                print("i am collect "+collectResponses.toString());
                childname = date.substring(0,6)+name;
                totalLimit = "$limit";
                displayText = "Registration for $name on $date at $time";
                displayTitle = "$name";
                displayDate = "Date: $time, $date";
                displayTime = "Date: $time";
                limitCount = int.parse(limit);
                print("hereee");
                print(childname);
              //print(currentCount<=limitCount);
              });
                return StreamBuilder(
                  //stream: ref2.child('new').onValue,
                    stream: ref2.child(childname).onValue,
                    builder: (context, snapshot) {
                      final titlesList = <ListTile>[];
                      print('second stream');
                      print(childname);
                      if (snapshot.hasData) {
                        print("has child");
                        if ((snapshot.data! as Event).snapshot.exists){
                          print("true");
                          final names = Map.from((snapshot.data! as Event).snapshot.value);
                          //setState((){
                            countworks =true;
                          //});
                          names2 = names;
                          print("namesss"+names.toString());
                          names.forEach((key, value) {
                            final nextName = Map.from(value);
                            final orderTile = ListTile(
                              title: Text(nextName['name']),
                            );
                            titlesList.add(orderTile);
                          });
                          print(titlesList);
                          currentCount = limitCount - titlesList.length;
                          print("what dissss" + collectResponses.toString());

                          if (currentCount>0 && collectResponses==true){

                            return Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  /*Container(
                                    padding: EdgeInsets.all(20),
                                    //margin: EdgeInsets.only(top: 15),
                                    width: _width/1.2,
                                    alignment: Alignment.topLeft,
                                    child: Container(
                                      child: Text("Enter Name: (1 per person)", style: GoogleFonts.spartan(fontWeight: FontWeight.bold),),
                                    ),
                                  ),*/
                                  Container(
                                      padding: EdgeInsets.all(5),
                                      margin: EdgeInsets.only(top: 5),
                                      width: _width,
                                      alignment: Alignment.topLeft,
                                      child:
                                  ListTile(
                                      title: Text("Enter Name: ", style: GoogleFonts.spartan(fontWeight: FontWeight.bold),),
                                    //subtitle:TextButton(onPressed: _resetForm,child:Text("Clear Form",style: GoogleFonts.spartan(fontWeight: FontWeight.bold),),),
                                    trailing:ElevatedButton(onPressed: _addMembers, child: const Text("+ Add 1 More")),
                                      ),


                                ),
                                  /*Container(
                                      width: _width / 1.2,
                                      height: _height/3,
                                      alignment: Alignment.center,
                                      padding: EdgeInsets.only(left: 10,right: 10),
                                      child:*/
                                  Column(

                                      children:<Widget>[ListView.builder(
                      padding:EdgeInsets.only(left: 10,right: 10),
                                      physics: NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      itemCount: listOfFields.length,
                                      itemBuilder: (context, index){
                                        return listOfFields[index];
                                      }),]),

                                  //),
                                  Container(
                                      width: _width / 1.3,
                                      //height: _height /3,
                                      alignment: Alignment.center,
                                      //padding: EdgeInsets.only(left: 10,right: 10),
                                      child:ListTile(
                                    //title: Text("Enter Name: ", style: GoogleFonts.spartan(fontWeight: FontWeight.bold),),
                                    trailing:TextButton(onPressed: _resetForm,child:Text("Clear Form",style: GoogleFonts.spartan(fontWeight: FontWeight.bold),),),
                                    //trailing:ElevatedButton(onPressed: _addMembers, child: const Text("+ Add 1 More")),
                                  )),
                                  Container(
                                    width: _width / 1.3,
                                    //height: _height /3,
                                    alignment: Alignment.center,
                                    padding: EdgeInsets.only(left: 10,right: 10),
                                    child:

                                      ListTile(

                                        //title: Text(titlesList.length.toString()+ totalLimit),
                                        //child: ElevatedButton(onPressed: currentCount>=0?_addMembers(titlesList2):null, child: const Text("Add"),),
                                        title: ElevatedButton(onPressed: currentCount>=0?_sendToDB2:null, child: new Text("Submit"),),

                                      ),


                                      //width: _width / 1.2,
                                      //height: _height / 9,
                                      //alignment: Alignment.center,
                                      //child:
                                      ),

                                  /*Container(
                                      margin: EdgeInsets.only(top: 15),
                                      width: _width / 1.2,
                                      //height: _height / 9,
                                      alignment: Alignment.center,
                                      child:
                                      ListTile(
                                        title: ElevatedButton(onPressed: currentCount>=0?_sendToDB2:null, child: new Text("Submit"),),
                                      )),*/

                                  Container(
                                      //margin: EdgeInsets.only(top: 15),
                                      width: _width / 1.2,
                                      //height: _height / 9,
                                      alignment: Alignment.center,
                                      child:
                                      Container(
                                        //title: Text(titlesList.length.toString()+ totalLimit),
                                        child: Text((currentCount).toString(), style: TextStyle(fontWeight: FontWeight.bold,fontSize: 60),),

                                      )),
                                  Container(
                                      width: _width / 1.2,
                                      //height: _height / 9,
                                      alignment: Alignment.center,
                                      child:
                                      Container(
                                        //title: Text(titlesList.length.toString()+ totalLimit),
                                        child: Text("Slots Left", style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),

                                      )),

                                ]
                            ) ;
                          }
                          else if (collectResponses ==false){
                            // const _url = 'whatsapp://send?phone=60103708806';
                            const _url = 'https://api.whatsapp.com/send/?phone=60103708806';
                             void _launchURL(String func) async => await canLaunch(_url)
                                 ? await launch(_url) : throw 'Not found $_url';
                             return Container(
                              child: ListTile(
                                //title: Text(titlesList.length.toString()+ totalLimit),
                                title: Text("Registration is currently closed", style: GoogleFonts.spartan(fontWeight: FontWeight.bold,fontSize: 16),),
                                subtitle:Text("For more details contact Rev. Timothy Raj", style: GoogleFonts.spartan(fontWeight: FontWeight.bold,fontSize: 14),),
                                trailing: TextButton(onPressed: () { _launchURL(_url); }, child: Text("Contact Us"),),
                                //subtitle: ElevatedButton(onPressed: currentCount>=0?_sendToDB:null, child: new Text("Submit"),),
                              ),
                            );
                          }
                          else {
                            return Container(
                              child: ListTile(
                                //title: Text(titlesList.length.toString()+ totalLimit),
                                title: Text("Slots full!", style: GoogleFonts.spartan(fontWeight: FontWeight.bold,fontSize: 18),),
                                //subtitle: ElevatedButton(onPressed: currentCount>=0?_sendToDB:null, child: new Text("Submit"),),
                              ),
                            );
                          }

                        }
                        else{
                          print("no child");
                          return Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                  padding: EdgeInsets.all(5),
                                  margin: EdgeInsets.only(top: 5),
                                  width: _width,
                                  alignment: Alignment.topLeft,
                                  child:
                                  ListTile(
                                    title: Text("Enter Name: ", style: GoogleFonts.spartan(fontWeight: FontWeight.bold),),
                                    //subtitle:TextButton(onPressed: _resetForm,child:Text("Clear Form",style: GoogleFonts.spartan(fontWeight: FontWeight.bold),),),
                                    trailing:ElevatedButton(onPressed: _addMembers, child: const Text("+ Add 1 More")),
                                  ),


                                ),

                                Column(

                                    children:<Widget>[ListView.builder(
                                        physics: NeverScrollableScrollPhysics(),
                                        padding:EdgeInsets.only(left: 10,right: 10),
                                        shrinkWrap: true,
                                        itemCount: listOfFields.length,
                                        itemBuilder: (context, index){
                                          return listOfFields[index];
                                        }),]),
                                Container(
                                    width: _width / 1.3,
                                    //height: _height /3,
                                    alignment: Alignment.center,
                                    //padding: EdgeInsets.only(left: 10,right: 10),
                                    child:ListTile(
                                      //title: Text("Enter Name: ", style: GoogleFonts.spartan(fontWeight: FontWeight.bold),),
                                      trailing:TextButton(onPressed: _resetForm,child:Text("Clear Form",style: GoogleFonts.spartan(fontWeight: FontWeight.bold),),),
                                      //trailing:ElevatedButton(onPressed: _addMembers, child: const Text("+ Add 1 More")),
                                    )),
                                Container(
                                  width: _width / 1.3,
                                  //height: _height /3,
                                  alignment: Alignment.center,
                                  padding: EdgeInsets.only(left: 10,right: 10),
                                  child:

                                  ListTile(

                                    //title: Text(titlesList.length.toString()+ totalLimit),
                                    //child: ElevatedButton(onPressed: currentCount>=0?_addMembers(titlesList2):null, child: const Text("Add"),),
                                    title: ElevatedButton(onPressed: currentCount>=0?_sendToDB2:null, child: new Text("Submit"),),

                                  ),


                                  //width: _width / 1.2,
                                  //height: _height / 9,
                                  //alignment: Alignment.center,
                                  //child:
                                ),
                                /*Container(
                                    width: _width / 1.2,
                                    //height: _height / 9,
                                    alignment: Alignment.center,
                                    child:
                                    Container(
                                      alignment: Alignment.center,
                                      //title: Text(titlesList.length.toString()+ totalLimit),
                                      //child: ElevatedButton(onPressed: currentCount>=0?_addMembers(titlesList2):null, child: const Text("Add"),),
                                      child: ElevatedButton(onPressed: _addMembers, child: const Text("+ Add 1 More")),

                                    )),

                                Container(
                                    margin: EdgeInsets.only(top: 15),
                                    width: _width / 1.2,
                                    height: _height / 9,
                                    alignment: Alignment.center,
                                    child:
                                    ListTile(
                                      title: ElevatedButton(onPressed: currentCount>=0?_sendToDB2:null, child: new Text("Submit"),),
                                    )),*/
                                Container(
                                    margin: EdgeInsets.only(top: 15),
                                    width: _width / 1.2,
                                    //height: _height / 9,
                                    alignment: Alignment.center,
                                    child:
                                    Container(
                                      //title: Text(titlesList.length.toString()+ totalLimit),
                                      child: Text(totalLimit, style: TextStyle(fontWeight: FontWeight.bold,fontSize: 60),),

                                    )),
                                Container(
                                    width: _width / 1.2,
                                    //height: _height / 9,
                                    alignment: Alignment.center,
                                    child:
                                    Container(
                                      //title: Text(titlesList.length.toString()+ totalLimit),
                                      child: Text("Slots Left", style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),

                                    )),
                                SizedBox(height:0)
                              ]
                          ) ;
                        }
                      }
                      else{
                        print("no child");
                        return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                  margin: EdgeInsets.only(top: 15),
                                  width: _width / 1.2,
                                  //height: _height / 9,
                                  alignment: Alignment.center,
                                  child:
                                  Container(
                                    //title: Text(titlesList.length.toString()+ totalLimit),
                                    child: Text(totalLimit, style: TextStyle(fontWeight: FontWeight.bold,fontSize: 60),),

                                  )),
                              Container(
                                  width: _width / 1.2,
                                  //height: _height / 9,
                                  alignment: Alignment.center,
                                  child:
                                  Container(
                                    //title: Text(titlesList.length.toString()+ totalLimit),
                                    child: Text("Slots Left", style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),

                                  )),
                            ]
                        ) ;
                      }
                    }

                    );


              }
              else{
                return Container(
                  padding:EdgeInsets.all(30),

                  margin: EdgeInsets.only(top: 15),
                  width: _width / 1.1,
                  //height: _height / 9,
                  alignment: Alignment.center,
                  child: ListTile(
                    //title: Text(titlesList.length.toString()+ totalLimit),
                    title: Text("No data", style: TextStyle( fontWeight: FontWeight.bold),),
                    //subtitle: ElevatedButton(onPressed: currentCount>=0?_sendToDB:null, child: new Text("Submit"),),
                  ),
                );
              }


    }
    ),

      ],
    );

    }
    else{
      return LinearProgressIndicator();
    }
  }
  _resetForm(){

    setState(() {
      listcounter=0;
      listOfFields=[
        TextFormField(
          decoration: new InputDecoration(hintText: 'Name',fillColor: Colors.white),
          maxLength: 64,
          onSaved: (val){
            listOfNames.add(val!);
            //listOfNames = val;
            print(listOfNames);
            print("we have saved "+listOfNames.toString());
          },
          validator: (val){
            if(titlesList2.toString().contains(val!)){
              print(val!+"contains");
              return 'Name has been registered already';
            }
            return null;
          },
          //validator: validateName,
        )
      ];
    });
    listOfNames=[];

    _key.currentState?.reset();

  }
  _addMembers(){
    if (listcounter>=4){
      return showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text("Alert!"),
          content: Text("Please submit this list first"),

          actions: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.of(ctx).pop();
              },
              child: Text("Okay!"),
            ),
          ],
        ),

      );
    }
    else {
      _key.currentState?.save();
      listOfNames = [];
      setState(() {
        fieldCount++;
        listcounter++;
        listOfFields.add(TextFormField(
          decoration: new InputDecoration(
              hintText: 'Name', fillColor: Colors.white),
          maxLength: 64,
          onSaved: (val) {
            listOfNames.add(val!);
            //listOfNames = val;
            print(listOfNames);
            print("we have saved " + listOfNames.toString());
          },
          validator: (val) {
            if (titlesList2.toString().contains(val!)) {
              print(val! + "contains");
              return 'Name has been registered already';
            }
            return null;
          },
          //validator: validateName,
        ));
        print(listOfNames);
        print('im the list of names');
      });
    }

  }
  _confirmreg(){
    if (_key.currentState!.validate()){
      print("i am in confirm reggg");
      //_key.currentState?.save();
      final DatabaseReference ref = FirebaseDatabase.instance.reference();
      print(ref.toString());
      print('inside functionsssss');
      listOfNames.forEach((element) {
        var data = {
          "name":element,
        };
        ref.child(currentChildname).push().set(data);
        print(data);
      });
      setState(() {
        listcounter=0;
        listOfFields=[
          TextFormField(
            decoration: new InputDecoration(hintText: 'Name',fillColor: Colors.white),
            maxLength: 64,
            onSaved: (val){
              listOfNames.add(val!);
              //listOfNames = val;
              print(listOfNames);
              print("we have saved "+listOfNames.toString());
            },
            validator: (val){
              if(titlesList2.toString().contains(val!)){
                print(val!+"contains");
                return 'Name has been registered already';
              }
              else if (val==null){
                return 'Enter a valid name';
              }
              return null;
            },
            //validator: validateName,
          )
        ];
      });
      _key.currentState?.reset();
      listOfNames=[];

    }
    else{
      print("bye");
    };
  }
  _sendToDB2(){
    if (_key.currentState!.validate()){
      var alertlist = listOfNames;
      print(alertlist);
      print("hello");
      _key.currentState?.save();
      /*final DatabaseReference ref = FirebaseDatabase.instance.reference();
      print(ref.toString());
      print('inside functionsssss');
      listOfNames.forEach((element) {
        var data = {
          "name":element,
        };
        ref.child(currentChildname).push().set(data);
        print(data);
      });
      setState(() {
        listcounter=0;
        listOfFields=[
          TextFormField(
            decoration: new InputDecoration(hintText: 'Name',fillColor: Colors.white),
            maxLength: 64,
            onSaved: (val){
              listOfNames.add(val!);
              //listOfNames = val;
              print(listOfNames);
              print("we have saved "+listOfNames.toString());
            },
            validator: (val){
              if(titlesList2.toString().contains(val!)){
                print(val!+"contains");
                return 'Name has been registered already';
              }
              else if (val==null){
                return 'Enter a valid name';
              }
              return null;
            },
            //validator: validateName,
          )
        ];
      });
      _key.currentState?.reset();
      listOfNames=[];*/
      return showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text("Confirm registration for the following?"),
          content: //Text("You have raised a Alert Dialog Box"),
           Container(
          height: 300.0, // Change as per your requirement
          width: 300.0, // Change as per your requirement
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: alertlist.length,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                title: Text(alertlist[index]),
              );
            },
          ),
        ),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.of(ctx).pop();
                //_confirmreg;
              },
              child: Text("No"),
            ),
            ElevatedButton(
              onPressed: () {
                //Navigator.of(ctx).pop();
                _confirmreg();
                Navigator.of(ctx).pop();
              },
              child: Text("Yes, Confirm!"),
            ),
          ],
        ),

      );



    }
    else{
      print("bye");
    };
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      //backgroundColor: Colors.black,

      appBar: AppBar(title: Text("TMC SUBANG JAYA REGISTRATION",
          //style: TextStyle(fontFamily: 'RoadRage',color: Colors.white, letterSpacing: 1.0, fontWeight: FontWeight.bold,height: .7)
          style: GoogleFonts.cinzel(
            textStyle: TextStyle(color: Colors.white, letterSpacing: 1.0, wordSpacing: 3.0,fontWeight: FontWeight.bold, fontSize: 12),
          )
      )
      , backgroundColor: Colors.black,),

      //body: NestedScrollView(body:
      body:new SingleChildScrollView(

          child: Container(
            child: new Form(

              child: FormUI(),
              key: _key,

            ),
          )
      )
        /*, headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {


        return <Widget>[
          SliverAppBar(
            backgroundColor: Colors.black,
            expandedHeight: 150.0,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
                centerTitle: true,

                title: Text("TMC SUBANG JAYA REGISTRATION",
                        //style: TextStyle(fontFamily: 'RoadRage',color: Colors.white, letterSpacing: 1.0, fontWeight: FontWeight.bold,height: .7)
                        style: GoogleFonts.cinzel(
                          textStyle: TextStyle(color: Colors.white, letterSpacing: 3.0, fontWeight: FontWeight.bold, fontSize: 14),
                        )
                    ) ,
                background: Image.asset('assets/worship2.jpg',
                    //'https://i.pinimg.com/originals/6f/d0/55/6fd055d41eccc348c5cca0b8da18d01b.png',
                    //'ims/sneklogo.png',
                  ////_getbanner().toString(),
                    fit: BoxFit.fitHeight
                )


            ),
          ),
        ];
      },)*/

        // This trailing comma makes auto-formatting nicer for build methods.
    );
  }



}

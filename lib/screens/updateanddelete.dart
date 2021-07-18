import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'Homepage.dart';

class UpdateandDelete extends StatefulWidget {
  final String bookid;
  UpdateandDelete(this.bookid);

  @override
  _UpdateandDeleteState createState() => _UpdateandDeleteState();
}

class _UpdateandDeleteState extends State<UpdateandDelete> {
  String bookname = "";
  String authorname = "";
  String rating = '';
  TextEditingController ratingcontroller = TextEditingController();
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    gettinguserbookname();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        automaticallyImplyLeading: true,
        title: Text(
          'Add new book',
          style: TextStyle(
            fontFamily: 'Poppins',
          ),
        ),
        actions: [],
        centerTitle: true,
        elevation: 4,
      ),
      body: SafeArea(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 1,
          decoration: BoxDecoration(
            color: Color(0xFFEEEEEE),
          ),
          child: ListView(
            padding: EdgeInsets.zero,
            scrollDirection: Axis.vertical,
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                child: Text(
                  'Book Name:',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Color(0xFFBEBBBB),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(5, 15, 5, 15),
                    child: Text(bookname),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                child: Text(
                  'Author name:',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Color(0xFFBEBBBB),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                      padding: EdgeInsets.fromLTRB(5, 15, 5, 15),
                      child: Text(authorname)),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                child: Text(
                  'Give Rating to this book:',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Color(0xFFBEBBBB),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                    child: TextFormField(
                      controller: ratingcontroller,
                      keyboardType: TextInputType.number,
                      obscureText: false,
                      decoration: InputDecoration(
                        hintText: rating,
                        hintStyle: TextStyle(
                          fontFamily: 'Poppins',
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0x00000000),
                            width: 1,
                          ),
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(4.0),
                            topRight: Radius.circular(4.0),
                          ),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0x00000000),
                            width: 1,
                          ),
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(4.0),
                            topRight: Radius.circular(4.0),
                          ),
                        ),
                      ),
                      style: TextStyle(
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                  padding: EdgeInsets.fromLTRB(20, 30, 20, 0),
                  child: Row(
                    children: [
                      RaisedButton(
                        onPressed: () {
                          print('Button pressed ...');
                          updatebook();
                        },
                        child: Container(
                          width: 100,
                          height: 40,
                          child: Center(
                            child: Text(
                              'Update',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                color: Colors.white,
                              ),
                            ),
                          ),
                          decoration: BoxDecoration(
                            color: Colors.lightGreen,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(12),
                                topRight: Radius.circular(12),
                                bottomLeft: Radius.circular(12),
                                bottomRight: Radius.circular(12)),
                          ),
                        ),
                      ),
                      SizedBox(width: 20),
                      RaisedButton(
                        onPressed: () {
                          print('Button pressed ...');
                          deletebook();
                        },
                        child: Container(
                          width: 100,
                          height: 40,
                          child: Center(
                            child: Text(
                              'Delete',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                color: Colors.white,
                              ),
                            ),
                          ),
                          decoration: BoxDecoration(
                            color: Colors.lightGreen,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(12),
                                topRight: Radius.circular(12),
                                bottomLeft: Radius.circular(12),
                                bottomRight: Radius.circular(12)),
                          ),
                        ),
                      ),
                    ],
                  ))
            ],
          ),
        ),
      ),
    );
  }

  gettinguserbookname() async {
    await FirebaseFirestore.instance
        .collection('books')
        .doc(widget.bookid)
        .get()
        .then((value) {
      if (value.data() != null) {
        if (mounted) {
          setState(() {
            bookname = (value.data() as dynamic)['bookname'];
            authorname = (value.data() as dynamic)['authorname'];
            rating = (value.data() as dynamic)['rating'].toString();
          });
        } else {
          bookname = (value.data() as dynamic)['bookname'];
          authorname = (value.data() as dynamic)['authorname'];
          rating = (value.data() as dynamic)['rating'].toString();
        }
      }
    });
  }

  deletebook() async {
    await FirebaseFirestore.instance
        .collection('books')
        .doc(widget.bookid)
        .delete()
        .then((_) {
      Navigator.pop(context);
      Fluttertoast.showToast(
          msg: "Book deleted",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0);
    });
  }

  updatebook() async {
    if (ratingcontroller.text != "") {
      await FirebaseFirestore.instance
          .collection('books')
          .doc(widget.bookid)
          .update({'rating': int.parse(ratingcontroller.text)}).then((_) {
        Navigator.pop(context);

        Fluttertoast.showToast(
            msg: "Book Updated",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16.0);
        print('updated');
      });
    }
  }
}

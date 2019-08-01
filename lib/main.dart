import 'dart:async';

import 'package:flutter/material.dart';

//import 'package:barcode_scan/barcode_scan.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:flutter/services.dart';
import 'package:share/share.dart';

void main() => runApp(MaterialApp(
	  theme: ThemeData(primaryColor: Colors.black, primarySwatch: Colors.blue),
	  debugShowCheckedModeBanner: false,
	  home: HomePage(),
	));

class HomePage extends StatefulWidget {
  @override
  HomePageState createState() {
	return new HomePageState();
  }
}

class HomePageState extends State<HomePage> {
  String result = "Hey there !";
  String path = "";

  static const platform = const MethodChannel('tx.novalogic.dev/fincrypt');

  //static final _notDone = 'DECODE.NOT_DONE';
  // Get the message
  String _message = 'No Message';

  Future<void> _scan(String methodToInvoke) async {
	try {
	  String result = await platform.invokeMethod(methodToInvoke);
	  setState(() {
		result = result;
		_message = "A Message was decoded YAY";
	  });
	} on PlatformException catch (ex) {
	  if (ex.code == "PERMISSION_NOT_GRANTED") {
		setState(() {
		  result = "Camera permission was denied";
		});
	  } else {
		setState(() {
		  result = "Unknown Error $ex";
		});
	  }
	} on FormatException {
	  setState(() {
		result = "You pressed the back button before scanning anything";
	  });
	} catch (ex) {
	  setState(() {
		result = "Unknown Error $ex";
	  });
	}
  }

  // Future<List<dynamic>> _getMessage(String msg) async {
  //   List<dynamic> message;
  //   try {
  //     final List<dynamic> result = await platform.invokeMethod('decodeMessage', msg);
  //     message = result;
  //   } on PlatformException catch (e) {
  //     message = ['Failed to retrieve message ${e.message}', -1.0];
  //   }

  //   setState(() {
  //     _message = message;
  //   });

  //   return _message;
  // }

  // Future<void> _scanQR(BuildContext myContext) async {
  //   try {
  //     while ((await _getMessage(await BarcodeScanner.scan()))[0] == _notDone) {
  //       //show snackbar
  //       Scaffold.of(myContext).showSnackBar(
  //         SnackBar(content: Text("?")),
  //       );
  //     }

  //     setState(() async {
  //       result = _message[0] as String;
  //     });
  //   } on PlatformException catch (ex) {
  //     if (ex.code == BarcodeScanner.CameraAccessDenied) {
  //       setState(() {
  //         result = "Camera permission was denied";
  //       });
  //     } else {
  //       setState(() {
  //         result = "Unknown Error $ex";
  //       });
  //     }
  //   } on FormatException {
  //     setState(() {
  //       result = "You pressed the back button before scanning anything";
  //     });
  //   } catch (ex) {
  //     setState(() {
  //       result = "Unknown Error $ex";
  //     });
  //   }
  // }

  void _showModalBottomSheet(BuildContext context) {
	showModalBottomSheet(
		context: context,
		builder: (context) => Material(
			clipBehavior: Clip.antiAlias,
			color: Colors.white,
			child: Container(
			  height: 220,
			  child: Column(
				//mainAxisAlignment: MainAxisAlignment.spaceAround,
				mainAxisSize: MainAxisSize.min,
				children: <Widget>[
				  bottomMenuHeader(),
				  Expanded(
					child: SizedBox(
					  height: 40,
					  child: GridView.count(
						crossAxisSpacing: 2,
						crossAxisCount: 4,
						children: <Widget>[
						  IconButton(
							iconSize: 40,
							icon: Icon(Icons.share),
							color: Colors.blueGrey[600],
							tooltip: 'Share',
							onPressed: () {
							  Share.share(result);
							},
						  ),
						  IconButton(
							iconSize: 40,
							icon: Icon(Icons.camera_alt),
							color: Colors.blueGrey[600],
							tooltip: 'Scan a TxQR',
							onPressed: () {
							  _scan('scan');
							},
						  ),
						  IconButton(
							iconSize: 40,
							icon: Icon(Icons.camera),
							color: Colors.blueGrey[600],
							tooltip: 'Alternate Scanner',
							onPressed: () {
							  _scan('altScan');
							},
						  ),
						  IconButton(
							iconSize: 40,
							icon: Icon(Icons.code),
							color: Colors.blueGrey[600],
							tooltip: 'OutputQR v1',
							onPressed: () async {
							  String path =
								  await platform.invokeMethod('makeQR', result);
							  setState(() {
								this.path = path;
							  });
							},
						  )
						],
					  ),
					),
				  ),
				  // Expanded(
				  //   child: ListView.builder(
				  //     shrinkWrap: false,
				  //     itemCount: items.length,
				  //     itemBuilder: (context, i) => Padding(
				  //           padding: const EdgeInsets.symmetric(horizontal: 10.0),
				  //           child: ListTile(
				  //               title: Text(
				  //                 items[i],
				  //               ),
				  //               leading: whichIcon(items[i]),
				  //               onTap: () {
				  //                 if (items[i] == "Share") {
				  //                   Share.share(result);
				  //                 } else {
				  //                   _scan();
				  //                 }
				  //               }),
				  //         ),
				  //   ),
				  // ),
				  //about tile?
				],
			  ),
			)));
  }

  // Widget whichIcon(String item) {
  //   if (item == "Share") {
  //     return Icon(Icons.share);
  //   } else {
  //     return Icon(Icons.camera_alt);
  //   }
  // }

  Widget bottomMenuHeader() => Ink(
		decoration: BoxDecoration(
			gradient: LinearGradient(colors: [Colors.black, Colors.blueGrey])),
		child: Padding(
		  padding: const EdgeInsets.all(16.0),
		  child: Row(
			mainAxisAlignment: MainAxisAlignment.spaceEvenly,
			children: <Widget>[
			  Padding(
				padding: const EdgeInsets.all(8.0),
				child: Column(
				  // crossAxisAlignment: CrossAxisAlignment.start,
				  mainAxisAlignment: MainAxisAlignment.center,
				  children: <Widget>[
					Text(
					  "TxQr Fincrypt",
					  style: TextStyle(
						  fontSize: 20.0,
						  fontWeight: FontWeight.w700,
						  color: Colors.green),
					),
					SizedBox(
					  height: 5.0,
					),
					Text(
					  "Things To Do",
					  style: TextStyle(
						  fontSize: 15.0,
						  fontWeight: FontWeight.normal,
						  color: Colors.blueAccent),
					),
				  ],
				),
			  )
			],
		  ),
		),
	  );

  Widget txAppBar() => SliverAppBar(
		backgroundColor: Colors.black,
		pinned: true,
		elevation: 10.0,
		forceElevated: true,
		expandedHeight: 150.0,
		flexibleSpace: FlexibleSpaceBar(
		  centerTitle: false,
		  background: Container(
			decoration: BoxDecoration(
				gradient: LinearGradient(
					colors: ([
			  Colors.blueGrey[800],
			  Colors.black87,
			]))),
		  ),
		  title: Row(
			children: <Widget>[
			  QrImage(
				data: "v2.1.2 alpha",
				size: 60,
				foregroundColor: Colors.black,
				backgroundColor: Colors.white,
				version: 1,
			  ),
			  SizedBox(
				width: 10.0,
			  ),
			  SizedBox(
				height: 30,
				child: Stack(
				  children: <Widget>[
					Align(
					  alignment: Alignment.topLeft,
					  child: Text("TxQr Messaging"),
					),
					Align(
						alignment: Alignment.bottomLeft,
						child: Text(
						  "Written by Max Paulson & Finian Blackett",
						  style: TextStyle(
							  fontSize: 11.0, fontWeight: FontWeight.w200),
						)),
				  ],
				),
			  ),

			  SizedBox(
				width: 20,
			  ),
			  // IconButton(
			  //   icon: Icon(Icons.share),
			  //   color: Colors.blueGrey[600],
			  //   tooltip: 'Share',
			  //   onPressed: () {
			  //     Share.share(result);
			  //   },
			  // ),
			  // IconButton(
			  //   icon: Icon(Icons.file_upload),
			  //   color: Colors.green[300],
			  //   tooltip: 'test',
			  //   onPressed: () {
			  //     _showModalBottomSheet(context);
			  //     //_getMessage("oza");
			  //   },
			  // ),
			],
		  ),
		),
	  );

  Widget txBody() => SliverList(
		delegate: SliverChildListDelegate([
		  SizedBox(
			width: 380,
			child: Column(
			  children: <Widget>[
				SizedBox(
				  height: 20,
				  child: Text(this.path),
				),
				SizedBox(
				  width: double.infinity,
				  child: Center(
					child: Card(
					  child: Padding(
						padding: const EdgeInsets.all(30.0),
						child: Text(
						  result,
						  style: new TextStyle(
							  fontSize: 11.0, fontWeight: FontWeight.w600),
						),
					  ),
					),
				  ),
				),
				SizedBox(
				  height: 20,
				),
				SizedBox(
				  height: 50,
				  child: Text(_message),
				),
			  ],
			),
		  )
		]),
	  );

  Widget txSliverList() => CustomScrollView(
		slivers: <Widget>[
		  txAppBar(),
		  txBody(),
		],
	  );

  // Widget txDefaultAppBar() => AppBar(
  //       title: Text("QR Scanner"),
  //       actions: <Widget>[
  //         IconButton(
  //           icon: Icon(Icons.share),
  //           tooltip: 'Search',
  //           onPressed: () {
  //             Share.share(result);
  //           },
  //         ),
  //       ],
  //     );

  @override
  Widget build(BuildContext context) {
	return Scaffold(
	  body: txSliverList(),
	  bottomNavigationBar: BottomAppBar(
		shape: CircularNotchedRectangle(),
		notchMargin: 4,
		child: Container(
		  height: 50.0,
		),
	  ),
	  floatingActionButton: Builder(builder: (BuildContext myContext) {
		return FloatingActionButton.extended(
			icon: Icon(Icons.adb),
			backgroundColor: Colors.blueGrey[900],
			label: Text("Go"),
			onPressed: () async {
			  //_scanQR(myContext);
			  //_scan();
			  _showModalBottomSheet(context);
			});
	  }),
	  floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
	);
  }
}

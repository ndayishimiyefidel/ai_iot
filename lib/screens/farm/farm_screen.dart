import '../../style.dart';
import 'package:flutter/material.dart';

class FarmScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Farm'),
      ),
      body: Container(
        child: Text('fam screen'),
      ),
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        notchMargin: 5.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.dashboard),
              onPressed: () {
                Navigator.pushNamed(context, '/dashboard');
              },
            ),
            IconButton(
              icon: Icon(Icons.cloud),
              onPressed: () {
                Navigator.pushNamed(context, '/weather');
              },
            ),
            IconButton(
              icon: Icon(Icons.agriculture),
              onPressed: () {
                Navigator.pushNamed(context, '/farm');
              },
            ),
            IconButton(
              icon: Icon(Icons.camera_alt),
              onPressed: () {
                Navigator.pushNamed(context, '/camera');
              },
            ),
            IconButton(
              icon: Icon(Icons.account_circle),
              onPressed: () {
                Navigator.pushNamed(context, '/my_account');
              },
            ),
          ],
        ),
      ),
    );
  }

  // Widget _buildPieChart() {
  //   var data = [
  //     Task('Task A', 35.8, Colors.blue),
  //     Task('Task B', 20.3, Colors.red),
  //     Task('Task C', 10.1, Colors.green),
  //     Task('Task D', 18.6, Colors.orange),
  //     Task('Task E', 15.2, Colors.purple),
  //   ];

  // var series = [
  //   charts.Series(
  //     id: 'Tasks',
  //     data: data,
  //     domainFn: (Task task, _) => task.name,
  //     measureFn: (Task task, _) => task.percent,
  //     colorFn: (Task task, _) => charts.ColorUtil.fromDartColor(task.color),
  //   ),
  // ];

  // return Container(
  //   height: 300,
  //   padding: EdgeInsets.all(16),
  //   child: charts.PieChart(
  //     series,
  //     animate: true,
  //   ),
  // );
}

// Widget _buildBarChart() {
//   var data = [
//     Production('Spring', 50),
//     Production('Summer', 80),
//     Production('Autumn', 70),
//     Production('Winter', 60),
//   ];

// var series = [
//   charts.Series(
//     id: 'Production',
//     data: data,
//     domainFn: (Production production, _) => production.season,
//     measureFn: (Production production, _) => production.production,
//     colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
//   ),
// ];

// return Container(
//   height: 300,
//   padding: EdgeInsets.all(16),
//   child: charts.BarChart(
//     series,
//     animate: true,
//   ),
// );
//}
//}

class Task {
  final String name;
  final double percent;
  final Color color;

  Task(this.name, this.percent, this.color);
}

class Production {
  final String season;
  final int production;

  Production(this.season, this.production);
}

class TopNav extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppStyles.topNavBackgroundColor,
      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 7.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 25,
                backgroundImage: NetworkImage(
                  'assets/profile.jpg', // Replace with user's profile image URL
                ),
              ),
              SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Welcome back',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 14.0,
                    ),
                  ),
                  Text(
                    'Mihigo Prince', // Replace with dynamic user name
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Row(
            children: [
              Icon(Icons.notifications, color: Colors.black),
              SizedBox(width: 20), // Adjust the width as needed
              Icon(Icons.more_vert, color: Colors.black),
            ],
          ),
        ],
      ),
    );
  }
}

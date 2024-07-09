import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FarmScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Farm'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Rice Growth, Pest Chances, and Diseases',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              height: 300,
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: PieChartWidget(),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  LegendItem(color: Colors.green, text: 'Rice Growth'),
                  LegendItem(color: Colors.orange, text: 'Pest Chance'),
                  LegendItem(color: Colors.red, text: 'Diseases'),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Rice Growth and Disease Rates Over Time',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              height: 300,
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: BarChartWidget(),
            ),
          ],
        ),
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
}

class PieChartWidget extends StatelessWidget {
  Future<Map<String, double>> fetchData() async {
    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('analytics')
          .doc('riceData')
          .get();

      if (snapshot.exists && snapshot.data() != null) {
        var data = snapshot.data() as Map<String, dynamic>;
        return {
          "growth": data['growth'] ?? 0.0,
          "pest": data['pest'] ?? 0.0,
          "diseases": data['diseases'] ?? 0.0,
        };
      }
    } catch (e) {
      print("Error fetching data: $e");
    }
    return {"growth": 0.0, "pest": 0.0, "diseases": 0.0};
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, double>>(
      future: fetchData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text("Error fetching data"));
        } else {
          final data = snapshot.data!;
          return PieChart(
            PieChartData(
              sections: [
                PieChartSectionData(
                  color: Colors.green,
                  value: data["growth"],
                  title: '${data["growth"]}%',
                  radius: 100,
                  titleStyle: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                PieChartSectionData(
                  color: Colors.orange,
                  value: data["pest"],
                  title: '${data["pest"]}%',
                  radius: 100,
                  titleStyle: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                PieChartSectionData(
                  color: Colors.red,
                  value: data["diseases"],
                  title: '${data["diseases"]}%',
                  radius: 100,
                  titleStyle: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ],
              sectionsSpace: 0,
              centerSpaceRadius: 0,
            ),
          );
        }
      },
    );
  }
}

class LegendItem extends StatelessWidget {
  final Color color;
  final String text;

  LegendItem({required this.color, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          color: color,
        ),
        SizedBox(width: 8),
        Text(
          text,
          style: TextStyle(fontSize: 16),
        ),
      ],
    );
  }
}

class BarChartWidget extends StatelessWidget {
  Future<List<BarChartGroupData>> fetchData() async {
    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('analytics')
          .doc('riceData')
          .get();

      if (snapshot.exists && snapshot.data() != null) {
        var data = snapshot.data() as Map<String, dynamic>;
        return [
          BarChartGroupData(
            x: 1,
            barRods: [
              BarChartRodData(
                  toY: data['day1_growth'] ?? 0.0, color: Colors.green),
              BarChartRodData(
                  toY: data['day1_diseases'] ?? 0.0, color: Colors.red),
            ],
          ),
          BarChartGroupData(
            x: 2,
            barRods: [
              BarChartRodData(
                  toY: data['day2_growth'] ?? 0.0, color: Colors.green),
              BarChartRodData(
                  toY: data['day2_diseases'] ?? 0.0, color: Colors.red),
            ],
          ),
          BarChartGroupData(
            x: 3,
            barRods: [
              BarChartRodData(
                  toY: data['day3_growth'] ?? 0.0, color: Colors.green),
              BarChartRodData(
                  toY: data['day3_diseases'] ?? 0.0, color: Colors.red),
            ],
          ),
          BarChartGroupData(
            x: 4,
            barRods: [
              BarChartRodData(
                  toY: data['day4_growth'] ?? 0.0, color: Colors.green),
              BarChartRodData(
                  toY: data['day4_diseases'] ?? 0.0, color: Colors.red),
            ],
          ),
        ];
      }
    } catch (e) {
      print("Error fetching data: $e");
    }
    return [
      BarChartGroupData(
        x: 1,
        barRods: [
          BarChartRodData(toY: 0.0, color: Colors.green),
          BarChartRodData(toY: 0.0, color: Colors.red),
        ],
      ),
      BarChartGroupData(
        x: 2,
        barRods: [
          BarChartRodData(toY: 0.0, color: Colors.green),
          BarChartRodData(toY: 0.0, color: Colors.red),
        ],
      ),
      BarChartGroupData(
        x: 3,
        barRods: [
          BarChartRodData(toY: 0.0, color: Colors.green),
          BarChartRodData(toY: 0.0, color: Colors.red),
        ],
      ),
      BarChartGroupData(
        x: 4,
        barRods: [
          BarChartRodData(toY: 0.0, color: Colors.green),
          BarChartRodData(toY: 0.0, color: Colors.red),
        ],
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<BarChartGroupData>>(
      future: fetchData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text("Error fetching data"));
        } else {
          final barGroups = snapshot.data!;
          return BarChart(
            BarChartData(
              alignment: BarChartAlignment.spaceAround,
              barGroups: barGroups,
              titlesData: FlTitlesData(
                show: true,
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      const style = TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 14);
                      Widget text;
                      switch (value.toInt()) {
                        case 1:
                          text = const Text('Day 1', style: style);
                          break;
                        case 2:
                          text = const Text('Day 2', style: style);
                          break;
                        case 3:
                          text = const Text('Day 3', style: style);
                          break;
                        case 4:
                          text = const Text('Day 4', style: style);
                          break;
                        default:
                          text = const Text('', style: style);
                          break;
                      }
                      return SideTitleWidget(
                          child: text, axisSide: meta.axisSide);
                    },
                    reservedSize: 28,
                  ),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      const style = TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 14);
                      Widget text;
                      if (value == 0) {
                        text = const Text('0%', style: style);
                      } else if (value == 50) {
                        text = const Text('50%', style: style);
                      } else if (value == 70) {
                        text = const Text('70%', style: style);
                      } else {
                        text = const Text('', style: style);
                      }
                      return SideTitleWidget(
                          child: text, axisSide: meta.axisSide);
                    },
                    reservedSize: 28,
                    interval: 20,
                  ),
                ),
              ),
              borderData: FlBorderData(
                show: false,
              ),
              barTouchData: BarTouchData(
                touchTooltipData: BarTouchTooltipData(
                    // tooltipBgColor: Colors.blueGrey,
                    ),
              ),
            ),
          );
        }
      },
    );
  }
}

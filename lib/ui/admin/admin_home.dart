import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import 'package:dacn2/data/models/admin/admin_dashboard.dart';
import 'package:dacn2/data/services/admin/admin_dashboard.dart';
import 'package:dacn2/data/util/Util.dart';
import 'package:dacn2/ui/admin/custom/slidemenu.dart';

class AdminHome extends StatefulWidget {
  @override
  _AdminHomeState createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  final AdminDashboardService adminDashboardService = AdminDashboardService(
    baseUrl: Util.baseUrl,
  );
  late AdminDashboard adminDashboard;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchAdminDashboard();
  }

  Future<void> _fetchAdminDashboard() async {
    try {
      final data = await adminDashboardService.getAdminDashboard();
      setState(() {
        adminDashboard = data;
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching admin dashboard: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Trang Chủ Admin'),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.white,
                const Color.fromARGB(255, 149, 223, 255),
                Colors.lightBlueAccent.shade400,
              ],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
            ),
          ),
        ),
      ),
      drawer:  SlideMenu(),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : _buildDashboard(adminDashboard),
    );
  }

  Widget _buildDashboard(AdminDashboard adminDashboard) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          const Text(
            'Thống Kê Tổng Quan',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: PageView(
              children: [
                _buildPieChart(),
                _buildBarChart(),
                _buildLineChart(),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              childAspectRatio: 3 / 2,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              children: [
                _buildStatCard(
                    'Người dùng', adminDashboard.userCount, Colors.blue),
                _buildStatCard(
                    'Công ty', adminDashboard.companyCount, Colors.green),
                _buildStatCard(
                    'Bài viết', adminDashboard.blogCount, Colors.orange),
                _buildStatCard(
                    'Công việc', adminDashboard.jobCount, Colors.purple),
                _buildStatCard(
                    'Ứng viên', adminDashboard.applicantCount, Colors.red),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPieChart() {
    return SfCircularChart(
      title: ChartTitle(text: 'Biểu đồ Tỷ lệ'),
      legend: Legend(isVisible: true),
      series: <CircularSeries>[
        PieSeries<StatisticData, String>(
          dataSource: _getStatistics(),
          xValueMapper: (StatisticData data, _) => data.label,
          yValueMapper: (StatisticData data, _) => data.value,
          dataLabelSettings: const DataLabelSettings(isVisible: true),
        ),
      ],
    );
  }

  Widget _buildBarChart() {
    return SfCartesianChart(
      title: ChartTitle(text: 'Biểu đồ Cột'),
      primaryXAxis: CategoryAxis(),
      series: <ChartSeries>[
        ColumnSeries<StatisticData, String>(
          dataSource: _getStatistics(),
          xValueMapper: (StatisticData data, _) => data.label,
          yValueMapper: (StatisticData data, _) => data.value,
          dataLabelSettings: const DataLabelSettings(isVisible: true),
          color: Colors.lightBlue,
        ),
      ],
    );
  }

  Widget _buildLineChart() {
    return SfCartesianChart(
      title: ChartTitle(text: 'Biểu đồ Đường'),
      primaryXAxis: CategoryAxis(),
      series: <ChartSeries>[
        LineSeries<StatisticData, String>(
          dataSource: _getStatistics(),
          xValueMapper: (StatisticData data, _) => data.label,
          yValueMapper: (StatisticData data, _) => data.value,
          dataLabelSettings: const DataLabelSettings(isVisible: true),
          color: Colors.orangeAccent,
        ),
      ],
    );
  }

  Widget _buildStatCard(String title, int count, Color color) {
    return Card(
      elevation: 4,
      color: color.withOpacity(0.7),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
            const SizedBox(height: 10),
            Text(
              count.toString(),
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  List<StatisticData> _getStatistics() {
    return [
      StatisticData('Người dùng', adminDashboard.userCount),
      StatisticData('Công ty', adminDashboard.companyCount),
      StatisticData('Bài viết', adminDashboard.blogCount),
      StatisticData('Công việc', adminDashboard.jobCount),
      StatisticData('Ứng viên', adminDashboard.applicantCount),
    ];
  }
}

class StatisticData {
  final String label;
  final int value;

  StatisticData(this.label, this.value);
}

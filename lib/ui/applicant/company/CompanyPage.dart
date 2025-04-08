import 'package:dacn2/data/util/Util.dart';
import 'package:flutter/material.dart';
import 'package:dacn2/ui/applicant/nav/Bottomnav.dart';
import 'package:dacn2/ui/applicant/search/Search.dart';
import 'package:dacn2/ui/applicant/appbar/AppBar.dart';
import 'package:dacn2/ui/applicant/company/CompanyCart.dart';
import 'package:dacn2/data/models/company.dart';
import 'package:dacn2/data/services/company_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CompanyPage extends StatefulWidget {
  @override
  _CompanyPageState createState() => _CompanyPageState();
}

class _CompanyPageState extends State<CompanyPage> {
  late Future<List<Company>> futureCompanies;
  final CompanyService companyService = CompanyService(baseUrl: Util.baseUrl);

  List<Company> filteredCompany = [];
  String searchQuery = '';
  @override
  void initState() {
    super.initState();
    futureCompanies = Future.error('Loading ...'); // Set initial value to error
    _loadCompanies();
  }

  void updateSearchQuery(String query) {
    setState(() {
      searchQuery = query;
      futureCompanies.then((companies) {
        setState(() {
          filteredCompany = companies.where((company) {
            return company.companyName
                    .toLowerCase()
                    .contains(query.toLowerCase()) ||
                company.companyCategory
                    .toLowerCase()
                    .contains(query.toLowerCase());
          }).toList();
        });
      });
    });
  }

  Future<void> _loadCompanies() async {
    final prefs = await SharedPreferences.getInstance();
    final userIdFromPrefs = prefs.getInt('userId');
    if (userIdFromPrefs != null) {
      setState(() {
        futureCompanies = companyService.getAllCompanies();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.white, // Màu nhạt ở trên
                const Color.fromARGB(
                    255, 149, 223, 255), // Màu nhạt hơn một chút ở giữa
                Colors.lightBlueAccent.shade400, // Màu đậm hơn ở dưới
              ],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
            ),
          ),
        ),
      ),
      body: FutureBuilder<List<Company>>(
        future: futureCompanies,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Lỗi: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Không có công ty nào'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return CompanyCart(
                  company: snapshot.data![index],
                );
              },
            );
          }
        },
      ),
    );
  }
}

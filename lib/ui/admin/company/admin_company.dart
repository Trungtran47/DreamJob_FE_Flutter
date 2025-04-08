import 'package:dacn2/data/util/Util.dart';
import 'package:dacn2/ui/admin/company/admin_company_detail.dart';
import 'package:dacn2/ui/admin/custom/slidemenu.dart';
import 'package:flutter/material.dart';
import 'package:dacn2/data/models/company.dart'; // Model Company
import 'package:dacn2/data/services/company_service.dart'; // Service để lấy danh sách Company

class AdminCompanyPage extends StatefulWidget {
  @override
  _AdminCompanyPageState createState() => _AdminCompanyPageState();
}

class _AdminCompanyPageState extends State<AdminCompanyPage> {
  final CompanyService _companyService = CompanyService(baseUrl: Util.baseUrl);
  late List<Company> _companies = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchCompanies();
  }

  // Lấy danh sách công ty
  Future<void> _fetchCompanies() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final companies = await _companyService.getAllCompanies();
      setState(() {
        _companies = companies;
        _isLoading = false;
      });
    } catch (e) {
      print('Error fetching companies: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  // // Xóa công ty
  // Future<void> _deleteCompany(int id) async {
  //   try {
  //     await _companyService.deleteCompany(id);
  //     setState(() {
  //       _companies.removeWhere((company) => company.id == id);
  //     });
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('Đã xóa công ty thành công')),
  //     );
  //   } catch (e) {
  //     print('Error deleting company: $e');
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('Không thể xóa công ty')),
  //     );
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Quản lý Công ty'),
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
      drawer: SlideMenu(),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _fetchCompanies,
              child: ListView.builder(
                itemCount: _companies.length,
                itemBuilder: (context, index) {
                  final company = _companies[index];
                  return Card(
                    margin:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(company.logoUrl ?? ''),
                        child: company.companyLogo == null
                            ? Icon(Icons.business)
                            : null,
                      ),
                      title:
                          Text(company.companyName ?? 'Không có tên công ty'),
                      subtitle:
                          Text(company.companyLocation ?? 'Không có địa chỉ'),
                      // trailing: PopupMenuButton(
                      // onSelected: (value) {
                      //   if (value == 'edit') {
                      //     // Mở trang chỉnh sửa công ty
                      //   } else if (value == 'delete') {
                      //     _deleteCompany(company.id);
                      //   }
                      // },
                      // itemBuilder: (context) => [
                      //   PopupMenuItem(
                      //       value: 'edit', child: Text('Chỉnh sửa')),
                      //   PopupMenuItem(value: 'delete', child: Text('Xóa')),
                      // ],
                      // ),
                      onTap: () {
                        // Điều hướng tới trang chi tiết công ty nếu cần
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CompanyDetaiilPage(
                              company: company,
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
    );
  }
}

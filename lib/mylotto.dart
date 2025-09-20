import 'package:flutter/material.dart';
import 'home.dart';
import 'setting.dart';
import 'model/login_model.dart';

//---------------------------------------แก้ไข---------------------------------------------------
class MyLottoPage extends StatefulWidget {
  final Customer customer;
  const MyLottoPage({super.key, required this.customer});

  @override
  State<MyLottoPage> createState() => _MyLottoPageState();
}

class _MyLottoPageState extends State<MyLottoPage> {
  double myWallet = 0; // สมมุติยอดเงิน
  final Map<String, List<Map<String, dynamic>>> lottoByDate = {
    "1 ส.ค. 2568": [
      {
        "number": "123 456",
        "price": 80,
        "isWinner": false,
        "prize": 0,
        "claimed": false,
      },
      {
        "number": "345 666",
        "price": 80,
        "isWinner": true,
        "prize": 3000000,
        "claimed": false,
      },
      {
        "number": "345 666",
        "price": 80,
        "isWinner": true,
        "prize": 200000,
        "claimed": true,
      },
    ],
    "26 ส.ค. 2568": [
      {
        "number": "745 233",
        "price": 80,
        "isWinner": null,
        "prize": 0,
        "claimed": false,
      },
    ],
  };

  // เพิ่มตัวแปรสำหรับค้นหา
  final TextEditingController _searchController = TextEditingController();
  String _searchText = '';

  // ฟังก์ชันกรองล็อตเตอรี่ตามเลขที่ค้นหา
  Map<String, List<Map<String, dynamic>>> get filteredLottoByDate {
    if (_searchText.isEmpty) return lottoByDate;
    final Map<String, List<Map<String, dynamic>>> filtered = {};
    lottoByDate.forEach((date, tickets) {
      final filteredTickets = tickets.where((lotto) {
        final number = lotto["number"]?.toString() ?? '';
        return number.contains(_searchText);
      }).toList();
      if (filteredTickets.isNotEmpty) {
        filtered[date] = filteredTickets;
      }
    });
    return filtered;
  }
  //---------------------------------------แก้ไข---------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Lotto - ${widget.customer.fullname}'),
        backgroundColor: const Color(0xFF001E46),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'ค้นหาล็อตเตอรี่',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: _searchController.text.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear),
                              //---------------------------------------แก้ไข---------------------------------------------------
                              onPressed: () {
                                setState(() {
                                  _searchController.clear();
                                  _searchText = '';
                                });
                              },
                              //---------------------------------------แก้ไข---------------------------------------------------
                            )
                          : null,
                    ),
                    onChanged: (value) {
                      setState(() {}); // เพื่อให้ suffixIcon อัปเดต
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Flexible(
                  flex: 1,
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _searchText = _searchController.text.trim();
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF001E46),
                      minimumSize: const Size(double.infinity, 48),
                    ),
                    child: const Text(
                      'ค้นหา',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          //---------------------------------------แก้ไข---------------------------------------------------
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                const Text('My Wallet:', style: TextStyle(fontSize: 16)),
                const SizedBox(width: 8),
                Text(
                  '฿${myWallet.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              children: filteredLottoByDate.entries.expand((entry) {
                final date = entry.key;
                final tickets = entry.value;
                return tickets.map((lotto) {
                  final number = lotto["number"];
                  final price = lotto["price"];
                  final isWinner = lotto["isWinner"];
                  final prize = lotto["prize"];
                  final claimed = lotto["claimed"];
                  final isResultAnnounced = isWinner != null;
                  return Card(
                    margin: const EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 16,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'งวดวันที่ $date',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 8),
                          Text('ฉลากกินเเบ่ง', style: TextStyle(fontSize: 14)),
                          if (isResultAnnounced)
                            isWinner
                                ? Text(
                                    'ถูกรางวัลที่ 1',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.green,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )
                                : Text(
                                    'ไม่ถูกรางวัล',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.red,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )
                          else
                            Text(
                              'รอผลรางวัล',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.orange,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          Text(
                            number ?? '',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'ราคา: ฿$price',
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black54,
                            ),
                          ),
                          if (isResultAnnounced && isWinner)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${prize.toString().replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (m) => '${m[1]},')}',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                claimed
                                    ? ElevatedButton(
                                        onPressed: null,
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.grey,
                                        ),
                                        child: const Text('ได้รับแล้ว'),
                                      )
                                    : ElevatedButton(
                                        onPressed: () {
                                          setState(() {
                                            lotto["claimed"] = true;
                                            myWallet += prize;
                                          });
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                'ขึ้นเงินรางวัลเรียบร้อย!',
                                              ),
                                            ),
                                          );
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.green,
                                        ),
                                        child: const Text(
                                          'ขึ้นเงินรางวัล',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                              ],
                            ),
                        ],
                      ),
                    ),
                  );
                });
              }).toList(),
            ),
          ),
          //---------------------------------------แก้ไข---------------------------------------------------
          _footer(context),
        ],
      ),
    );
  }

  Widget _footer(BuildContext context) {
    return Container(
      height: 70,
      color: const Color(0xFFF1F7F8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          InkWell(
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => HomePage(customer: widget.customer),
                ),
              );
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.home, color: Colors.grey),
                SizedBox(height: 4),
                Text(
                  'Home',
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
          ),
          InkWell(
            onTap: () {},
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.confirmation_number, color: Colors.blue),
                SizedBox(height: 4),
                Text(
                  'MyLotto',
                  style: TextStyle(color: Colors.blue, fontSize: 12),
                ),
              ],
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => SettingPage(customer: widget.customer),
                ),
              );
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.person, color: Colors.grey),
                SizedBox(height: 4),
                Text(
                  'Setting',
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// mock backend สำหรับตรวจผลลอตเตอรี่
import '../model/lotto_ticket.dart';
import 'package:http/http.dart' as http; // สำหรับ http.get
import 'dart:convert'; // สำหรับ jsonDecode
import '../config.dart'; // สำหรับ AppConfig

class LottoService {
  // สมมุติรางวัลที่ออก (จริงๆ ฝั่งสุ่มออกรางวัลของเพื่อนต้องส่งเข้ามา)
  final String winningNumber = "123456";

  // ฟังก์ชันตรวจผล
  LottoTicket checkResult(LottoTicket ticket) {
    ticket.isChecked = true; // อัปเดตว่าสลากนี้ตรวจแล้ว

    if (ticket.number == winningNumber) {
      ticket.isWinner = true;
      ticket.prize = 6000000; // สมมุติรางวัลที่ 1 = 6 ล้าน
    } else {
      ticket.isWinner = false;
      ticket.prize = 0;
    }

    return ticket;
  }

  // ฟังก์ชันขึ้นเงินรางวัล
  LottoTicket claimPrize(LottoTicket ticket) {
    if (ticket.isWinner && !ticket.isClaimed) {
      ticket.isClaimed = true; // อัปเดตว่าได้รับเงินแล้ว
    }
    return ticket;
  }

  Future<List<LottoTicket>> fetchMyLotto(String customerId) async {
    final response = await http.get(
      Uri.parse('${AppConfig.apiEndpoint}/my-lotto?customer_id=$customerId'),
    );
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((e) => LottoTicket.fromJson(e)).toList();
    }
    return [];
  }
}

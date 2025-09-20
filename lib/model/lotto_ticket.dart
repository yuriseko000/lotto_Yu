// class สำหรับเก็บข้อมูลลอตเตอรี่ที่ผู้ใช้ซื้อ
class LottoTicket {
  final String number; // เลขที่ซื้อ
  final int price; // ราคาลอตเตอรี่
  bool isChecked; // ตรวจผลแล้วหรือยัง
  bool isWinner; // ถูกรางวัลไหม
  int prize; // จำนวนเงินรางวัล
  bool isClaimed; // ขึ้นเงินรางวัลแล้วหรือยัง
  String drawDate; // งวดวันที่

  LottoTicket({
    required this.number,
    required this.price,
    this.isChecked = false, // ยังไม่ตรวจผล
    this.isWinner = false,
    this.prize = 0,
    this.isClaimed = false,
    required this.drawDate,
  });

  // ฟังก์ชันแปลงจาก JSON (เวลารับจาก backend)
  factory LottoTicket.fromJson(Map<String, dynamic> json) {
    return LottoTicket(
      number: json['number'],
      price: json['price'] ?? 80, // ถ้าไม่มีข้อมูลให้ default 80 บาท
      isChecked: json['isChecked'] ?? false,
      isWinner: json['isWinner'] ?? false,
      prize: json['prize'] ?? 0,
      isClaimed: json['isClaimed'] ?? false,
      drawDate: json['drawDate'] ?? "",
    );
  }

  // ฟังก์ชันแปลงเป็น JSON (เวลาส่งกลับไป backend)
  Map<String, dynamic> toJson() {
    return {
      'number': number,
      'price': price,
      'isChecked': isChecked,
      'isWinner': isWinner,
      'prize': prize,
      'isClaimed': isClaimed,
      'drawDate': drawDate,
    };
  }
}

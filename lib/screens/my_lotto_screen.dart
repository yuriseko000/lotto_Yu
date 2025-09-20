import 'package:flutter/material.dart';
import '../model/lotto_ticket.dart';
import '../services/lotto_service.dart';

class MyLottoScreen extends StatefulWidget {
  final List<LottoTicket> tickets; // รับลอตเตอรี่ที่ซื้อมา

  const MyLottoScreen({super.key, required this.tickets});

  @override
  State<MyLottoScreen> createState() => _MyLottoScreenState();
}

class _MyLottoScreenState extends State<MyLottoScreen> {
  final LottoService lottoService = LottoService();

  void _checkResults() {
    setState(() {
      for (int i = 0; i < widget.tickets.length; i++) {
        widget.tickets[i] = lottoService.checkResult(widget.tickets[i]);
      }
    });
  }

  void _claimPrize(LottoTicket ticket) {
    setState(() {
      lottoService.claimPrize(ticket);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("ลอตเตอรี่ของฉัน")),
      body: Column(
        children: [
          ElevatedButton(onPressed: _checkResults, child: const Text("ตรวจผล")),
          Expanded(
            child: ListView.builder(
              itemCount: widget.tickets.length,
              itemBuilder: (context, index) {
                final ticket = widget.tickets[index];
                return Card(
                  margin: const EdgeInsets.all(8),
                  child: ListTile(
                    title: Text(
                      "เลข: ${ticket.number}",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("งวดวันที่: ${ticket.drawDate}"),
                        Text("ราคา: ฿${ticket.price}"),
                        if (!ticket.isChecked)
                          const Text(
                            "รอผลรางวัล",
                            style: TextStyle(color: Colors.orange),
                          ),
                        if (ticket.isChecked &&
                            ticket.isWinner &&
                            !ticket.isClaimed)
                          Text(
                            "ถูกรางวัล: ฿${ticket.prize}",
                            style: const TextStyle(color: Colors.green),
                          ),
                        if (ticket.isChecked && !ticket.isWinner)
                          const Text(
                            "ไม่ถูกรางวัล",
                            style: TextStyle(color: Colors.red),
                          ),
                        if (ticket.isClaimed)
                          const Text(
                            "ได้รับแล้ว",
                            style: TextStyle(color: Colors.grey),
                          ),
                      ],
                    ),
                    trailing: ticket.isWinner && !ticket.isClaimed
                        ? ElevatedButton(
                            onPressed: () => _claimPrize(ticket),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                            ),
                            child: const Text("ขึ้นเงินรางวัล"),
                          )
                        : null,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_doc_scanner/flutter_doc_scanner.dart';
import 'package:qr_code_scanner_plus/qr_code_scanner_plus.dart';
import 'package:scanner_application/pages/result_page.dart';


class ScannerHomePage extends StatefulWidget {
  const ScannerHomePage({super.key});

  @override
  State<ScannerHomePage> createState() => _ScannerHomePageState();
}

class _ScannerHomePageState extends State<ScannerHomePage> {

  int _selectedIndex = 0; // 0 For QR & 1 For Document
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR'); // QR view ke Uniquely identify korar Jonno
  QRViewController? qrViewController;
  String? documentPath;
  bool _isNavigating = false;



  @override
  void dispose() {
    qrViewController?.disposed;
    super.dispose();
  }


  /// >>> ============ QR Scanner Start Here ============
  Widget _buildQrView(BuildContext context){
    return QRView(
        key: qrKey,
        onQRViewCreated: _onQRViewCreated,
        overlay: QrScannerOverlayShape(borderColor: Colors.white,borderRadius: 10,borderLength: 30,borderWidth: 5,cutOutSize: 250),
    );
  }
  void _onQRViewCreated(QRViewController controller){
    qrViewController = controller;
    controller.scannedDataStream.listen((scanData) async {
      if (_isNavigating) return; // already navigating, ignore

      final result = scanData.code;
      if (result != null && !_isNavigating) {
        _isNavigating = true; // set flag
        await qrViewController?.pauseCamera();  // pause camera

        // navigate after frame render
        if (!mounted) return;
        await Navigator.push(context, MaterialPageRoute(builder: (_) => ResultPage(qrResult: result)),);

        // resume camera after coming back
        await qrViewController?.resumeCamera();
        _isNavigating = false;// reset flag
      }
    });
  }
  /// <<< ============ QR Scanner End Here ==============



  /// >>> ========= Document Scanner Start Here ============
  Future<void> _scanDocument() async {
    if (_isNavigating) return;

    _isNavigating = true;
    try {
      final result = await FlutterDocScanner().getScannedDocumentAsPdf(page: 4);
      if (result != null && mounted) {
        await Navigator.push(context, MaterialPageRoute(builder: (_) => ResultPage(qrResult: result.toString())),);
      }
    } catch (e) {
      debugPrint("Error scanning: $e");
    } finally {
      _isNavigating = false;
    }
  }
  /// <<< ========= Document Scanner End Here ==============





  @override
  Widget build(BuildContext context) {


    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        alignment: Alignment.center,
        children: [
          
          /// >>> Camera View QR/Document
          Positioned.fill(
              child: _selectedIndex == 0 ? _buildQrView(context) : const Center(child: Text("Document Scanner Ready\nClick Again", style: TextStyle(color: Colors.white),textAlign: TextAlign.center,),)
          ),

          
          /// >>> Bottom Navigation Tab
          Positioned(
              bottom: 60,
              child: Row(
                children: [
                  _buildBottomTab("QR Code", 0, Icons.qr_code),
                    const SizedBox(width: 40),
                  _buildBottomTab("Document", 1, Icons.description),
                ],
              )
          ),


        ],
      ),
    );
  }
  
  
  
  
  
  /// >>> ================== Bottom Tab QR & Document Icon and Text Start Here =================
  Widget _buildBottomTab(String text, int index, IconData icon){
    final isSelected = _selectedIndex == index;
    return GestureDetector(
      onTap: (){
        setState(() {_selectedIndex = index;});
        if(index == 1){_scanDocument();}
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: isSelected ? Colors.blue : Colors.white70),
          SizedBox(height: 5,),
          Text(text,style: TextStyle(color: isSelected ? Colors.blue : Colors.white70, fontSize: 14,),),
        ],
      ),
    );
  }
  /// <<< ================== Bottom Tab QR & Document Icon and Text End Here ===================
  
}

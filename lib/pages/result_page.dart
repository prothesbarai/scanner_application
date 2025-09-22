import 'package:flutter/material.dart';
import 'package:scanner_application/widgets/custom_appbar.dart';
import 'package:url_launcher/url_launcher.dart';

class ResultPage extends StatelessWidget {
  final String result;
  const ResultPage({super.key, required this.result});



  /// >>> If Scan And Get Any Web Url Then Call This Function
  void _launchURL(String url) async{
    final uri = Uri.parse(url.startsWith('http') ? url : 'https://$url');
    if(await canLaunchUrl(uri)){
      await launchUrl(uri,mode: LaunchMode.externalApplication);
    }
  }


  /// >>>  ============= Now vCard Parse ======================
  Map<String, dynamic> _parseVcard(String data){
    final lines = data.split(RegExp(r'\r?\n')).map((e)=>e.trim()).where((e)=>e.isNotEmpty).toList();
    String? name,address;
    List<String> phones = [];
    List<String> emails = [];
    List<String> urls = [];
    for(var line in lines){
      if(line.startsWith('N:')){
        final parts = line.substring(2).split(';'); // N: ignore and Format Last;First;Middle   name alada kora
        final first =parts.length > 1 ? parts[1] : '';
        final last = parts.length > 1 ? parts[0] : '';
        name = [first , last].where((x)=> x.isNotEmpty).join(' ');
      }else if(line.startsWith('EMAIL')){
        emails.add(line.split(':').last.trim()); // Email : developer@gmailcom  ... only> developer@gmailcom
      }else if(line.startsWith('URL')){
        urls.add(line.split(':').last.trim());
      }else if(line.startsWith('TEL')){
        final tel = line.split(':').last.replaceAll('\\,', ',');  // TEL:01317818826\, 01521229494 >> replaceAll('\\,', ',')
        phones = tel.split(',').map((x)=>x.trim()).toList();
      }else if(line.startsWith('ADR')){
        final adr = line.split(':').last.replaceAll('\\,', ',');
        address = adr.split(';').where((x) => x.isNotEmpty).join(', ');
      }
    }

    return{'name': name, 'emails': emails, 'phones': phones, 'urls': urls, 'address': address,};
  }


  @override
  Widget build(BuildContext context) {
    final data = result.trim();
    Widget content;
    if(data.startsWith('BEGIN:VCARD')){ // For Only User Details
      final parsed = _parseVcard(data);
      content = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if(parsed['name'] != null)
            ListTile(leading: const Icon(Icons.person),title: Text(parsed['name']),),
          for(var p in parsed['phones'])
            ListTile(leading: const Icon(Icons.phone,color: Colors.green,),title: Text(p),onTap: ()=> launchUrl(Uri.parse('tel:$p')),),
          for(var e in parsed['emails'])
            ListTile(leading: const Icon(Icons.email,color: Colors.red,),title: Text(e),onTap: () => launchUrl(Uri.parse('mailto:$e')),),
          for (var url in parsed['urls'])
            ListTile(leading: const Icon(Icons.language,color: Colors.blue,),title: Text(url),onTap: () => _launchURL(url),),
          if (parsed['address'] != null)
            ListTile(leading: const Icon(Icons.location_on,color: Colors.purple),title: Text(parsed['address']),),
        ],
      );
    }else if(data.startsWith('http')){  // For Only Url
      content = ListTile(leading: const Icon(Icons.link, color: Colors.blue), title: Text(data), onTap: () => _launchURL(data),);
    }else if (RegExp(r'^\d+$').hasMatch(data)) {  // For Only Bar code
      content = ListTile(leading: const Icon(Icons.qr_code,color: Colors.purple,size: 30),title: Text('Barcode: $data', style: const TextStyle(fontSize: 18),),);
    }else {
      content = Text(data, style: const TextStyle(fontSize: 18),);
    }


    return Scaffold(
      appBar: CustomAppbar(appBarTitle: "Scan Result"),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(child: content),
      ),
    );
  }
}

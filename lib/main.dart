
import 'package:flutter/material.dart';
class Urun {
  final String ad;
  final String fiyat;
  final String aciklama;
  final IconData ikon;

  Urun({
    required this.ad,
    required this.fiyat,
    required this.aciklama,
    required this.ikon,
  });

  factory Urun.fromJson(Map<String, dynamic> json) {
    return Urun(
      ad: json['ad'],
      fiyat: json['fiyat'],
      aciklama: json['aciklama'],
      ikon: json['ikon'] is IconData
    ? json['ikon'] as IconData
    : Icons.shopping_bag,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ad': ad,
      'fiyat': fiyat,
      'aciklama': aciklama,
    };
  }
}
void main() {
  final ornekJson = {
    'ad': 'Kulaklık',
    'fiyat': '1299 TL',
    'aciklama': 'Kablosuz kulaklık',
  };

  final ornekUrun = Urun.fromJson(ornekJson);

  print('JSON ürün adı: ${ornekUrun.ad}');
  print('JSON çıktısı: ${ornekUrun.toJson()}');

  runApp(const MiniKatalogApp());
}

class MiniKatalogApp extends StatelessWidget {
  const MiniKatalogApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mini Katalog',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
        ),
        useMaterial3: true,
      ),
      home: const AnaSayfa(),
    );
  }
}

class AnaSayfa extends StatefulWidget {
  const AnaSayfa({super.key});

  @override
  State<AnaSayfa> createState() => _AnaSayfaState();
}

class _AnaSayfaState extends State<AnaSayfa> {
  String aramaMetni = '';
int sepetSayisi = 0;
  @override
  Widget build(BuildContext context) {
    final urunler = [
      {
        'ad': 'Kulaklık',
        'fiyat': '1299 TL',
        'ikon': Icons.headphones,
        'aciklama': 'Yüksek ses kalitesine sahip kablosuz kulaklık.',
      },
      {
        'ad': 'Akıllı Saat',
        'fiyat': '2499 TL',
        'ikon': Icons.watch,
        'aciklama': 'Günlük aktivitelerinizi takip eden akıllı saat.',
      },
      {
        'ad': 'Telefon',
        'fiyat': '15999 TL',
        'ikon': Icons.smartphone,
        'aciklama': 'Güçlü işlemciye sahip modern akıllı telefon.',
      },
      {
        'ad': 'Laptop',
        'fiyat': '28999 TL',
        'ikon': Icons.laptop,
        'aciklama': 'İş ve eğitim için yüksek performanslı laptop.',
      },
      {
        'ad': 'Kamera',
        'fiyat': '8999 TL',
        'ikon': Icons.camera_alt,
        'aciklama': 'Yüksek çözünürlüklü fotoğraf ve video kamerası.',
      },
      {
        'ad': 'Hoparlör',
        'fiyat': '1799 TL',
        'ikon': Icons.speaker,
        'aciklama': 'Güçlü ses çıkışına sahip taşınabilir hoparlör.',
      },
    ];final modelUrunler = urunler
    .map((urun) => Urun.fromJson(urun))
    .toList();

final modeldenGelenUrunler = modelUrunler
    .map((urun) => {
          'ad': urun.ad,
          'fiyat': urun.fiyat,
          'aciklama': urun.aciklama,
          'ikon': urun.ikon,
        })
    .toList();
        final filtrelenmisUrunler = modeldenGelenUrunler.where((urun) {
      final ad = (urun['ad'] as String).toLowerCase();
      return ad.contains(aramaMetni.toLowerCase());
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mini Katalog'),
        centerTitle: true,
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.shopping_cart),
                  const SizedBox(width: 6),
                  Text(
                    '$sepetSayisi',
                    style: const TextStyle(fontSize: 18),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Ürünlerimiz',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

TextField(
  onChanged: (deger) {
    setState(() {
      aramaMetni = deger;
    });
  },
  decoration: InputDecoration(
    hintText: 'Ürün ara...',
    prefixIcon: const Icon(Icons.search),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
    ),
  ),
),

const SizedBox(height: 16),

Expanded(
  child: GridView.builder(
                itemCount: filtrelenmisUrunler.length,
                gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.9,
                ),
                itemBuilder: (context, index) {
                  final urun = filtrelenmisUrunler[index];

                  return Card(
                    elevation: 3,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                               UrunDetaySayfasi(
  urun: urun,
  sepeteEkle: () {
    setState(() {
      sepetSayisi++;
    });
  },
),
                          ),
                        );
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          urun['ad'] == 'Kulaklık'
    ? Image.asset(
        'assets/images/kulaklik.png',
        width: 90,
        height: 90,
        fit: BoxFit.contain,
      )
    : Icon(
        urun['ikon'] as IconData,
        size: 65,
        color: Colors.indigo,
      ),
                          const SizedBox(height: 16),
                          Text(
                            urun['ad'] as String,
                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            urun['fiyat'] as String,
                            style: const TextStyle(
                              fontSize: 15,
                              color: Colors.green,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class UrunDetaySayfasi extends StatefulWidget {
 final Map<String, Object> urun;
  final VoidCallback sepeteEkle;

  const UrunDetaySayfasi({
    super.key,
    required this.urun,
    required this.sepeteEkle,
  });

  @override
  State<UrunDetaySayfasi> createState() => _UrunDetaySayfasiState();
}

class _UrunDetaySayfasiState extends State<UrunDetaySayfasi> {
  bool favoriMi = false;

  @override
  Widget build(BuildContext context) {
    final urun = widget.urun;
    return Scaffold(
      appBar: AppBar(
        title: Text(urun['ad'] as String),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 40),
            urun['ad'] == 'Kulaklık'
    ? Image.asset(
        'assets/images/kulaklik.png',
        width: 180,
        height: 180,
        fit: BoxFit.contain,
      )
    : Icon(
        urun['ikon'] as IconData,
        size: 130,
        color: Colors.indigo,
      ),
                        const SizedBox(height: 20),

            IconButton(
              iconSize: 42,
              onPressed: () {
                setState(() {
                  favoriMi = !favoriMi;
                });
              },
              icon: Icon(
                favoriMi ? Icons.favorite : Icons.favorite_border,
                color: favoriMi ? Colors.red : Colors.grey,
              ),
            ),

            const SizedBox(height: 20),

            Text(
              urun['ad'] as String,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              urun['fiyat'] as String,
              style: const TextStyle(
                fontSize: 24,
                color: Colors.green,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              urun['aciklama'] as String,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Geri Dön'),
            ),
                        const SizedBox(height: 16),

            ElevatedButton.icon(
              onPressed: () {
                widget.sepeteEkle();

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Ürün sepete eklendi!'),
                    duration: Duration(seconds: 2),
                  ),
                );
              },
              icon: const Icon(Icons.shopping_cart),
              label: const Text('Sepete Ekle'),
            ),
          ],
        ),
      ),
    );
  }
}

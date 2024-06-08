import 'package:buga/styles/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

class ShopScreen extends StatefulWidget {
  const ShopScreen({super.key});

  @override
  State<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  static const IconData currencylirarounded =
      IconData(0xf02f7, fontFamily: 'MaterialIcons');

  final InAppPurchase _inAppPurchase = InAppPurchase.instance;
  bool _available = true;
  List<ProductDetails> _products = [];
  List<PurchaseDetails> _purchases = [];

  @override
  void initState() {
    final Stream<List<PurchaseDetails>> purchaseUpdated =
        _inAppPurchase.purchaseStream;
    purchaseUpdated.listen((purchases) {
      _handlePurchaseUpdates(purchases);
    });
    _initialize();
    super.initState();
  }

  Future<void> _initialize() async {
    final bool isAvailable = await _inAppPurchase.isAvailable();
    if (!isAvailable) {
      setState(() {
        _available = false;
      });
      return;
    }

    const Set<String> kIds = <String>{'product_id_1', 'product_id_2'};
    final ProductDetailsResponse response =
        await _inAppPurchase.queryProductDetails(kIds);
    if (response.error != null) {
      // Handle the error.
      setState(() {
        _available = false;
      });
      return;
    }

    if (response.productDetails.isEmpty) {
      // Handle the no products found error.
      setState(() {
        _available = false;
      });
      return;
    }

    setState(() {
      _products = response.productDetails;
    });
  }

  void _handlePurchaseUpdates(List<PurchaseDetails> purchases) {
    // Handle purchase updates here.
    setState(() {
      _purchases = purchases;
    });
  }


  @override
  Widget build(BuildContext context) {
    // final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Stack(children: [
        Hero(
          tag: 'background',
          child: Opacity(
            opacity: 0.8,
            child: Image.asset(
              "assets/images/views/9.jpg",
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              fit: BoxFit.cover,
            ),
          ),
        ),
        Container(
            margin: const EdgeInsets.only(top: 320),
            child:  GridViewWidget(available: _available, products: _products, purchases: _purchases,)),
        Container(
          margin: const EdgeInsets.only(top: 100, left: 10, right: 10),
          height: 200,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 40,
                spreadRadius: 10,
              ),
            ],
          ),
          child: Row(children: [
            const Expanded(
              flex: 2,
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "REKLAMLARI KALDIR",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        fontFamily: "Jost",
                        height: 1,
                        shadows: <Shadow>[
                          Shadow(
                            offset: Offset(0.5, 0.5),
                            blurRadius: 2.0,
                            color: Color.fromARGB(255, 0, 0, 0),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Bu teklifi satın alarak reklamları kalıcı olarak kaldırabilirsiniz!",
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w200,
                          fontFamily: "Jost",
                          wordSpacing: 1.0,
                          height: 1),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Ödül videolarını izlemeye devam edebilirsiniz.",
                      style: TextStyle(
                        height: 1,
                        fontSize: 11,
                        fontWeight: FontWeight.w400,
                        fontFamily: "Jost",
                        shadows: <Shadow>[
                          Shadow(
                            offset: Offset(0.5, 0.5),
                            blurRadius: 2.0,
                            color: Color.fromARGB(255, 0, 0, 0),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    "assets/images/icons/remove-ads.png",
                    width: 100,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30.0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shadowColor: Colors.black,
                        backgroundColor: const Color(0xFF1fb109),
                        elevation: 6.0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                        minimumSize: const Size(30, 40),
                      ),
                      onPressed: () {},
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "99,90",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              fontFamily: "Jost",
                              shadows: <Shadow>[
                                Shadow(
                                  offset: Offset(0.5, 0.5),
                                  blurRadius: 2.0,
                                  color: Color.fromARGB(255, 0, 0, 0),
                                ),
                              ],
                            ),
                          ),
                          Icon(
                            currencylirarounded,
                            size: 20,
                            shadows: <Shadow>[
                              Shadow(
                                offset: Offset(0.5, 0.5),
                                blurRadius: 2.0,
                                color: Color.fromARGB(255, 0, 0, 0),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )
          ]),
        ),
        Positioned(
          top: 30,
          left: 0,
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    iconSize: 50,
                    icon: Container(
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(50)),
                        boxShadow: [
                          BoxShadow(
                            offset: Offset(2.5, 2.5),
                            blurRadius: 2.0,
                            color: Color.fromARGB(255, 62, 62, 62),
                          ),
                        ],
                      ),
                      child: Image.asset(
                        "assets/images/icons/previous.png",
                        width: 50,
                      ),
                    ),
                  ),
                  const Text(
                    "MAĞAZA",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      fontFamily: "Jost",
                      color: Colors.white,
                      shadows: <Shadow>[
                        Shadow(
                          offset: Offset(0.5, 0.5),
                          blurRadius: 2.0,
                          color: Color.fromARGB(255, 0, 0, 0),
                        ),
                      ],
                    ),
                  ),
                  const Center(),
                  const Center()
                ],
              ),
            ),
          ),
        ),
      ]),
    );
  }
}

class GridViewWidget extends StatelessWidget {
  final bool available;
  final List<ProductDetails> products;
  final List<PurchaseDetails> purchases;
  const GridViewWidget({super.key, required this.available, required this.products, required this.purchases});
  static const IconData currencylirarounded =
      IconData(0xf02f7, fontFamily: 'MaterialIcons');
  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    int columnCount = 3;
    int index = -1;
    return AnimationLimiter(
      child: available ? GridView.count(
        physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics()),
        padding: EdgeInsets.all(w / 70),
        crossAxisCount: products.length,
        children: products.map((product) {
          ++index;
          return AnimationConfiguration.staggeredGrid(
              position: index,
              duration: const Duration(milliseconds: 500),
              columnCount: columnCount,
              child: SlideAnimation(
                duration: const Duration(milliseconds: 900),
                curve: Curves.fastLinearToSlowEaseIn,
                child: ScaleAnimation(
                  child: Container(
                    height: 100,
                    margin: EdgeInsets.only(
                        bottom: w / 60, left: w / 80, right: w / 80),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 40,
                          spreadRadius: 10,
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        Image.asset(
                          "assets/images/icons/coins.png",
                          width: 40,
                        ),
                        Text("${product.title} adet",
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              fontFamily: "Jost",
                              shadows: <Shadow>[
                                Shadow(
                                  offset: Offset(0.5, 0.5),
                                  blurRadius: 2.0,
                                  color: Color.fromARGB(255, 0, 0, 0),
                                ),
                              ],
                            )),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shadowColor: Colors.black,
                              backgroundColor: const Color(0xFF1fb109),
                              elevation: 6.0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50),
                              ),
                              minimumSize: const Size(50, 30),
                            ),
                            onPressed: () {},
                            child: Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    product.price,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: "Jost",
                                      shadows: <Shadow>[
                                        Shadow(
                                          offset: Offset(0.5, 0.5),
                                          blurRadius: 2.0,
                                          color: Color.fromARGB(255, 0, 0, 0),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const Icon(
                                    currencylirarounded,
                                    size: 16,
                                    shadows: <Shadow>[
                                      Shadow(
                                        offset: Offset(0.5, 0.5),
                                        blurRadius: 2.0,
                                        color: Color.fromARGB(255, 0, 0, 0),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
        }).toList(),
      ) :  Center(
              child: Text('Store is unavailable'.toUpperCase(), style: profiletitle,),
            ),
    );
  }
}

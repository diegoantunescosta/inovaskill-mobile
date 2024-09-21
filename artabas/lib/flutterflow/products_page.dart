import 'package:flutter/material.dart';
import 'detalhes_smaai.dart'; // Import the details page

class ProductsPage extends StatelessWidget {
  final List<dynamic> products;
  final String tokenAuth;

  const ProductsPage({super.key, required this.products, required this.tokenAuth});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red, // AppBar with the red color
        title: const Text(
          'Aviário ',
          style: TextStyle(color: Colors.white), // Text color in white
        ),
        centerTitle: true, // Center the title
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          final token = product['register']['token']; 
          final city = product['city'];
          final state = city['state'];
          final country = state['country'];
          final mac = product['register']['mac'];

          return Card(
            elevation: 8,
            margin: const EdgeInsets.symmetric(vertical: 10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DashboardPage(
                      token: token,
                      tokenAuth: tokenAuth,
                      mac: mac,
                    ),
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product['description'],
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Text(
                    //   'Modelo: ${product['model']}',
                    //   style: TextStyle(
                    //     fontSize: 16,
                    //     color: Colors.grey[700],
                    //   ),
                    // ),
                    const SizedBox(height: 4),
                    Text(
                      'Cidade: ${city['name']}',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[700],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Estado: ${state['name']} (${state['acronym']})',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[700],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'País: ${country['name']} (${country['acronym']})',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[700],
                      ),
                    ),
                    const SizedBox(height: 10),
                    Align(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red, // Button color in red
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DashboardPage(
                                token: token,
                                tokenAuth: tokenAuth,
                                mac: mac,
                              ),
                            ),
                          );
                        },
                        child: const Text(
                          'Detalhes',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

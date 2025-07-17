import 'dart:io';
class Product{
  String _name;
  String _description;
  double _price;

  Product(this._name, this._description, this._price);
  
  String get name{
    return _name;
  }
  String get description{
    return _description;
  }
  double get price{
    return _price;
  }

  set name(String newName){
    if (newName.isEmpty) throw ArgumentError('Name cannot be empty');
    _name = newName;
  }
  set description(String newDescription){
    if (newDescription.isEmpty) throw ArgumentError('Description cannot be empty');
    _description = newDescription;
  }
  set price(double newPrice){
    if (newPrice < 0) throw ArgumentError('Price cannot be negative');
    _price = newPrice;
  }

  @override
  String toString() {
    return 'Name: $_name\nDescription: $_description\nPrice: ${_price.toStringAsFixed(2)}';
  }
}

class ProductManager{
  final List<Product> _products = [];

  void addProduct(Product product){
    _products.add(product);
    print("Product added succesfully.\n");
  }

  void viewAllProducts(){
    if(_products.isEmpty){
      print("No products available.\n");
      return;
    }
    print("\nAll Products:");
    for(int i=0; i < _products.length; i++) {
      print("Products #${i+1}:");
      print(_products[i]);
    }
  }

  void viewProduct(int index){
    if (index < 0 || index >= _products.length){
      print("Invalid product index.\n");
      return;
    }
    print(_products[index]);
  }

  void editProduct(int index, {String? name, String? description, double? price}){
    if(index < 0 || index >= _products.length){
      print("Invalid product index.\n");
      return;
    }

    try {
      if (name != null){
        _products[index].name = name;
      }
      if (description!= null){
        _products[index].description = description;
      }
      if (price != null){
        _products[index].price = price;
      }
      print("Product updated successfully.\n");
    }catch (e){
      print("Error: ${e.toString()}\n");
    }
  }

  void deleteProduct(int index) {
    if (index < 0 || index >= _products.length) {
      print("Invalid product index.\n");
      return;
    }
    _products.removeAt(index);
    print("Product deleted successfully.\n");
  }
  }



void main(){
  final manager = ProductManager();

  while(true) {
    print(""" ECOMMERCE PRODUCT MANAGER
      1. Add Product
      2. View All Products
      3. View Product by Index
      4. Edit Product
      5. Delete Product
      6. Exit
      _______________________________________
      Enter your choice:
      """);
    String? choice = stdin.readLineSync();
      switch(choice) {
        case '1':
        try{
          print("Enter Product name");
          String name = stdin.readLineSync() ?? "";
          if (name.isEmpty){
            print("Name can not be empty.\n");
            break;
          }

          print("Enter Product description");
          String description = stdin.readLineSync() ?? "";
          if (description.isEmpty){
            print(" description can not be empty.\n");
            break;
          }

          print("Enter Product price");
          double? price = double.tryParse(stdin.readLineSync() ?? "");

          if (price == null || price < 0) {
            print("Invalid price. Please enter a positive number.\n");
            break;
          }
          
          manager.addProduct(Product(name,description,price));
        }catch(e){
          print("Error: ${e.toString()}\n");
        }
        break;

        case '2':
          manager.viewAllProducts();
          break;
        
        case '3':
          print("Enter product index:");
          int? index = int.tryParse(stdin.readLineSync()?? "");
          if (index == null || index <= 0){
            print("Invalid index. Please enter a positive number.\n");
            break;
          }
          manager.viewProduct(index - 1);
          break;
        case '4':
          print ("Enter product indext to edit:");
          int? index = int.tryParse(stdin.readLineSync() ?? "");
          if (index == null || index <= 0 || index > manager._products.length){
            print("Invalid index.\n");
            break;
          }

          try{
            print("Enter new Product name (leave empty to keep current):");
            String name = stdin.readLineSync() ?? "";
            String? newName = name.isEmpty ? null : name;

            print("Enter new Product description (leave empty to keep current):");
            String description = stdin.readLineSync() ?? "";
            String? newDescription = description.isEmpty ? null : description;

            print("Enter new Product price (leave empty to keep current):");
            String priceInput = stdin.readLineSync() ?? "";
            double? newPrice = priceInput.isEmpty ? null : double.tryParse(priceInput);

            if (newPrice != null && newPrice < 0) {
            print("Price cannot be negative.\n");
            break;
            }
            manager.editProduct(index - 1,
                name : newName,
                description: newDescription,
                price: newPrice);
          }catch (e) {
          print("Error: ${e.toString()}\n");
        }
        break;

        case '5':
          print("Enter the product index to delete:");
          int? index = int.tryParse(stdin.readLineSync() ?? "");
          if (index == null || index <=0 || index > manager._products.length){
            print("INvalid index.\n");
            break;
          }
          manager.deleteProduct(index-1);
          break;
        case '6':
          print("Exiting...");
          return;
        default:
          print("Invalid choice. Please try again.\n");

    }
    }
}
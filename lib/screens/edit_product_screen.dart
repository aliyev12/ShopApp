import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/providers/product.dart';
import 'package:validators/validators.dart';

class EditProductScreen extends StatefulWidget {
  static String routeName = '/edit-product';

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _imageUrlFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();
  Product _editedProduct = Product(
    id: null,
    title: '',
    price: 0,
    description: '',
    imageUrl: '',
  );

  @override
  void initState() {
    _imageUrlFocusNode.addListener(_updateImageUrl);
    super.initState();
  }

  @override
  void dispose() {
    _imageUrlFocusNode.removeListener(_updateImageUrl);
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlController.dispose();
    _imageUrlFocusNode.dispose();
    super.dispose();
  }

  void _updateImageUrl() {
    if (!_imageUrlFocusNode.hasFocus) {
      setState(() {});
    }
  }

  void _saveForm() {
    _form.currentState.save();
    print(_editedProduct.title);
    print(_editedProduct.id);
    print(_editedProduct.description);
    print(_editedProduct.imageUrl);
    print(_editedProduct.price);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Product'),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveForm,
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Form(
          key: _form,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                TextFormField(
                  decoration: InputDecoration(labelText: 'Title'),
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (value) {
                    FocusScope.of(context).requestFocus(_priceFocusNode);
                  },
                  onSaved: (value) {
                    _editedProduct = Product(
                      id: _editedProduct.id,
                      title: value,
                      price: _editedProduct.price,
                      description: _editedProduct.description,
                      imageUrl: _editedProduct.imageUrl,
                    );
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Price'),
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.number,
                  focusNode: _priceFocusNode,
                  onFieldSubmitted: (value) {
                    FocusScope.of(context).requestFocus(_descriptionFocusNode);
                  },
                  onSaved: (value) {
                    _editedProduct = Product(
                      id: _editedProduct.id,
                      title: _editedProduct.title,
                      price: double.parse(value),
                      description: _editedProduct.description,
                      imageUrl: _editedProduct.imageUrl,
                    );
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Description'),
                  maxLines: 3,
                  keyboardType: TextInputType.multiline,
                  focusNode: _descriptionFocusNode,
                  onSaved: (value) {
                    _editedProduct = Product(
                      id: _editedProduct.id,
                      title: _editedProduct.title,
                      price: _editedProduct.price,
                      description: value,
                      imageUrl: _editedProduct.imageUrl,
                    );
                  },
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Container(
                      width: 100,
                      height: 100,
                      margin: EdgeInsets.only(top: 8, right: 10),
                      decoration: BoxDecoration(
                        border: Border.all(width: 1),
                        color: Colors.grey,
                      ),
                      child: _imageUrlController.text.isEmpty ||
                              !isURL(_imageUrlController.text)
                          ? Text('Enter a URL')
                          : FittedBox(
                              child: Image.network(_imageUrlController.text),
                              fit: BoxFit.cover,
                            ),
                    ),
                    Expanded(
                      child: TextFormField(
                        decoration: InputDecoration(labelText: 'Image URL'),
                        keyboardType: TextInputType.url,
                        textInputAction: TextInputAction.done,
                        controller: _imageUrlController,
                        focusNode: _imageUrlFocusNode,
                        onFieldSubmitted: (value) {
                          _saveForm();
                        },
                        onEditingComplete: () {
                          setState(() {});
                        },
                        onSaved: (value) {
                          _editedProduct = Product(
                            id: _editedProduct.id,
                            title: _editedProduct.title,
                            price: _editedProduct.price,
                            description: _editedProduct.description,
                            imageUrl: value,
                          );
                        },
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
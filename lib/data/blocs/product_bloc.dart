import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:product_management/data/events/product_event.dart';
import 'package:product_management/data/models/product.dart';
import 'package:product_management/data/repository/api_repository.dart';
import 'package:product_management/data/states/product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState>{
  final ApiRepository apiRepository;

  ProductBloc({required this.apiRepository}) : super(ProductInitial()){
    on<FetchProduct>(_onFetchProduct);
    on<AddProduct>(_onAddProduct);
    on<DeleteProduct>(_onDeleteProduct);
  }

  Future<void> _onFetchProduct(FetchProduct event, Emitter<ProductState> emit) async{
    emit(ProductLoading());
    try{
      final products = await apiRepository.fetchProducts();
        emit(ProductLoaded(products: products, action: ProductAction.fetch));
    } catch(e){
      emit(ProductError(message: e.toString()));
    }
  }

  Future<void> _onAddProduct(AddProduct event, Emitter<ProductState> emit) async{
    if(state is ProductLoaded){
      final currentState = state as ProductLoaded;
      final newProduct = Product(name: event.name, price: event.price, imageUrl: event.imageUrl);

      final updateProducts = [newProduct, ...currentState.products];
      emit(ProductLoaded(products: updateProducts, action: ProductAction.added));
    }
  }

  Future<void> _onDeleteProduct(DeleteProduct event, Emitter<ProductState> emit) async {
    if (state is ProductLoaded) {
      final currentState = state as ProductLoaded;
      //xóa bằng cách so sánh tất cả thuộc tính
      final updatedProducts = currentState.products.where((product) =>
      product.name != event.product.name ||
          product.price != event.product.price ||
          product.imageUrl != event.product.imageUrl).toList();

      emit(ProductLoaded(products: updatedProducts, action: ProductAction.deleted));
    }
  }
}
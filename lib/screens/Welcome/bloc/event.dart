abstract class ProductEvent {
  const ProductEvent();
}

class initialLoad extends ProductEvent {
  const initialLoad();
}

class RefreshProducts extends ProductEvent {
  const RefreshProducts();
}

class IncrementPage extends ProductEvent {
  const IncrementPage();
}

class DecrementPage extends ProductEvent {
  const DecrementPage();
}
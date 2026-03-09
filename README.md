# So sánh các hướng quản lý state trong Flutter

## Các branch (state management) được so sánh
- `normalstate`: dùng `setState` thuần trong widget.
- `normalvaluenoti`: dùng `ValueNotifier` + `ValueListenableBuilder`.
- `inherited`: dùng `InheritedWidget` thuần.
- `master`: Nhánh `master` dùng `BLoC` với luồng event/state rõ ràng.
- `provider`: package `provider` (bao trên `InheritedWidget`).
- `riverpod`: package `riverpod/flutter_riverpod`.
- `getX`: package `get` sở hữu nhiều tiện ích riêng.
- `redux`: kiến trúc Redux (store, action, reducer, middleware).
- `signal`: mô hình signal/reactive state (ví dụ package `signals`).

## Bảng so sánh theo tiêu chí

| Tên nhánh | Cơ chế hoạt động | Tối ưu (độ phù hợp tổng thể) | Tích hợp vào app | Khối lượng triển khai | Hiệu năng | Có khả năng triển khai global state | Ghi chú |
|---|---|---|---|---|---|---|---|
| `normalstate` | `setState()` cập nhật local state và rebuild subtree của `StatefulWidget` | Tốt cho màn hình nhỏ, kém khi app lớn | Rất dễ (built-in) | Rất thấp | Tốt ở local state, dễ rebuild rộng nếu lạm dụng | Không phù hợp cho global state lớn | Hợp demo và UI cục bộ đơn giản |
| `normalvaluenoti` | `ValueNotifier` phát thay đổi, `ValueListenableBuilder` lắng nghe và rebuild vùng nhỏ | Tốt cho state đơn giản, tách rebuild tốt hơn `setState` | Dễ (built-in) | Thấp | Tốt, update theo listenable | Có thể, nhưng khó quản lý khi scale lớn | Hợp form/filter/list nhỏ cần phản ứng nhanh |
| `inherited` | Widget con `dependOnInheritedWidgetOfExactType`, cập nhật theo `updateShouldNotify` | Tốt nếu muốn tự kiểm soát và không thêm package | Trung bình (cần tổ chức context tốt) | Trung bình đến cao (boilerplate) | Tốt, phụ thuộc `updateShouldNotify` | Có, nhưng maintain khó khi app lớn | Không thêm dependency nhưng code tay nhiều |
| `master` (BLoC/Cubit) | Event/action vào `Bloc/Cubit`, xử lý nghiệp vụ rồi `emit` state mới qua stream | Rất tốt cho app vừa đến lớn, luồng state rõ | Trung bình (cần setup `BlocProvider`, event/state) | Trung bình đến cao | Tốt đến rất tốt (`BlocBuilder`/`BlocSelector`) | Có, phù hợp global state và scale team | Mạnh về test và tách UI/business rõ |
| `provider` | Bọc cây widget bằng provider, UI đọc bằng `context.watch/read/select` hoặc `Consumer` | Cân bằng tốt giữa đơn giản và mở rộng | Dễ (phổ biến, học nhanh) | Thấp đến trung bình | Tốt, có `Consumer`/`Selector` để tối ưu | Có, phù hợp production nhiều app vừa/lớn | Dễ học, quản lý bộ nhớ tốt tuy nhiên lại phụ thuộc nhiều và context |
| `riverpod` | Truy cập state không phụ thuộc vào BuildContext, sử dụng ref để watch hoặc read, đảm bảo an toàn ngay từ khi biên dịch | Rất tối ưu cho codebase lớn, ít lỗi runtime hơn | Trung bình (cần làm quen API) | Trung bình | Rất tốt, dependency rõ ràng, rebuild mượt | Có, rất mạnh cho global state | Mạnh về an toàn kiểu và testability |
| `getX` | Dùng `Rx`/controller, UI `Obx` hoặc `GetBuilder` lắng nghe và cập nhật chọn lọc, hệ sinh thái hỗ trợ nhiêu tính năng | Tối ưu tốc độ phát triển, ít boilerplate | Rất dễ (all-in-one: state/route/DI) | Thấp | Tốt đến rất tốt (`Obx` update chọn lọc) | Có, mạnh cho global state | Nhanh ra tính năng nhưng cần kỷ luật để tránh bug |
| `redux` | `dispatch(action)` vào store, reducer tạo state mới immutable, middleware xử lý side effect | Tối ưu khi cần tính nhất quán, trace/debug rất chặt | Khó hơn các cách khác | Cao | Trung bình đến tốt (phụ thuộc selector/memoization) | Có, rất mạnh nhưng nặng cho app nhỏ | Hợp dự án lớn cần audit luồng dữ liệu, debug dễ dàng |
| `signal` | Signal theo dõi dependency, `computed/effect` chạy lại khi giá trị đổi | Tốt cho reactive fine-grained update | Trung bình (phụ thuộc package/pattern) | Thấp đến trung bình | Rất tốt (granular reactivity) | Có, nhưng cần convention rõ để scale team | Rất mượt cho UI realtime, hệ sinh thái còn mới |

## Kết luận nhanh
- Nếu ưu tiên **nhanh triển khai**: `getX` > `provider` > `normalvaluenoti`.
- Nếu ưu tiên **dễ bảo trì dài hạn**: `riverpod` ~ `master(BLoC)` > `provider`.
- Nếu ưu tiên **kiểm soát chặt kiến trúc enterprise**: `redux` (đổi lại chi phí code cao).
- Nếu app nhỏ hoặc demo nghịch vui vui: `normalstate`/`normalvaluenoti` là đủ.



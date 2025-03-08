import 'package:flutter_test/flutter_test.dart';
import 'package:product_management/data/validators/validators.dart';

void main() {
  group('Validators Test', () {
    test('Trả về lỗi nếu trường bắt buộc bị bỏ trống', () {
      final result = Validators.validateField(
        value: '',
        label: 'Tên sản phẩm',
        required: true,
      );
      expect(result, 'Vui lòng nhập Tên sản phẩm');
    });

    test('Không có lỗi nếu trường không bắt buộc và bị bỏ trống', () {
      final result = Validators.validateField(
        value: '',
        label: 'Ghi chú',
        required: false,
      );
      expect(result, null);
    });

    test('Trả về lỗi nếu giá trị không phải số hợp lệ', () {
      final result = Validators.validateField(
        value: 'abc',
        label: 'Giá sản phẩm',
        required: true,
        isNumber: true,
      );
      expect(result, 'Giá sản phẩm phải là số');
    });

    test('Trả về lỗi nếu giá nhỏ hơn giá trị tối thiểu', () {
      final result = Validators.validateField(
        value: '9',
        label: 'Giá sản phẩm',
        required: true,
        isNumber: true,
        minValue: 10,
      );
      expect(result, 'Giá sản phẩm phải lớn hơn 10');
    });

    test('Trả về lỗi nếu giá lớn hơn giá trị tối đa', () {
      final result = Validators.validateField(
        value: '110',
        label: 'Giá sản phẩm',
        required: true,
        isNumber: true,
        maxValue: 100,
      );
      expect(result, 'Giá sản phẩm phải nhỏ hơn 100');
    });

    test('Trả về lỗi nếu độ dài vượt quá giới hạn', () {
      final result = Validators.validateField(
        value: 'abcdef',
        label: 'Tên sản phẩm',
        required: true,
        maxLength: 5,
      );
      expect(result, 'Tên sản phẩm không được quá 5 ký tự');
    });

    test('Không có lỗi nếu nhập đúng giá trị hợp lệ', () {
      final result = Validators.validateField(
        value: 'Laptop',
        label: 'Tên sản phẩm',
        required: true,
        maxLength: 20,
      );
      expect(result, null);
    });
  });
}

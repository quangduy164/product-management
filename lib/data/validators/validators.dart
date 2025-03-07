class Validators {
  static String? validateField({
    required String? value,
    required String label,
    bool required = false,
    bool isNumber = false,
    int? minValue,
    int? maxValue,
    int? maxLength,
  }) {
    if (required && (value == null || value.trim().isEmpty)) {
      return "Vui lòng nhập $label";
    }

    if (isNumber) {
      if (value == null || value.isEmpty) return "Vui lòng nhập $label";
      if (int.tryParse(value) == null) return "$label phải là số";

      int number = int.parse(value);
      if (minValue != null && number < minValue) {
        return "$label phải lớn hơn hoặc bằng $minValue";
      }
      if (maxValue != null && number > maxValue) {
        return "$label phải nhỏ hơn hoặc bằng $maxValue";
      }
    }

    if (maxLength != null && value != null && value.length > maxLength) {
      return "$label không được quá $maxLength ký tự";
    }

    return null;
  }
}

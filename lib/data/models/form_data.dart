class FormData{
  final String label;
  final List<FormFieldModel> formFields;
  final String buttonText;

  FormData({required this.label, required this.formFields, required this.buttonText});

  factory FormData.fromJs(Map<String, dynamic> json){
    String label = "";
    List<FormFieldModel> formFields = [];
    String buttonText = "";

    for(var item in json["data"]){
      if(item["type"] == "Label"){
        label = item["customAttributes"]["label"]["text"];
      } else if(item["type"] == "ProductSubmitForm"){
        formFields = (item["customAttributes"]["form"] as List)
                    .map((field) => FormFieldModel.fromJs(field)).toList();
      } else if(item["type"] == "Button"){
        buttonText = item["customAttributes"]["button"]["text"];
      }
    }
    return FormData(label: label, formFields: formFields, buttonText: buttonText);
  }

}

class FormFieldModel{
  final String label;
  final String name;
  final String type;
  final bool required;
  final int? maxLength;
  final int? minValue;
  final int? maxValue;

  FormFieldModel({
    required this.label,
    required this.name,
    required this.type,
    required this.required,
    required this.maxLength,
    required this.minValue,
    required this.maxValue
  });

  factory FormFieldModel.fromJs(Map<String, dynamic> json){
    return FormFieldModel(
        label: json["lable"],
        name: json["name"],
        type: json["type"],
        required: json["required"] ?? false,
        maxLength: json["maxLength"],
        minValue: json["minValue"],
        maxValue: json["maxValue"]
    );
  }
}
import 'package:flutter/material.dart';

enum HeightType { cm, feetInch }

enum WeightType { kg, lb }

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  HeightType? heightType = HeightType.cm;
  WeightType weightType = WeightType.kg;

  final weightController = TextEditingController();
  final cmController = TextEditingController();
  final feetController = TextEditingController();
  final InchController = TextEditingController();

  String bmiResult = '';

  String? catagory;
  Color? catcolor;

  String catagoryResult(double bmi) {
    if (bmi < 18.5) return "Underweight";
    if (18.5 <= bmi && bmi <= 24.9) return "Normal";
    if (25 <= bmi && bmi <= 29.9) return "Overweight";
    return "Obese";
  }

  Color categoryColor(String category) {
    switch (category) {
      case "Underweight":
        return Colors.blue;
      case "Normal":
        return Colors.green;
      case "Overweight":
        return Colors.orange;
      default:
        return Colors.red;
    }
  }

  double? cmToM() {
    final cm = double.tryParse(cmController.text.trim());
    if (cm == null || cm <= 0) {
      return null;
    } else {
      return cm / 100;
    }
  }

  double? feetInchToM() {
    final feet = double.tryParse(feetController.text.trim());
    final inch = double.tryParse(InchController.text.trim());
    if (feet == null || feet <= 0 || inch == null || inch < 0) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Invalid Values")));
      return null;
    }

    final totalInch = feet * 12 + inch;
    if (totalInch <= 0) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Invalid Values")));

      return null;
    }
    return totalInch * 0.0254;
  }

  //............... calculate BMI ..............

  void Calculate() {
    var weight = double.tryParse(weightController.text.trim());

    if (weight == null || weight <= 0) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Invalid Values")));
      return null;
    }

    if (weightType == WeightType.lb) {
      weight = weight * 0.453592;
    }

    final m = heightType == HeightType.cm ? cmToM() : feetInchToM();
    if (m == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Invalid Values")));
      return null;
    }

    //final  w = WeightType == WeightType.kg ? weightlb : weightlb /2.20462;

    final bmi = weight / (m * m);

    final cat = catagoryResult(bmi);
    final color = categoryColor(cat);

    setState(() {
      bmiResult = bmi.toStringAsFixed(2);
      catagory = cat;
      catcolor = color;
    });
    weightController.clear();
    cmController.clear();
    feetController.clear();
    InchController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('BMI Calculator'),
        backgroundColor: Colors.green,
      ),

      body: ListView(
        children: [
          SizedBox(height: 10),
          SegmentedButton<WeightType>(
            segments: [
              ButtonSegment<WeightType>(
                value: WeightType.kg,
                label: Text('Kg'),
              ),
              ButtonSegment<WeightType>(
                value: WeightType.lb,
                label: Text('lb(pound)'),
              ),
            ],
            selected: {?weightType},
            onSelectionChanged: (value) =>
                setState(() => weightType = value.first),
          ),

          SizedBox(height: 10),
          TextFormField(
            controller: weightController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Weight ',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
          ),
          SizedBox(height: 15),

          Text(
            "Height Unit",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SegmentedButton<HeightType>(
            segments: [
              ButtonSegment<HeightType>(
                value: HeightType.cm,
                label: Text('CM'),
              ),
              ButtonSegment<HeightType>(
                value: HeightType.feetInch,
                label: Text("Feet / Inch"),
              ),
            ],
            selected: {?heightType},
            onSelectionChanged: (value) =>
                setState(() => heightType = value.first),
          ),
          SizedBox(height: 15),

          if (heightType == HeightType.cm) ...[
            TextField(
              keyboardType: TextInputType.number,
              controller: cmController,
              decoration: InputDecoration(
                labelText: 'Height (cm)',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),
          ] else ...[
            SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    keyboardType: TextInputType.number,
                    controller: feetController,
                    decoration: InputDecoration(
                      labelText: "Feet(')",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10),

                Expanded(
                  child: TextField(
                    keyboardType: TextInputType.number,
                    controller: InchController,
                    decoration: InputDecoration(
                      labelText: 'Inch(")',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
          SizedBox(height: 15),

          SizedBox(height: 15),
          ElevatedButton(
            onPressed: Calculate,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.black,
            ),
            child: Text(
              'Calculate',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ),

          SizedBox(height: 20),

          Card(
            color: catcolor ?? Colors.grey,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadiusGeometry.circular(15),
            ),
            elevation: 5,
            child: Column(
              children: [
                Text(
                  "BMI : ${bmiResult}",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 15),
                Text(
                  "Catagorey: ${catagory ?? ''}",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 330),
          Center(
            child: Text("Developed By Jakaria",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,

            ),
            ),
          ),
        ],
      ),
    );
  }
}

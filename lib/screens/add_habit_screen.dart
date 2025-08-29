import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../main.dart'; // Habit modelini kullanmak için

class AddHabitScreen extends StatefulWidget {
  final Habit? habitToEdit; // Yeni: düzenlenecek alışkanlık
  
  const AddHabitScreen({super.key, this.habitToEdit});

  @override
  _AddHabitScreenState createState() => _AddHabitScreenState();
}

class _AddHabitScreenState extends State<AddHabitScreen> {
  final _formKey = GlobalKey<FormState>();
  final _habitNameController = TextEditingController();
  final _goalValueController = TextEditingController();

  String _selectedTimeframe = 'Günlük';
  String _selectedGoalUnit = 'Adet';
  IconData _selectedIcon = Icons.fitness_center_outlined;
  Color _selectedColor = Colors.blue;

  final List<String> _timeframeOptions = ['Günlük', 'Haftalık', 'Aylık'];
  final List<String> _unitOptions = ['Adet', 'Dakika', 'Sayfa', 'Bardak'];
  final List<IconData> _iconOptions = [
    Icons.fitness_center_outlined,
    Icons.book_outlined,
    Icons.water_drop_outlined,
    Icons.directions_run_outlined,
    Icons.school_outlined,
    Icons.monetization_on_outlined,
    Icons.self_improvement_outlined,
    Icons.code_outlined,
  ];
  final List<Color> _colorOptions = [
    Colors.blue,
    Colors.red,
    Colors.green,
    Colors.purple,
    Colors.orange,
    Colors.teal,
    Colors.pink,
    Colors.brown,
  ];
  
  @override
  void initState() {
    super.initState();
    // Eğer düzenleme modundaysak, mevcut verileri yükle
    if (widget.habitToEdit != null) {
      _habitNameController.text = widget.habitToEdit!.habitName;
      _goalValueController.text = widget.habitToEdit!.goalValue.toString();
      _selectedTimeframe = widget.habitToEdit!.timeframe;
      _selectedGoalUnit = widget.habitToEdit!.goalUnit;
      _selectedIcon = widget.habitToEdit!.icon;
      _selectedColor = widget.habitToEdit!.color;
    }
  }

  @override
  void dispose() {
    _habitNameController.dispose();
    _goalValueController.dispose();
    super.dispose();
  }

  void _saveHabit() {
    if (_formKey.currentState!.validate()) {
      final newHabit = Habit(
        habitName: _habitNameController.text,
        goalValue: int.tryParse(_goalValueController.text) ?? 1,
        goalUnit: _selectedGoalUnit,
        timeframe: _selectedTimeframe,
        icon: _selectedIcon,
        color: _selectedColor,
        // Düzenleme modunda mevcut ilerleme ve seriyi koru
        currentProgress: widget.habitToEdit?.currentProgress ?? 0,
        streak: widget.habitToEdit?.streak ?? 0,
        lastCompletedDate: widget.habitToEdit?.lastCompletedDate,
      );
      Navigator.pop(context, newHabit);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isEditing = widget.habitToEdit != null;
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Alışkanlığı Düzenle' : 'Yeni Alışkanlık Ekle'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextFormField(
                controller: _habitNameController,
                decoration: _inputDecoration('Alışkanlık Adı', Icons.task_outlined),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Lütfen bir alışkanlık adı girin.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _goalValueController,
                decoration: _inputDecoration('Hedef Değeri', Icons.flag_outlined),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Lütfen bir hedef değeri girin.';
                  }
                  if (int.tryParse(value) == null || int.parse(value) <= 0) {
                    return 'Geçerli bir sayı girin.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              _buildDropdown('Zaman Dilimi', _timeframeOptions, _selectedTimeframe, (String? newValue) {
                setState(() {
                  _selectedTimeframe = newValue!;
                });
              }),
              const SizedBox(height: 16),
              _buildDropdown('Birim', _unitOptions, _selectedGoalUnit, (String? newValue) {
                setState(() {
                  _selectedGoalUnit = newValue!;
                });
              }),
              const SizedBox(height: 24),
              _buildIconSelector(),
              const SizedBox(height: 24),
              _buildColorSelector(),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _saveHabit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF007BFF),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  isEditing ? 'Alışkanlığı Güncelle' : 'Alışkanlığı Kaydet',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String labelText, IconData icon) {
    return InputDecoration(
      labelText: labelText,
      prefixIcon: Icon(icon),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }
  
  Widget _buildDropdown(String label, List<String> items, String selectedValue, Function(String?) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 12.0, bottom: 8.0),
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.grey,
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[400]!),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              isExpanded: true,
              value: selectedValue,
              items: items.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildIconSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'İkon Seç',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: _iconOptions.map((icon) {
            final isSelected = _selectedIcon == icon;
            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedIcon = icon;
                });
              },
              child: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: isSelected ? _selectedColor.withOpacity(0.2) : Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected ? _selectedColor : Theme.of(context).cardColor,
                    width: 2,
                  ),
                ),
                child: Icon(
                  icon,
                  color: isSelected ? _selectedColor : Theme.of(context).iconTheme.color,
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildColorSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Renk Seç',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: _colorOptions.map((color) {
            final isSelected = _selectedColor == color;
            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedColor = color;
                });
              },
              child: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected ? Colors.black : Colors.transparent,
                    width: isSelected ? 3 : 0,
                  ),
                ),
                child: isSelected
                    ? const Icon(
                        Icons.check,
                        color: Colors.white,
                      )
                    : null,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mama_kris/widgets/custom_checkbox.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mama_kris/utils/funcs.dart' as funcs;
import 'package:mama_kris/constants/api_constants.dart';

class CustomMultiSelectDropdown extends StatefulWidget {
  final double scaleX;
  final double scaleY;
  final String hintText;
  final double?
      width; // Если не задано, используется значение по умолчанию (396)
  final String activeIconPath;
  final String inactiveIconPath;
  // Если данные уже получены извне, можно передать их через items
  final List<Map<String, dynamic>>? items;

  const CustomMultiSelectDropdown({
    super.key,
    required this.scaleX,
    required this.scaleY,
    required this.hintText,
    this.width,
    this.activeIconPath = 'assets/dropdown/active.svg',
    this.inactiveIconPath = 'assets/dropdown/inactive.svg',
    this.items,
  });

  @override
  CustomMultiSelectDropdownState createState() =>
      CustomMultiSelectDropdownState();
}

class CustomMultiSelectDropdownState extends State<CustomMultiSelectDropdown> {
  bool _isExpanded = false;
  // Храним выбранные значения в виде идентификаторов сфер (sphereID)
  Set<int> _selectedValues = {};

  // Список сфер, полученных через API или переданных через items
  List<Map<String, dynamic>> _spheres = [];
  bool _isLoading = true;

  // Геттер для доступа к выбранным идентификаторам
  Set<int> get selectedValues => _selectedValues;

  // Метод для обновления выбранных значений из вне
  void updateSelectedValues(Set<int> newValues) {
    setState(() {
      _selectedValues = newValues;
    });
  }

  // Геттер для получения списка заголовков (для отображения) – используем данные из _spheres
  List<String> get sphereTitles =>
      _spheres.map((sphere) => sphere["title"] as String).toList();

  @override
  void initState() {
    super.initState();
    if (widget.items != null) {
      _spheres = widget.items!;
      _isLoading = false;
    } else {
      fetchSpheres();
    }
  }

  Future<void> fetchSpheres() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');
      if (token == null) {
        // print("Токен не найден в SharedPreferences");
        setState(() {
          _isLoading = false;
        });
        return;
      }
      final response = await http.get(
        Uri.parse('${kBaseUrl}search-spheres'),
        headers: {'accept': '*/*', 'Authorization': 'Bearer $token'},
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        setState(() {
          _spheres = data.map((e) => e as Map<String, dynamic>).toList();
          _isLoading = false;
        });
      } else if (response.statusCode == 401) {
        // Если токен устарел, пробуем обновить его
        final refreshSuccess = await funcs.refreshAccessToken();
        if (refreshSuccess) {
          final newToken = await SharedPreferences.getInstance().then(
            (prefs) => prefs.getString('auth_token')!,
          );
          final retryResponse = await http.get(
            Uri.parse('${kBaseUrl}search-spheres'),
            headers: {'accept': '*/*', 'Authorization': 'Bearer $newToken'},
          );
          if (retryResponse.statusCode == 200) {
            final List<dynamic> data = jsonDecode(retryResponse.body);
            setState(() {
              _spheres = data.map((e) => e as Map<String, dynamic>).toList();
              _isLoading = false;
            });
          } else {
            // print(
            //   "Ошибка загрузки сфер после обновления токена: ${retryResponse.statusCode}",
            // );
            setState(() {
              _isLoading = false;
            });
          }
        } else {
          // print("Ошибка аутентификации: не удалось обновить токен");
          setState(() {
            _isLoading = false;
          });
        }
      } else {
        // print("Ошибка загрузки сфер: ${response.statusCode}");
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      // print("Ошибка подключения при загрузке сфер: $e");
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _toggleDropdown() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }

  // Изменение выбора: теперь option — идентификатор (int)
  void _onOptionChanged(int sphereId, bool selected) {
    setState(() {
      if (selected) {
        _selectedValues.add(sphereId);
      } else {
        _selectedValues.remove(sphereId);
      }
    });
  }

  // Выбрать/снять выбор для всех: устанавливаем выбранными все sphereID из _spheres
  void _toggleSelectAll() {
    final bool allSelected = _selectedValues.length == _spheres.length;
    setState(() {
      if (!allSelected) {
        _selectedValues = _spheres.map((s) => s["sphereID"] as int).toSet();
      } else {
        _selectedValues.clear();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final double fieldWidth = widget.width ?? 396;
    // Для отображения в не раскрытом состоянии, преобразуем выбранные идентификаторы в заголовки
    List<String> selectedTitles = _spheres
        .where((s) => _selectedValues.contains(s["sphereID"]))
        .map((s) => s["title"] as String)
        .toList();
    final String displayText =
        _selectedValues.isEmpty ? widget.hintText : selectedTitles.join(", ");

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Основное поле, по нажатию раскрывающее список
        GestureDetector(
          onTap: _toggleDropdown,
          child: Container(
            width: fieldWidth,
            height: 60 * widget.scaleY,
            padding: EdgeInsets.fromLTRB(
              25 * widget.scaleX,
              16 * widget.scaleY,
              25 * widget.scaleX,
              16 * widget.scaleY,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFFF9F9F9),
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(15 * widget.scaleX),
                bottom: _isExpanded
                    ? Radius.zero
                    : Radius.circular(15 * widget.scaleX),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    displayText,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontFamily: 'Jost',
                      fontWeight: FontWeight.w600,
                      fontSize: 18 * widget.scaleX,
                      height: 28 / 18,
                      letterSpacing: -0.18 * widget.scaleX,
                      color: _selectedValues.isEmpty
                          ? const Color(0xFF979AA0)
                          : const Color(0xFF596574),
                    ),
                  ),
                ),
                SvgPicture.asset(
                  _isExpanded ? widget.activeIconPath : widget.inactiveIconPath,
                  width: 14 * widget.scaleX,
                  height: 8 * widget.scaleY,
                ),
              ],
            ),
          ),
        ),
        if (_isExpanded)
          Container(
            width: fieldWidth,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(
                top: Radius.zero,
                bottom: Radius.circular(15 * widget.scaleX),
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0x78E7E7E7),
                  offset: Offset(0, 4 * widget.scaleY),
                  blurRadius: 19 * widget.scaleX,
                ),
              ],
            ),
            child: _isLoading
                ? Padding(
                    padding: EdgeInsets.all(20 * widget.scaleX),
                    child: const Center(child: CircularProgressIndicator()),
                  )
                : Column(
                    children: [
                      // Пункт "Все вакансии интересны"
                      GestureDetector(
                        onTap: _toggleSelectAll,
                        child: Container(
                          width: fieldWidth,
                          padding: EdgeInsets.symmetric(
                            horizontal: 25 * widget.scaleX,
                            vertical: 12 * widget.scaleY,
                          ),
                          child: Row(
                            children: [
                              CustomCheckbox(
                                initialValue:
                                    _selectedValues.length == _spheres.length,
                                onChanged: (bool value) {
                                  _toggleSelectAll();
                                },
                                scaleX: widget.scaleX,
                                scaleY: widget.scaleY,
                              ),
                              SizedBox(width: 10 * widget.scaleX),
                              Expanded(
                                child: Text(
                                  "Все вакансии интересны",
                                  style: TextStyle(
                                    fontFamily: 'Jost',
                                    fontWeight: FontWeight.w600,
                                    fontSize: 18 * widget.scaleX,
                                    height: 28 / 18,
                                    letterSpacing: -0.18 * widget.scaleX,
                                    color: const Color(0xFF596574),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const Divider(
                        color: Color(0xFF596574),
                        thickness: 1,
                        height: 0,
                      ),
                      // Остальные варианты
                      ..._spheres.map((sphere) {
                        final int id = sphere["sphereID"] as int;
                        final String title = sphere["title"] as String;
                        final bool isSelected = _selectedValues.contains(id);
                        return GestureDetector(
                          onTap: () => _onOptionChanged(id, !isSelected),
                          child: Container(
                            width: fieldWidth,
                            padding: EdgeInsets.symmetric(
                              horizontal: 25 * widget.scaleX,
                              vertical: 12 * widget.scaleY,
                            ),
                            child: Row(
                              children: [
                                CustomCheckbox(
                                  initialValue: isSelected,
                                  onChanged: (bool value) {
                                    _onOptionChanged(id, value);
                                  },
                                  scaleX: widget.scaleX,
                                  scaleY: widget.scaleY,
                                ),
                                SizedBox(width: 10 * widget.scaleX),
                                Expanded(
                                  child: Text(
                                    title,
                                    style: TextStyle(
                                      fontFamily: 'Jost',
                                      fontWeight: FontWeight.w600,
                                      fontSize: 18 * widget.scaleX,
                                      height: 28 / 18,
                                      letterSpacing: -0.18 * widget.scaleX,
                                      color: const Color(0xFF596574),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                    ],
                  ),
          ),
      ],
    );
  }
}

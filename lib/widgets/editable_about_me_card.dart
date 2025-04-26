import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class EditableAboutMeCard extends StatefulWidget {
  const EditableAboutMeCard({super.key});

  @override
  State<EditableAboutMeCard> createState() => _EditableAboutMeCardState();
}

class _EditableAboutMeCardState extends State<EditableAboutMeCard> {
  // Флаг, показывающий, находимся ли мы в режиме редактирования
  bool isEditing = false;
  // Контроллер для текстового поля.
  final TextEditingController _controller = TextEditingController();
  // Фокус-нод для отслеживания получения/потери фокуса
  final FocusNode _focusNode = FocusNode();
  // Переменная для хранения сохранённого текста
  String savedText = '';

  @override
  void initState() {
    super.initState();
    // Инициализация сохранённого текста.
    // Здесь можно подгрузить ранее сохранённое значение из локального хранилища или базы данных.
    savedText = '';
    // Инициализируем текст контроллера сохранённым значением.
    _controller.text = savedText;
  }

  @override
  void dispose() {
    // Освобождаем ресурсы: контроллер и фокус-нод больше не нужны после уничтожения виджета.
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  // Метод _cancelEditing вызывается при нажатии кнопки "Отмена".
  // Он отменяет изменения, возвращая текст к ранее сохранённому значению и отключая режим редактирования.
  void _cancelEditing() {
    setState(() {
      // Восстанавливаем сохранённый текст в контроллере.
      _controller.text = savedText;
      // Выходим из режима редактирования.
      isEditing = false;
    });
  }

  // Метод _saveEditing вызывается при нажатии кнопки "Сохранить".
  // Он сохраняет текущее значение из текстового поля и отключает режим редактирования.
  void _saveEditing() {
    setState(() {
      // Сохраняем текущее значение из контроллера в переменную savedText.
      savedText = _controller.text;
      // Выходим из режима редактирования.
      isEditing = false;
      // Здесь можно добавить дополнительную логику для сохранения, например, отправку данных на сервер.
    });
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return Column(
      // mainAxisSize.min позволяет Column занимать минимально необходимое вертикальное пространство,
      // а не всё доступное, что важно для правильного отображения карточки и кнопок.
      mainAxisSize: MainAxisSize.min,
      children: [
        Card(
          elevation: 4, // Задает эффект тени для карточки.
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(12), // Скругление углов карточки.
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            // Здесь используется тернарный оператор:
            // Если isEditing == true, отображаем TextField, иначе – статичный текст.),
            child: isEditing
                ? TextField(
                    controller: _controller,
                    focusNode: _focusNode,
                    maxLines: 5, // Задает максимальное количество строк ввода.
                    decoration: InputDecoration(
                      hintText: loc
                          .profileAbout, // Подсказка для пустого текстового поля.
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  )
                : GestureDetector(
                    // Обработчик нажатия, чтобы переключиться в режим редактирования.
                    onTap: () {
                      setState(() {
                        isEditing = true; // Включаем режим редактирования.
                      });
                      _focusNode
                          .requestFocus(); // Переводим фокус на TextField.
                    },
                    // Container с отступами для отображения текста.
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      // Если текст пустой, отображается "О себе:", иначе – сохранённый/введённый текст.
                      child: Text(
                        _controller.text.isEmpty ? 'О себе:' : _controller.text,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
          ),
        ),
        // Если находимся в режиме редактирования, ниже карточки появляются кнопки "Отмена" и "Сохранить".
        if (isEditing)
          Padding(
            // Отступ сверху для разделения карточки и кнопок.
            padding: const EdgeInsets.only(top: 8.0),
            child: Row(
              mainAxisAlignment:
                  MainAxisAlignment.end, // Выравнивание кнопок по правому краю.
              children: [
                // Кнопка "Отмена" для отмены внесённых изменений.
                TextButton(
                  onPressed: _cancelEditing,
                  child: const Text('Отмена'),
                ),
                const SizedBox(width: 8), // Промежуток между кнопками.
                // Кнопка "Сохранить" для сохранения введённого текста.
                ElevatedButton(
                  onPressed: _saveEditing,
                  child: const Text('Сохранить'),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

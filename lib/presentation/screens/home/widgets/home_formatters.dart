String formatEnumName(String rawValue) {
  final buffer = StringBuffer();

  for (var index = 0; index < rawValue.length; index++) {
    final character = rawValue[index];
    final isUppercase =
        character.toUpperCase() == character &&
        character.toLowerCase() != character;

    if (index > 0 && isUppercase) {
      buffer.write(' ');
    }

    if (character == '_') {
      buffer.write(' ');
    } else {
      buffer.write(character);
    }
  }

  final words = buffer
      .toString()
      .split(' ')
      .where((word) => word.isNotEmpty)
      .map((word) => '${word[0].toUpperCase()}${word.substring(1)}');

  return words.join(' ');
}

String formatDateLabel(DateTime value) {
  const months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];

  return '${months[value.month - 1]} ${value.day}, ${value.year}';
}

bool hasExplicitTime(DateTime value) {
  return value.hour != 0 || value.minute != 0;
}

String formatTimeLabel(DateTime value) {
  final normalizedHour = value.hour % 12 == 0 ? 12 : value.hour % 12;
  final minutes = value.minute.toString().padLeft(2, '0');
  final meridiem = value.hour >= 12 ? 'PM' : 'AM';

  return '$normalizedHour:$minutes $meridiem';
}

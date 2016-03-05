import "dart:math";

class StringUtils {

  static String randomString(int length) {
    Random random = new Random();

    var codeUnits = new List.generate(length, (index){return random.nextInt(25)+97;});

    return new String.fromCharCodes(codeUnits);
  }
}
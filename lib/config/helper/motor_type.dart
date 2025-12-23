final Map<String, String> motorTypeAssets = {
  "adventure": "assets/icons/adventure_motor.png",
  "bebek": "assets/icons/bebek_motor.png",
  "moge": "assets/icons/big_motor.png",
  "sepeda": "assets/icons/bike.png",
  "listrik": "assets/icons/electric_motor.png",
  "matic": "assets/icons/matic_motor.png",
  "sport": "assets/icons/sport_motor.png",
};

String motorTypeLabel(String key) {
  switch (key) {
    case "bebek":
      return "Bebek";
    case "matic":
      return "Matic";
    case "sport":
      return "Sport";
    case "moge":
      return "Moge";
    case "adventure":
      return "Adventure";
    case "listrik":
      return "Motor Listrik";
    case "sepeda":
      return "Sepeda";
    default:
      return key.toUpperCase();
  }
}

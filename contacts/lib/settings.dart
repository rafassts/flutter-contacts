const String DATABASE_NAME = "contacts.db";
const String TABLE_CONTACTS = "contacts";
const String CREATE_TABLE_CONTACTS =
    "CREATE TABLE contacts (    id INTEGER PRIMARY KEY,    [name] TEXT,    email TEXT,    phone TEXT,    [image] TEXT,    addressLine1 TEXT,    addresLine2 TEXT,    latLng TEXT)";

const String DEFAULT_PROFILE_PICTURE_PATH = "assets/images/profile-picture.png";
const String URL_API_MAPS =
    "https://maps.googleapis.com/maps/api/geocode/json?key=YOUR_GOOGLE_API_KEY&address=";

// Jika menggunakan android device (AVD)
// String url = 'http://10.0.0.2:8000/api/';

// php artisan serve --host=0.0.0.0 --port=8000
// ambil ipv4 untuk baseUrl

// String baseUrl = 'http://127.0.0.1:8000/';
// String baseUrl = 'http://192.168.1.4:8000/';
String baseUrl = 'https://parkquest.site/';
String apiUrl = '${baseUrl}api/v1/';
String storageUrl = '${baseUrl}storage/';
var headers = {'Accept': 'application/json'};

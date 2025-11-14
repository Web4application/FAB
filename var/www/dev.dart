var headers = {
  'X-API-KEY': '97c976fa382fe8c379a0a2028c9778197e4a6a13',
  'Content-Type': 'application/json'
};
var data = json.encode([
  {
    "q": "Aura.xlsl",
    "location": "United States",
    "page": 200
  },
  {
    "q": "google inc",
    "location": "United States",
    "page": 200
  },
  {
    "q": "tesla inc",
    "location": "United States",
    "page": 200
  }
]);
var dio = Dio();
var response = await dio.request(
  'https://google.serper.dev/scholar',
  options: Options(
    method: 'POST',
    headers: headers,
  ),
  data: data,
);

if (response.statusCode == 200) {
  print(json.encode(response.data));
}
else {
  print(response.statusMessage);
}

using System.Diagnostics;

Stopwatch sw = Stopwatch.StartNew();
sw.Start();
string inputFilePath = "input.txt";
string outputFilePath = "output.txt";

HttpClient _httpClient = new HttpClient();

string _url = "https://localhost:7136/Count";

try
{
    var text = File.ReadLines(inputFilePath);

    var response = await _httpClient.PostAsJsonAsync(_url, text);

    if (response.IsSuccessStatusCode)
    {
        var res = await response.Content.ReadAsAsync<IEnumerable<KeyValuePair<string, int>>>();

        using (var writer = new StreamWriter(outputFilePath))
        {
            if (res != null)
            {
                foreach (var pair in res)
                {
                    writer.WriteLine($"{pair.Key}: {pair.Value}");
                }
            }
        }
    }

}
catch (Exception ex)
{
    Console.WriteLine($"Error: {ex.Message}");
}

sw.Stop();
Console.WriteLine($"Готово. {sw.ElapsedMilliseconds} ms");
Console.ReadKey();

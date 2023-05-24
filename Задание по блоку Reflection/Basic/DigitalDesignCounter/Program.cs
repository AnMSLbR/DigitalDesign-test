using System.Diagnostics;
using System.Reflection;
using DDCounter;

Stopwatch sw = Stopwatch.StartNew();
sw.Start();

string inputFilePath = "input.txt";
string outputFilePath = "output.txt";

try
{
    var res = (IEnumerable<KeyValuePair<string, int>>?)typeof(Counter)
                ?.GetMethod("Count", BindingFlags.NonPublic | BindingFlags.Instance)
                ?.Invoke(new Counter(), new object[] { File.ReadLines(inputFilePath) });

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
catch (Exception ex)
{
    Console.WriteLine($"Error: {ex.Message}");
}

sw.Stop();
Console.WriteLine($"Готово. {sw.ElapsedMilliseconds} ms");
Console.ReadKey();
using System.Collections.Concurrent;
using System.Diagnostics;
using System.Text.RegularExpressions;

Stopwatch sw = Stopwatch.StartNew();
sw.Start();

string inputFilePath = "input.txt";
string outputFilePath = "output.txt";
Regex wordRegex = new Regex(@"\b[\w'-]+\b", RegexOptions.Compiled);
var wordCount = new ConcurrentDictionary<string, int>();
int degreeOfParallelism = Environment.ProcessorCount;

try
{
    File.ReadLines(inputFilePath).AsParallel().WithDegreeOfParallelism(degreeOfParallelism).ForAll(line =>
    {
        var words = wordRegex.Matches(line)
        .Cast<Match>()
        .Select(m => m.Value.ToLowerInvariant());

        foreach (string word in words)
        {
            wordCount.AddOrUpdate(word, 1, (key, value) => value + 1);
        }
    });

    var sortedWords = wordCount.OrderByDescending(pair => pair.Value);

    using (var writer = new StreamWriter(outputFilePath))
    {
        foreach (var pair in sortedWords)
        {
            writer.WriteLine($"{pair.Key}: {pair.Value}");
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
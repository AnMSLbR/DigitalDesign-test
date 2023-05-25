using System.Diagnostics;
using System.Reflection;
using DDCounter;

// Поскольку в изначальном решении я использовал PLINQ и в задании с рефлексией вызывал эту же реализацию в приватном виде, то
// в данном задании, чтобы больше соответствовать условию, и учесть возможные временные затраты на вызов приватного метода с помощью рефлексии,
// я дописал однопоточную реализацию и сравнил оба варианта как в приватном, так и публичном видах.
//
//  Время независимого выполнения методов:
//
//    ms   | PrivateCount | PublicCount| PrivateCountParallel | PublicCountParallel |
//-----------------------------------------------------------------------------------
//    1.   |     282      |     375    |         266          |         290         |
//    2.   |     225      |     342    |         336          |         274         |
//    3.   |     319      |     215    |         266          |         238         |
//    4.   |     296      |     299    |         264          |         358         |
//    5.   |     348      |     334    |         331          |         263         |
//-----------------------------------------------------------------------------------
//   avg   |     294      |     313    |        292.6         |        284.6        |

string inputFilePath = "input.txt";
Counter counter = new Counter();
Stopwatch sw = Stopwatch.StartNew();

try
{
    sw.Start();
    var res = (IEnumerable<KeyValuePair<string, int>>?)typeof(Counter)
                ?.GetMethod("PrivateCount", BindingFlags.NonPublic | BindingFlags.Instance)
                ?.Invoke(counter, new object[] { File.ReadLines(inputFilePath) });
    WriteFile(res, "outputPrivateCount.txt");
    sw.Stop();
    Console.WriteLine($"PrivateCount: {sw.ElapsedMilliseconds} ms");
    sw.Reset();


    sw.Start();
    res = counter.PublicCount(File.ReadLines(inputFilePath));
    WriteFile(res, "outputPublicCount.txt");
    sw.Stop();
    Console.WriteLine($"PublicCount: {sw.ElapsedMilliseconds} ms");
    sw.Reset();


    sw.Start();
    res = (IEnumerable<KeyValuePair<string, int>>?)typeof(Counter)
                ?.GetMethod("PrivateCountParallel", BindingFlags.NonPublic | BindingFlags.Instance)
                ?.Invoke(counter, new object[] { File.ReadLines(inputFilePath) });
    WriteFile(res, "outputPrivateCountParallel.txt");
    sw.Stop();
    Console.WriteLine($"PrivateCountParallel: {sw.ElapsedMilliseconds} ms");
    sw.Reset();


    sw.Start();
    res = counter.PublicCountParallel(File.ReadLines(inputFilePath));
    WriteFile(res, "outputPublicCountParallel.txt");
    sw.Stop();
    Console.WriteLine($"PublicCountParallel: {sw.ElapsedMilliseconds} ms");
    sw.Reset();
}
catch (Exception ex)
{
    Console.WriteLine($"Error: {ex.Message}");
}

void WriteFile(IEnumerable<KeyValuePair<string, int>>? text, string outputPath)
{
    using (var writer = new StreamWriter(outputPath))
    {
        if (text != null)
        {
            foreach (var pair in text)
            {
                writer.WriteLine($"{pair.Key}: {pair.Value}");
            }
        }
    }
}

Console.ReadKey();
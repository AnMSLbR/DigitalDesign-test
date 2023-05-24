using System.Collections.Concurrent;
using System.Linq;
using System.Text.RegularExpressions;

namespace DDCounter
{
    public class Counter
    {
        Regex _wordRegex = new Regex(@"\b[\w'-]+\b", RegexOptions.Compiled);
        ConcurrentDictionary<string, int> _wordCount = new ConcurrentDictionary<string, int>();
        int _degreeOfParallelism = Environment.ProcessorCount;

        private IEnumerable<KeyValuePair<string, int>> Count(IEnumerable<string> text)
        {
            try
            {
                text.AsParallel().WithDegreeOfParallelism(_degreeOfParallelism).ForAll(line =>
                {
                    var words = _wordRegex.Matches(line)
                    .Cast<Match>()
                    .Select(m => m.Value.ToLowerInvariant());

                    foreach (string word in words)
                    {
                        _wordCount.AddOrUpdate(word, 1, (key, value) => value + 1);
                    }
                });

                return _wordCount.OrderByDescending(pair => pair.Value).ToList<KeyValuePair<string, int>>();

            }
            catch (Exception)
            {
                throw;
            }
        }
    }
}
using System.Collections.Concurrent;
using System.Linq;
using System.Text.RegularExpressions;

namespace DDCounter
{
    public class Counter
    {
        // Поскольку в изначальном решении я использовал PLINQ и в задании с рефлексией вызывал эту же реализацию в приватном виде, то
        // в данном задании, чтобы больше соответствовать условию, и учесть возможные временные затраты на вызов приватного метода с помощью рефлексии,
        // я дописал однопоточную реализацию и сравнил оба варианта как в приватном, так и публичном видах.
        
        Regex _wordRegex = new Regex(@"\b[\w'-]+\b", RegexOptions.Compiled);
        int _degreeOfParallelism = Environment.ProcessorCount;

        private IEnumerable<KeyValuePair<string, int>> PrivateCount(IEnumerable<string> text)
        {
            ConcurrentDictionary<string, int> wordCount = new ConcurrentDictionary<string, int>();
            try
            {
                foreach (var line in text)
                {
                    var words = _wordRegex.Matches(line)
                                          .Cast<Match>()
                                          .Select(m => m.Value.ToLowerInvariant());

                    foreach (string word in words)
                    {
                        wordCount.AddOrUpdate(word, 1, (key, value) => value + 1);
                    }
                }
                return wordCount.OrderByDescending(pair => pair.Value).ToList<KeyValuePair<string, int>>();
            }
            catch (Exception) { throw; }
        }

        public IEnumerable<KeyValuePair<string, int>> PublicCount(IEnumerable<string> text)
        {
            ConcurrentDictionary<string, int> wordCount = new ConcurrentDictionary<string, int>();
            try
            {
                foreach (var line in text)
                {
                    var words = _wordRegex.Matches(line)
                                          .Cast<Match>()
                                          .Select(m => m.Value.ToLowerInvariant());

                    foreach (string word in words)
                    {
                        wordCount.AddOrUpdate(word, 1, (key, value) => value + 1);
                    }
                }
                return wordCount.OrderByDescending(pair => pair.Value).ToList<KeyValuePair<string, int>>();
            }
            catch (Exception) { throw; }
        }

        private IEnumerable<KeyValuePair<string, int>> PrivateCountParallel(IEnumerable<string> text)
        {
            ConcurrentDictionary<string, int> wordCount = new ConcurrentDictionary<string, int>();
            try
            {
                text.AsParallel().WithDegreeOfParallelism(_degreeOfParallelism).ForAll(line =>
                {
                    var words = _wordRegex.Matches(line)
                                          .Cast<Match>()
                                          .Select(m => m.Value.ToLowerInvariant());

                    foreach (string word in words)
                    {
                        wordCount.AddOrUpdate(word, 1, (key, value) => value + 1);
                    }
                });
                return wordCount.OrderByDescending(pair => pair.Value).ToList<KeyValuePair<string, int>>();
            }
            catch (Exception) { throw; }
        }

        public IEnumerable<KeyValuePair<string, int>> PublicCountParallel(IEnumerable<string> text)
        {
            ConcurrentDictionary<string, int> wordCount = new ConcurrentDictionary<string, int>();
            try
            {
                text.AsParallel().WithDegreeOfParallelism(_degreeOfParallelism).ForAll(line =>
                {
                    var words = _wordRegex.Matches(line)
                                          .Cast<Match>()
                                          .Select(m => m.Value.ToLowerInvariant());

                    foreach (string word in words)
                    {
                        wordCount.AddOrUpdate(word, 1, (key, value) => value + 1);
                    }
                });
                return wordCount.OrderByDescending(pair => pair.Value).ToList<KeyValuePair<string, int>>();
            }
            catch (Exception) { throw; }
        }

    }
}

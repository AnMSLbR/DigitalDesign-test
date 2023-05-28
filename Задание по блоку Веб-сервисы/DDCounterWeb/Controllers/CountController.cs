using Microsoft.AspNetCore.Mvc;
using DDCounter;

namespace DDCounterWeb.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class CountController : Controller
    {
        Counter _counter;

        public CountController()
        {
            _counter = new Counter();
        }


        [HttpPost]
        public ActionResult Count(IEnumerable<string> text)
        {
            return Json(_counter.PublicCountParallel(text));
        }
    }
}
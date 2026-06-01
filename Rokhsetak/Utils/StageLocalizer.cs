using Microsoft.Extensions.Localization;
using Rokhsetak.Resources;

namespace Rokhsetak.Utils
{
    public class StageLocalizer
    {
        private readonly IStringLocalizer<Resources.SharedResourceMarker> _localizer;

        public StageLocalizer(IStringLocalizer<Resources.SharedResourceMarker> localizer)
        {
            _localizer = localizer;
        }

        public string Localize(string stage)
        {
            return _localizer[$"Stage_{stage}"];
        }
    }
}

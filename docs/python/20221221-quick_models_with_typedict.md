# Quick Models with TypedDict

A significant amount of work I do in a day includes working with API response
data. For a while I would take one of two routes with this returned data for use
in the code. For the quick-and-dirty, I would return a `dict[str, Any]`
annotation and let fate guide my indexes. For something more structured I would
turn to `dataclass` or `NamedTuple` to create a stronger model object of the
data.

They all have their trade-offs. The vague `dict[str, Any]` is fast to build with
but more than a nightmare for longevity. The next dev, or even future me, is
required to reference the external API contract and there is no annotation
safety from `mypy`. Certainly less work up-front with more work the longer the
code lives.

The `dataclass` or `NamedTuple` give the advantage of annotation safety with
`mypy` as the cost of longer dev time. Loading them with data from the returned
JSON usually needs a constructor method of sorts. If there are nested objects
the construction process becomes more complex. More work up-front but less work
to maintain over time.

The middle-ground I discovered today is the `TypedDict`. It provides that
quick-and-dirty prototyping speed that I adore Python for. In addition, it gives
`mypy` some much needed context for ensuring type-safety in the code.

As an example situation; let us set about the task of confirming if a twitch
channel is live or not. The API response for the `/streams` endpoint used to
confirm this is rather verbose. There is a lot of information that isn't needed
and the script only needs to be lightweight. The response is simple, with no
nested objects, for brevity.

The response expected looks like [this](https://dev.twitch.tv/docs/api/reference#get-streams):

``` json title="/helix/streams endpoint response"
    "data": [
        {
            "id": "41375541868",
            "user_id": "459331509",
            "user_login": "auronplay",
            "user_name": "auronplay",
            "game_id": "494131",
            "game_name": "Little Nightmares",
            "type": "live",
            "title": "hablamos y le damos a Little Nightmares 1",
            "viewer_count": 78365,
            "started_at": "2021-03-10T15:04:21Z",
            "language": "es",
            "thumbnail_url": "https://static-cdn.jtvnw.net/previews-ttv/live_user_auronplay-{width}x{height}.jpg",
            "tag_ids": [
                "d4bb9c58-2141-4881-bcdc-3fe0505457d1"
            ],
            "is_mature": false
        },
        ...
    ],
    "pagination": {
        "cursor": "eyJiIjp7IkN1cnNvciI6ImV5SnpJam8zT0RNMk5TNDBORFF4TlRjMU1UY3hOU3dpWkNJNlptRnNjMlVzSW5RaU9uUnlkV1Y5In0sImEiOnsiQ3Vyc29yIjoiZXlKeklqb3hOVGs0TkM0MU56RXhNekExTVRZNU1ESXNJbVFpT21aaGJITmxMQ0owSWpwMGNuVmxmUT09In19"
    }
}
```

For the purpose of the script, we only care about a few of the key-values in
this response so that is all we will model. This does exploit the default `Any`
return type of our http client, but in a good way. Because the return is `Any`
we can annotate our return as a `TypedDict` class and everything will be happy.
Now, if we mess up or the response changes there will still be a `KeyError` but
this happens in other methods too.

The model and simple http call look something like this:

``` py title="check_stream.py" hl_lines="1-8 16"
class Stream(TypedDict):
    """Stream object."""

    user_name: str
    game_name: str
    title: str
    viewer_count: int
    started_at: str


def get_streams_by_user_name(user_name: str) -> list[Stream]: # (1)!
    """Get stream by user name, do not paginate."""
    url = f"https://api.twitch.tv/helix/streams?user_login={user_name}?type=live?first=20"
    headers = {"Client-ID": CLIENT_ID, "Authorization": f"Bearer {ACCESS_TOKEN}"}
    response = httpx.get(url, headers=headers)
    return response.json()["data"] # (2)!
```

1. This return type works here because `response.json()` returns `Any`.
2. There is more data than the `TypedDict` defines but that is okay, we can
   always expand the `Stream` class if more data is needed.

The `TypedDict` does not allow for default values. It also do not allow extra
methods to be declared, unlike `NamedTuple` and `dataclass`.  However, it does
give the return value a shape that can be checked downstream. As a middle-ground
between a raw `list[dict[str, Any]]` or a full model, the `TypedDict` offers a
lot of value.

This example lays out that we will be returning a list of `Stream` object and
these objects have, at least, the five keys available. Editors with
auto-complete options should even prompt the dev to select from the available
options. As an added bonus; `mypy` is quite verbose in detecting key errors and
will even suggest corrections!

!!! error "mypy check_stream.py"
    check_stream.py:71: error: TypedDict "Stream" has no key "gamename"  [typeddict-item]

    check_stream.py:71: note: Did you mean "game_name"?


The completed script is still lightweight and fast to develop on. This is
critical, in my opinion, for getting the best value out of my time. As the [xkcd
comic](https://xkcd.com/353/) suggests; just fly!

-- Preocts 🥚

---

``` py title="check_stream.py"
"""Check the status of a streamer on TwitchTV"""
from typing import TypedDict

import httpx

CLIENT_ID = ""
ACCESS_TOKEN = ""

class Stream(TypedDict):
    """Stream object."""

    user_name: str
    game_name: str
    title: str
    viewer_count: int
    started_at: str


def get_streams_by_user_name(user_name: str) -> list[Stream]:
    """Get stream by user name, do not paginate."""
    url = f"https://api.twitch.tv/helix/streams?user_login={user_name}?type=live?first=20"
    headers = {"Client-ID": CLIENT_ID, "Authorization": f"Bearer {ACCESS_TOKEN}"}
    response = httpx.get(url, headers=headers)
    return response.json()["data"]

def get_live_stream(user_name: str) -> Stream | None:
    """Get stream data from user name, return None if not live."""
    for stream in get_streams_by_user_name(user_name):
        if stream["type"] == "live" and stream["user_name"] == user_name:
            return stream


if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage: python check_stream.py <user_name>")
        raise SystemExit(1)
    user_name = sys.argv[1]
    if data := get_live_data(user_name):
        print(f"{data['user_name']} is live with {data['viewer_count']} viewers")
        print(f"Title: {data['title']}")
        print(f"Playing {data['game_name']}")
    else:
        print(f"{user_name} is not live.")
```

# Function Protocols

I was working on a [side project](http://github.com/Preocts/braghook) when I
came across the situation that I had multiple if-statements handling multiple
function calls. The only difference between the if-statements was which function
was being called. The functions all behaved the same way. Normally I would have
simply used an abstract-base class, a loop, and a sequence of calls to make.
However in this situation I was faced with a new unknown; I wasn't using classes
at all. I'd built the entire project with functions. No place for an
abstract-base class.

I could have just made the loop and the calls with a vague `Callable`
annotation while `# type: ignore`'ing any complaints. In fact, that was my first
solution but it wasn't ideal so I looked for alternatives.

I had used `Protocol` classes in the past but only when working with classes so I
was momentarily stumped. "How do I use a class to indicate the protocol is for a
functoin?" It turns out, the solution is the `typing.Protocol` in combination of
with the `__call__()` dunder method. A solution so obvious that I overlooked it
completely until it was pointed out to me.

Let me set the stage:

There are several functions that are building a webhook payload:

```py
def build_discord_webhook(author: str, author_icon: str, content: str) -> dict[str, Any]:
    ...

def build_slack_webhook(author: str, author_icon: str, content: str) -> dict[str, Any]:
    ...

def build_msteams_webhook(author: str, author_icon: str, content: str) -> dict[str, Any]:
    ...
```

In order to use these functions the process needed to pull a value from the
application config, build the webhook, and send it off to the correct URI.

That process looked like this to start:

```py
def send_webhooks(config: Config, content: str) -> None:
    """Send webhooks to all defined targets."""

    if config.discord_webhook:
        payload = build_discord_webhook(config.author, config.author_icon, content)
        post_message(url=config.discord_webhook, data=payload)

    if config.slack_webhook:
        payload = build_slack_webhook(config.author, config.author_icon, content)
        post_message(url=config.discord_webhook, data=payload)

    if config.msteams_webhook:
        payload = build_msteams_webhook(config.author, config.author_icon, content)
        post_message(url=config.discord_webhook, data=payload)
```

It was clean enough, but lacked an ease of scaling. Making additions required
changing code that already worked. The testing for it became more complicated
with each new webhook. Another if-statement was another branch to test for. To
DRY the code out a little and give it more flexibility I started with this:

1. Extract the function being called and align it as a callback with the config
   field being checked
2. Loop through the key: pair values of the new dict
3. Lookup the config value and, if valid, use the callback function to build the
   payload
4. Send the payload!

```py
# Define the builders here, used in the main script
# NOTE: The key is the config field that defines the url
# NOTE: The value is the function that builds the message
BUILDERS: dict[str, Callable[[...], dict[str, Any]]] = {
    "discord_webhook": build_discord_webhook,
    "slack_webhook": build_slack_webhook,
    "msteams_webhook": build_msteams_webhook,
}

def send_message(config: Config, content: str) -> None:
    """Send the message to any webhooks defined in config."""
    for config_field, builder in BUILDERS.items():
        url = getattr(config, config_field)
        if not url:
            continue  # Skip if the webhook is not defined in config
        data = builder(
            author=config.author,
            author_icon=config.author_icon,
            content=content,
        )
        post_message(url=url, data=data)
```

Updating the `BUILDERS` dictionary as more targets were added was now a simple
change to the configuration. There was no longer the need to change existing
code with the addition of a webhook. The tests went from one test for each
webhook to just one test with a mock config that has at least one webhook
target.

It was almost exactly what I wanted except for `mypy` being unable to catch
future me, or the next dev, from not following the contract for the builder
functions. To be ideal, the type checking should fail if an unexpected argument
was added or removed. This is where the `Protocol` stepped in with its ability
to define the shape of the object.

```py
class Builder(Protocol):
    """Protocol for the message builder."""

    def __call__(self, author: str, author_icon: str, content: str) -> dict[str, Any]:
        ...

# Define the builders here, used in the main script
# NOTE: The key is the config field that defines the url
# NOTE: The value is the function that builds the message
BUILDERS: dict[str, Builder] = {
    "discord_webhook": build_discord_webhook,
    "slack_webhook": build_slack_webhook,
    "msteams_webhook": build_msteams_webhook,
}
```

With the change, the `BUILDERS` callback values properly failed if they did not match the expected form:

```py
src/braghook/webhook_builder.py:189: error: Dict entry 1 has incompatible type "str": "Callable[[str, str, str, str], Dict[str, Any]]"; expected "str": "Builder"  [dict-item]
```

In conclusion, I learned that `Protocol` is just as useful with dependency
inversion with functions as it is with classes and methods. It makes sense, even
if I had to be guided to the answer.  After all, everything is just an `object`;
isn't it?

-- Preocts 🥚

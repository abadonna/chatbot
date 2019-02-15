# chatbot
Chatbot for Lua &amp; [Defold](https://www.defold.com) using the approach similar to [PullString](https://docs.pullstring.com/docs/).

## Installation
Add this project as a [Defold library dependency](http://www.defold.com/manuals/libraries/).
Open your game.project file and in the dependencies field under project add:
https://github.com/abadonna/chatbot/archive/master.zip

## Usage
This library use same entities as [PullString](https://docs.pullstring.com/docs/), so I recommend to check [PullString](https://docs.pullstring.com/docs/) docs first.
What features are supported:
* Rules
* Intents
* Contractions
* Fallbacks
* Conditions
* State
* Interjections and Segues
* Pattern Matching for numbers
* Polarity detection

Chat data is defined via lua modules.

```
chat = require "chatbot.bot"
data = require "sample"
bot = chat.init(data)
....
answer, segue = bot.say("optional input")
```

## API
### init(data, library)
Sample chat will be loaded if **data** is nil, build-in intent library will be used if **library** is nil

Returns bot object

### bot.say(input)
return bot's answer and segue (optional)

## Reference
TODO

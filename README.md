# storyline

**[WIP] This mod is still just a rough draft, and is nowhere close to being functional**

`storyline` is a modding API which allows mods/games to add a simple linear
storyline, on a per-player basis.

`storyline` provides two important components to mods to help develop a storyline:

- **Events**: These are the fundamental units of the storyline.
- **Scripts**: These define a sequence of events, and trigger them one-by-one.

## API Documentation

### Structures

#### Event definition

```lua
{
	description = "",
	on_run = function(name)
}
```

An event definition consists of the event's description, and its `on_run`
callback. The `on_run` callback is mandatory, and can be used to set-up
the game environment, for example.

#### Script definition

```lua
{
	events = { event1, event2, event3 },
	on_begin = function(name),
	on_end = function(name),
	on_trigger_event = function(name)
}
```

A script definition, among others, consists of a list of event IDs, which is
the heart of this mod. The other fields are the `on_begin`, `on_end`, and
`on_trigger_event` callbacks.

### Methods

#### `storyline.load()`

- Loads data from mod storage into memory.

#### `storyline.save()`

- Saves data from memory into mod storage.

#### `storyline.register_event(<Event definition>)`

- Event registration function; takes an event definition table as a parameter.
- Throws an error if the event definition is invalid.
- Returns the ID of the registered event.

#### `storyline.get_event(<Event ID>)`

- Returns the event definition table corresponding to the given event ID.

#### `storyline.set_script(<Player name>, <Script definition>)`

- Script-setting function; takes a player name and a script definition table
  as parameters.
- Throws an error if the script definition is invalid.

#### `storyline.get_script(<Player name>)`

- Returns the script definition (or `nil`) of the storyline of a given player.

#### `storyline.begin_script(<Player name>)`

- Commences the script of the given player's storyline. Initializing the script
  has been separated from setting the script, to allow deferring the execution
  of the script if required.
- Runs the script's `on_begin` callback if it exists, and then the first event's
  `on_run` is invoked.

#### `storyline.finish_event(<Player name>)`

- Sets the current event of the given player's storyline as complete.
- Runs the script's `on_trigger_event` callback if it exists, and then executes
  the next event's `on_run` callback.
- Note: **It's the downstream mod's responsibility to track the progress of
  player's events**. As `storyline` has no knowledge of event progress, the
  downstream mod must call `storyline.finish_event` to notify `storyline`
  that an event has been completed.

### Callbacks

#### `on_begin(<Player name>)` [Script]

Runs when a script is initialized during a call to `storyline.begin_script`.

#### `on_trigger_event(<Player name>)` [Script]

Runs when an event is complete, just before the new event's `on_run` is executed.

#### `on_end(<Player name>)` [Script]

Runs when a script is over.

#### `on_run(<Player name>)` [Event] (Mandatory)

Executed after `on_trigger_event`, when the script triggers an event.

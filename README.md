# Kochava Attribution plugin for GameClosure Devkit

Please get the Kochava App GUID from the dashboard.

## Usage

Include this module as a dependency in your game's manifest file.

```
devkit install https://github.com/hashcube/kochava.git
```

Then add `kochavaAppGUID` to iOS or android section.

```
"ios": {
    "kochavaAppGUID": "xxx"
},

OR

"android": {
    "kochavaAppGUID": "xxx"
},


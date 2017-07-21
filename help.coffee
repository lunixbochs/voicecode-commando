pack = Packages.register
  name: "help"
  description: "adding help mode for voicecode"

pack.settings
  win:
    backgroundColor: '#FFFFFFFF'

subscribe 'currentApplicationChanged', ->
  win = windowController.get('commandSheet')
  win?.reload()

subscribe 'chainWillExecute', (chain)->
  if chain[0].command != 'help:commando'
    win = windowController.get('commandSheet')
    win?.hide()
  if chain[0].command != 'help:command-keys'
    win = windowController.get('commandKeys')
    win?.hide()

pack.commands
  "commando":
    spoken: "commando"
    description: "toggle command help"
    continuous: false
    enabled: true
    action: (input) ->
      _name = 'commandSheet'
      win = windowController.get(_name)
      if win?
        if win.isVisible()
          win.hide()
        else
          win.showInactive()
      else
        win = windowController.new _name,
          x: 0
          y: 0
          width: 850
          height: 600
          hasShadow: false
          focusable: false
          alwaysOnTop: true
          transparent: true
          frame: false
          toolbar: false
          show: false
          autoHideMenuBar: true
          backgroundColor: pack.settings().win.backgroundColor

        win.loadURL("http://localhost:6001")
        win.setIgnoreMouseEvents true
        win.maximize()
        win.showInactive()
  "command-keys":
    spoken: "key lime"
    description: "toggle keyboard help"
    continuous: false
    enabled: true
    action: (input) ->
      _name = 'commandKeys'
      win = windowController.get(_name)
      if win?
        if win.isVisible()
          win.hide()
        else
          win.showInactive()
      else
        win = windowController.new _name,
          x: 0
          y: 0
          width: 850
          height: 600
          hasShadow: false
          focusable: false
          alwaysOnTop: true
          transparent: true
          frame: false
          toolbar: false
          show: false
          autoHideMenuBar: true
          backgroundColor: pack.settings().win.backgroundColor

        win.loadURL("http://localhost:6001/static/keyboard.svg", {"extraHeaders" : "pragma: no-cache\n"})
        win.setIgnoreMouseEvents true
        win.maximize()
        win.showInactive()

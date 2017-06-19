pack = Packages.register
  name: "help"
  description: "adding help mode for voicecode"

pack.settings
  win:
    backgroundColor: '#FFFFFFFF'

subscribe 'currentApplicationChanged', ->
  win = windowController.get('commandSheet')
  if win?
    win.reload()

subscribe 'chainWillExecute', ->
  win = windowController.get('commandSheet')
  if win?
    win.hide()

pack.commands
  "commando": 
    spoken: "commando"
    description: "toggle command help"
    continuous: false
    enabled: true
    # grammarType: "textCapture"
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
        # win.openDevTools()
        win.setIgnoreMouseEvents true
        win.maximize()
        win.showInactive()

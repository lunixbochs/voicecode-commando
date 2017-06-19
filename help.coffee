pack = Packages.register
  name: "help window"
  description: "adding help mode for voicecode"

pack.settings
  win:
    backgroundColor: '#FFFFFFFF'

pack.commands
  "helper": 
    spoken: "helper"
    description: "open command help"
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
          win.reload()
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

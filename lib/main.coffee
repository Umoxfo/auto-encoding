{CompositeDisposable} = require 'atom'
AutoEncoding = require './auto-encoding'

module.exports = Main =
  subscriptions: null
  enc: null

  config:
    alwaysAutoDetect:
      title: 'Always auto detect'
      description: 'enabled from startup'
      type: 'boolean'
      default: true
    # critical error word [ ✓ ]
    warningWindows1252:
      title: 'Show warning message when change encoding to "windows1252".'
      type: 'boolean'
      default: false
    # divide buffer option
    divideSize:
      title: 'The number of the consideration.'
      description: 'divide size of buffer'
      type: 'number'
      default: 1
      minimum: 1

  activate: ->

    atom.commands.add 'atom-workspace', 'auto-encoding:toggle': =>
      @toggle()

    # always auto-detect
    if atom.config.get 'auto-encoding.alwaysAutoDetect'
      @enabled()

  enabled: ->
    @subscriptions ?= new CompositeDisposable
    @enc ?= new AutoEncoding()

    # event: open file
    @subscriptions.add atom.workspace.onDidOpen => @enc.fire()
    # event: changed active pane
    @subscriptions.add atom.workspace.onDidChangeActivePaneItem => @enc.fire()

  disabled: ->
    @subscriptions?.dispose()
    @subscriptions = null
    @enc = null

  toggle: ->
    if not @subscriptions?
      @enabled()
      atom.notifications?.addSuccess 'auto-encoding: on'
    else
      @disabled()
      atom.notifications?.addSuccess 'auto-encoding: off'

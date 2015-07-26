class Bindings._3DCartCredentialTester extends Bindings._3DCart
  # override constructor to bypass Credential object requirement
  constructor: (options) ->
    _.extend(@, options)

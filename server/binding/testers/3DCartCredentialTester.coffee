class Bindings["3DCartCredentialTester"] extends Bindings["3DCart"]
  # override constructor to bypass Credential object requirement
  constructor: (options) ->
    _.extend(@, options)

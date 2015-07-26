class Bindings._3DCart extends Bindings.Request
  request: (options) ->
    _.defaults(options,
      baseUrl: "https://apirest.3dcart.com/3dCartWebAPI/v1"
      json: true
      headers: {}
    )
    _.defaults(options.headers,
      SecureUrl: @credential.details.url
      PrivateKey: @credential.details.privateKey
      Token: @credential.details.token
    )
    super(options)

  getOrders: (params) ->
    @request(
      method: "GET"
      url: "/Orders"
      qs: params
    )

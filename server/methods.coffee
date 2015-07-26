Meteor.methods
  save_3DCartCredential: secure (stepId, url, token, privateKey) ->
    try
      binding = new Bindings._3DCartCredentialTester
        credential:
          details:
            url: url
            token: token
            privateKey: privateKey

      future = new Future()
      binding.getOrders()
      .spread (response, body) -> future.return(body)
      .catch (error) -> future.throw(error)
      response = future.wait()

      avatarValues =
        api: "_3DCart"
        uid: token
        name: url
        userId: @userId
      credentialValues =
        api: "_3DCart"
        scopes: ["*"]
        details:
          url: url
          token: token
          privateKey: privateKey
        updatedAt: new Date()
        userId: @userId

      avatarId = Foreach.saveCredential(avatarValues, credentialValues)
      Issues.remove({stepId: stepId, userId: @userId})
      avatarId
    catch e
      now = new Date()
      error = createError(e)
      data = {}
      if error.error is "Request:failed"
        if error.details.statusCode == 401
          data = {error: "Unauthorized", reason: "Invalid credentials"}
        else
          data = {error: "3DCart server error", reason: "Invalid 3DCart Account Data. Please try again."}
      else
        data = {}

      Issues.insert(_.extend(_.extend(error,
          stepId: stepId
          userId: @userId
          createdAt: now
          updatedAt: now),
        data
      ))
      throw error

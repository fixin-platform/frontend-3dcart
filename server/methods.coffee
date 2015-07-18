Meteor.methods
  save3DCartCredential: secure (stepId, url, token, privateKey) ->
    try
      binding = new Bindings["3DCartCredentialTester"]
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
        api: "3DCart"
        uid: token
        name: url
        userId: @userId
      credentialValues =
        api: "3DCart"
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
      if (error.error == "Request:failed")
        if error.details.statusCode == 401
          data = {error: "Unauthorized", reason: "Invalid credentials"}
        else
          data = {error: "3DCart server error", reason: "Invalid 3DCart Account Data. Try again."}
      else
        data = {
          error: "Internal server error",
          reason: "An error occurred during request. Please report about the problem if you have no idea how to fix it."
        }

      Issues.insert(_.extend(_.extend(error,
          stepId: stepId
          userId: @userId
          createdAt: now
          updatedAt: now),
        data
      ))
      throw error

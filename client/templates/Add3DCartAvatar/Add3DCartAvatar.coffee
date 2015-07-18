Template.Add3DCartAvatar.helpers
#  helper: ->
  options: ->
#    if AvatarSubscriptionIsInitialized.equals(@api, true)
    Avatars.find({api: @api})

Template.Add3DCartAvatar.onRendered ->
  step = @data
  @$("input").first().focus()
  @$("form").formValidation
    framework: 'bootstrap'
    live: "disabled"
    fields:
      url:
        validators:
          notEmpty:
            message: "Please enter you #{step.api} Url"
      token:
        validators:
          notEmpty:
            message: "Please enter your #{step.api} API Token"
      privateKey:
        validators:
          notEmpty:
            message: "Please enter your #{step.api} API Private Key"
  .on "success.form.fv", grab encapsulate (event) ->
    $button = $(event.currentTarget)
    $button.find(".ready").hide()
    $button.find(".loading").show()

    $form = $(event.currentTarget).closest("form")
    values = {}
    for field in $form.serializeArray()
      values[field.name] = field.value

    Meteor.call "save3DCartCredential", step._id, values.url, values.token, values.privateKey, (error, avatarId) ->
      $button.find(".ready").show()
      $button.find(".loading").hide()

      step.execute({avatarId: avatarId}) unless error


Template.Add3DCartAvatar.events
#  "click .selector": (event, template) ->

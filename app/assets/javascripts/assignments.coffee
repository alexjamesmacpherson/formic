ready = ->
  $('.assignment-head').click (e) ->
    $(this).parent().toggleClass('no-show')

$(document).on 'turbolinks:load', ready
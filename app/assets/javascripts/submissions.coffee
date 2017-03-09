ready = ->
  $('.submission-form').click (e) ->
    e.stopPropagation()

  $('.submitted').click (e) ->
    $(this).children('.submission-form').toggleClass('no-show')

  $('.edit_submission').submit ->
    $(this).parent().siblings('.submission-status').html('check_box')
    $(this).parent().toggleClass('no-show')

$(document).on 'turbolinks:load', ready
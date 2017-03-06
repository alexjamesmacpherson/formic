ready = ->
  $('.unread-notification').click (e) ->
    $(this).children('.list-record').addClass('read-notification')
    $(this).removeClass('unread-notification')
    update_notification_count()

  $('.read-all').click (e) ->
    $('.unread-notification').children('.list-record')
        .addClass('read-notification')
    $('.unread-notification').removeClass('unread-notification')
    update_notification_count()

  update_notification_count = ->
    if $('.unread-notification').length > 9
      $('.notifications').html('9+')
    else if $('.unread-notification').length == 0
      $('.notifications').css('display', 'none')
    else
      $('.notifications').html($('.unread-notification').length)

$(document).on 'turbolinks:load', ready
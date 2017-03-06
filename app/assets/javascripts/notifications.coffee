# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

ready = ->
  $('.unread-notification').click (e) ->
    $(this).children('.list-record').addClass('read-notification')
    $(this).removeClass('unread-notification')
    if $('.unread-notification').length > 9
      $('.notification-bubble').html('9+')
    else if $('.unread-notification').length == 0
      $('.notification-bubble').css('display', 'none')
    else
      $('.notification-bubble').html($('.unread-notification').length)

  $('.read-all').click (e) ->
    $('.unread-notification').children('.list-record').addClass('read-notification')
    $('.unread-notification').removeClass('unread-notification')
    $('.notification-bubble').css('display', 'none')

$(document).on 'turbolinks:load', ready
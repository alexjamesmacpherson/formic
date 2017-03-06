# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

ready = ->
  $('.cont-side').mouseup (e) ->
    $('.notification-panel').removeClass('visible')
    $('.chats-panel').removeClass('visible')
    $('.popout-back').removeClass('visible')
    $('.conversation').removeClass('visible')

  $('.nav-button').mouseup (e) ->
    e.stopPropagation()

    $('.conversation').removeClass('visible')
    if $(this).hasClass('notification')
      setTimeout (->
        $('.notification-panel').toggleClass('visible')
      ), 1
    else
      $('.notification-panel').removeClass('visible')

    if $(this).hasClass('message')
      setTimeout (->
        $('.chats-panel').toggleClass('visible')
      ), 1
    else
      $('.chats-panel').removeClass('visible')

    setTimeout (->
      if $('.chats-panel').hasClass('visible') || $('.notification-panel').hasClass('visible')
        $('.popout-back').addClass('visible')
      else
        $('.popout-back').removeClass('visible')
    ), 1


$(document).on 'turbolinks:load', ready
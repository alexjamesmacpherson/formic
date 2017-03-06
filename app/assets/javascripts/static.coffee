# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

ready = ->
  $('.cont-side').mouseup (e) ->
    $('.notification-panel').removeClass('visible')

  $('.nav-button').mouseup (e) ->
    e.stopPropagation()
    if $(this).hasClass('notification')
      setTimeout (->
        $('.notification-panel').toggleClass('visible')
      ), 1
    else
      $('.notification-panel').removeClass('visible')

$(document).on 'turbolinks:load', ready
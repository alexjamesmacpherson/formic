# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

ready = ->
  $('.tip-text').css('visibility','hidden')

  $('.nav-button').mouseleave (e) ->
    $this = this
    setTimeout (->
      $($this).children('.tip-text').css('visibility','hidden')
    ), 500

  $('.nav-button').mouseover (e) ->
    $(this).children('.tip-text').css('visibility','visible')

$(document).on 'turbolinks:load', ready
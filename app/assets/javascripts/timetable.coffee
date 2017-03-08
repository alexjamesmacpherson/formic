ready = ->
  $('th').first().css('display','none')
  $('th').last().css('display','none')

$(document).on 'turbolinks:load', ready
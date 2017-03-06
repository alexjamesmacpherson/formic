ready = ->
  $('.unread-chat').click (e) ->
    $(this).children('.list-record').addClass('read-chat')
    $(this).removeClass('unread-chat')
    update_chat_count()

  $('.read-chats').click (e) ->
    $('.unread-chat').children('.list-record').addClass('read-chat')
    $('.unread-chat').removeClass('unread-chat')
    update_chat_count()

  update_chat_count = ->
    if $('.unread-chat').length > 9
      $('.messages').html('9+')
    else if $('.unread-chat').length == 0
      $('.messages').css('display', 'none')
    else
      $('.messages').html($('.unread-chat').length)

  $('.chat-record').click (e) ->
    id = $(this).attr('id').substr(1)
    $('#b' + id).addClass('visible')

  $('.chat-back').click (e) ->
    $(this).parent().removeClass('visible')

  $(document).on 'submit', '.message-form', (e) ->
    $this = $(this)
    new_message = $this.children('.conversation-input').val()

    if new_message.trim() == ''
      e.preventDefault()
      return

    setTimeout (->
      $this.children('.conversation-input').val('')
    ), 1

    $convbody = $this.siblings('.conversation-body')
    $convbody.append('<div class="sent-message"><div class="message-body">' + new_message + '</div></div>')
    $convbody.scrollTop($convbody[0].scrollHeight);

    id = $convbody.parent().attr('id').substr(1)
    $convrecord = $('#c' + id)
    $convrecord.children('.list-date').html('just now')
    $convrecord.children('.list-item').children('.list-subitem').html(new_message)

  $('.conversation-body').each ->
    $(this).scrollTop($(this)[0].scrollHeight);

$(document).on 'turbolinks:load', ready
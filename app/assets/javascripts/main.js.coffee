$('document').ready(() ->
  $('.js-select-item').on('click', (e) ->
    $('.js-select-group').hide(300)
    $('.js-select').hide()
    $('.js-show').removeClass('hide').show()
  )
)
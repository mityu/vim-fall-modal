augroup plugin-fall-modal
  autocmd!
  autocmd User FallPickerEnter:* call fall_modal#enter()
  autocmd User FallPickerLeave:* call fall_modal#leave()
augroup END

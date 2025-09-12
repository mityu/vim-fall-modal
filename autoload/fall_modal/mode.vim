let s:modes = {}

function fall_modal#mode#setup() abort
  call fall_modal#session#register({
    \ 'mode': '',
    \ }, {
    \ 'resume': function('s:resume'),
    \ })
  augroup fall-modal-mode-dummy-autocmd
    autocmd!
    autocmd User FallModalModeChanged:* silent
  augroup END
endfunction

function s:resume(data) abort
  call fall_modal#mode#change_mode(a:data.mode)
endfunction

function fall_modal#mode#change_mode(mode) abort
  if index(s:modes, a:mode) == -1
    echohl Error
    echomsg $'[fall-modal] Unknown mode: {a:mode}'
    echohl None
    return
  endif
  call fall_modal#event#emit($'FallModalModeChanged:{a:mode}')
endfunction

function fall_modal#mode#define(modes) abort
  let s:modes = deepcopy(a:modes)
endfunction

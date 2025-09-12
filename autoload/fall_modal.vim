let s:did_setup = v:false

function fall_modal#setup() abort
  call fall_modal#input#setup()
  call fall_modal#cursor#setup()
  call fall_modal#mapping#setup()
  augroup fall-modal-dummy-autocmd
    autocmd!
    autocmd User FallModalSetup silent
    autocmd User FallModalEnterPrompt:* silent
    autocmd User FallModalPickerLeave:* silent
  augroup END
  call fall_modal#event#emit('FallModalSetup')
endfunction

function fall_modal#enter() abort
  if !s:did_setup
    call fall_modal#setup()
    let s:did_setup = v:true
  endif

  call fall_modal#session#new_session()
  const name = matchstr(expand('<amatch>'), '^FallPickerEnter:\zs.*$')
  if name !=# ''
    " Postpone FallModalEnterPrompt event on CmdlineEnter event because it
    " seems fall.vim's default mapping is defined after this event.
    const cmd = $'call fall_modal#event#emit("FallModalEnterPrompt:{name}")'
    execute $'autocmd CmdlineEnter @ ++once {cmd}'
  endif
endfunction

function fall_modal#leave() abort
  call fall_modal#session#exit_session()
endfunction

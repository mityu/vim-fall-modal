let s:get_current_session = v:null

function s:get_current_prompt() abort
  return [getcmdline(), getcmdpos()]
endfunction

function s:set_current_prompt(prompt) abort
  " Discard CmdlineChanged event triggered by this 'setcmdline' function call
  " temporally.
  augroup fall-modal-module-input
    autocmd!
    call call('setcmdline', a:prompt)
    autocmd CmdlineChanged @ call s:throw_away_redo_stack()
  augroup END
endfunction

function s:initialize(_data) abort
  if fall_modal#session#is_empty()
    augroup fall-modal-module-input
      autocmd!
      autocmd CmdlineChanged @ call s:throw_away_redo_stack()
    augroup END
  endif
endfunction

function s:finalize(_data) abort
  if fall_modal#session#is_empty()
    augroup fall-modal-module-input
      autocmd!
    augroup END
    call fall_modal#input#set_ignore_unmapped_keys(v:false)
  endif
endfunction

function fall_modal#input#setup() abort
  let s:get_current_session = fall_modal#session#register({
    \ 'undo_stack': [],
    \ 'redo_stack': [],
    \ }, {
    \ 'initialize': function('s:initialize'),
    \ 'finalize': function('s:finalize'),
    \ })
endfunction

function fall_modal#input#push_prompt() abort
  let history = s:get_current_session()
  let history.redo_stack = []
  call add(history.undo_stack, s:get_current_prompt())
endfunction

function fall_modal#input#undo_prompt() abort
  let history = s:get_current_session()
  if empty(history.undo_stack)
    return
  endif

  let prompt = remove(history.undo_stack, -1)
  call add(history.redo_stack, s:get_current_prompt())
  call s:set_current_prompt(prompt)
endfunction

function fall_modal#input#redo_prompt() abort
  let history = s:get_current_session()
  if empty(history.redo_stack)
    return
  endif

  let prompt = remove(history.redo_stack, -1)
  call add(history.undo_stack, s:get_current_prompt())
  call s:set_current_prompt(prompt)
endfunction

function s:throw_away_redo_stack() abort
  let history = s:get_current_session()
  let history.redo_stack = []
endfunction

if has('nvim')
  function fall_modal#input#set_ignore_unmapped_keys(enable) abort
    if a:enable
      lua << trim EOF
      vim.on_key(function(key, typed)
        if key == typed then
          return ''
        end
      end, vim.api.nvim_create_namespace('fall-modal-input'))
      EOF
    else
      lua << trim EOF
      vim.on_key(nil, vim.api.nvim_create_namespace('fall-modal-input'))
      EOF
    endif
  endfunction
else
  function fall_modal#input#set_ignore_unmapped_keys(enable) abort
    if a:enable
      if !exists('#plugin-fall-modal-submode#KeyInputPre')
        augroup plugin-fall-modal-input
          autocmd KeyInputPre c call s:throw_away_unmapped_key_types()
        augroup END
      endif
    else
      augroup plugin-fall-modal-input
        autocmd! KeyInputPre
      augroup END
    endif
  endfunction

  function s:throw_away_unmapped_key_types() abort
    if v:event.typed
      let v:char = "\<Ignore>"
    endif
  endfunction
endif

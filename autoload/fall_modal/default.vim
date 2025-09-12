function fall_modal#default#setup() abort
  call fall_modal#mode#define(['normal', 'insert'])

  augroup plugin-fall-modal-default
    autocmd!
    autocmd User FallModalEnterPrompt:* call fall_modal#mode#change_mode('normal')
    autocmd User FallModalModeChanged:normal call s:setup_normal_mode()
    autocmd User FallModalModeChanged:insert call s:setup_insert_mode()

    " The following autocmds are dummy autocmds.
    autocmd User FallModalDefaultSetupPost silent
    autocmd User FallModalDefaultConfigPost:* silent
  augroup END
  doautocmd User FallModalDefaultSetupPost
endfunction

function s:setup_normal_mode() abort
  call fall_modal#mapping#clear()
  call fall_modal#cursor#set_cursor_visible(v:false)
  call fall_modal#input#set_ignore_unmapped_keys(v:true)
  cnoremap i <Cmd>call fall_modal#mode#change_mode('insert')<CR>
  cnoremap j <Plug>(fall-list-next)
  cnoremap k <Plug>(fall-list-prev)
  cnoremap gg <Plug>(fall-list-first)
  cnoremap G <Plug>(fall-list-last)
  cnoremap m <Plug>(fall-select)
  cnoremap * <Plug>(fall-select-all)
  cnoremap <CR> <Cmd>call fall#action('')<CR>
  cnoremap a <Plug>(fall-action-select)
  cnoremap ? <Plug>(fall-help)
  cnoremap <C-n> <Plug>(fall-preview-next:scroll)
  cnoremap <C-p> <Plug>(fall-preview-prev:scroll)
  cnoremap u <Cmd>call fall_modal#input#undo_prompt()<CR>
  cnoremap <C-r> <Cmd>call fall_modal#input#redo_prompt()<CR>
  cnoremap q <C-c>
  doautocmd User FallModalDefaultConfigPost:normal
endfunction

function s:setup_insert_mode() abort
  call fall_modal#mapping#clear()
  call fall_modal#cursor#set_cursor_visible(v:true)
  call fall_modal#input#set_ignore_unmapped_keys(v:false)
  call fall_modal#input#push_prompt()
  cnoremap <C-c> <Cmd>call <SID>cancel_insert()<CR>
  cnoremap <ESC> <Cmd>call fall_modal#mode#change_mode('normal')<CR>
  cnoremap <CR> <Cmd>call fall_modal#mode#change_mode('normal')<CR>
  cnoremap <C-n> <Plug>(fall-list-next)
  cnoremap <C-p> <Plug>(fall-list-prev)
  doautocmd User FallModalDefaultConfigPost:insert
endfunction

function s:cancel_insert() abort
  call fall_modal#input#undo_prompt()
  call fall_modal#mode#change_mode('normal')
endfunction

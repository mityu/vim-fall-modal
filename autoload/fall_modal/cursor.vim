let s:highlight_info = {}

function fall_modal#cursor#setup() abort
  call fall_modal#session#register(0, {
    \ 'initialize': function('s:initialize'),
    \ 'finalize': function('s:finalize'),
    \ })
endfunction

function s:initialize(_data) abort
  if fall_modal#session#is_empty()
    const groups = ['FallInputCursor']
    for group in groups
      let s:highlight_info[group] = s:get_highlight(group)
    endfor
  endif
endfunction

function s:finalize(_data) abort
  if fall_modal#session#is_empty()
    for [group, color] in items(s:highlight_info)
      call s:set_highlight(group, color)
    endfor
    let s:highlight_info = {}
  endif
endfunction

if has('nvim')
  " Get highlight information by highlight group name.
  function s:get_highlight(name) abort
    return nvim_get_hl(0, {'name': a:name, 'create': v:false})
  endfunction

  " Set highlight color.  The color definition must be what got by
  " 's:get_highlight' function.
  function s:set_highlight(name, color) abort
    call nvim_set_hl(0, a:name, extend({'force': v:true}, a:color, 'keep'))
  endfunction
else
  " Same above.
  function s:get_highlight(name) abort
    return hlget(a:name)[0]
  endfunction

  " Same above.
  function s:set_highlight(_name, color) abort
    call hlset([extend({'force': v:true}, a:color, 'keep')])
  endfunction
endif

function fall_modal#cursor#set_cursor_visible(enable) abort
  if a:enable
    call s:set_highlight('FallInputCursor', s:highlight_info['FallInputCursor'])
  else
    highlight! link FallInputCursor FallNormal
  endif
  redraw
endfunction

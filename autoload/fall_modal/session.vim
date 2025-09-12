let s:each_session_template = {}

" List of sessions. Each session item is copy of `s:each_session_template`.
let s:sessions = []

function s:nop(...) abort
endfunction

function s:uniq_id_template() abort dict
  let self.id += 1
  return self.id
endfunction

function s:gen_uniq_id_fn() abort
  return function('s:uniq_id_template', [], {'id': 0})
endfunction

let s:uniq_id = s:gen_uniq_id_fn()
let s:funcref_nop = function('s:nop')
let s:default_opts = {
  \ 'initialize': s:funcref_nop,
  \ 'finalize': s:funcref_nop,
  \ 'resume': s:funcref_nop,
  \ }

function s:get_current_session() abort
  if empty(s:sessions)
    throw '[fall-modal] Internal error: sessions is empty.'
  endif
  return s:sessions[-1]
endfunction

function fall_modal#session#register(data, opts = {}) abort
  const id = s:uniq_id()
  const opts = extend(copy(s:default_opts), a:opts, 'force')
  let s:each_session_template[id] = {
    \ 'data': deepcopy(a:data),
    \ 'opts': opts,
    \ }
  return {-> s:get_current_session()[id].data}
endfunction

" Create a new session and call user initializer functions.
" Note that user initializer functions are called after a new session is
" created but before sessions are added to session list.
function fall_modal#session#new_session() abort
  let new_session = deepcopy(s:each_session_template)
  for v in values(new_session)
    call call(v.opts.initialize, [v.data])
  endfor
  call add(s:sessions, new_session)
endfunction

" Remove the newest session and call user finalizer functions.  And then, if
" there're still some sessions, call user resumer functions.
" Note that user finalizer functions are called after the last session is
" removed from session list.
function fall_modal#session#exit_session() abort
  let last_session = remove(s:sessions, -1)
  for v in values(last_session)
    call call(v.opts.finalize, [v.data])
  endfor

  if !fall_modal#session#is_empty()
    let current_session = s:sessions[-1]
    for v in values(current_session)
      call call(v.opts.resume, [v.data])
    endfor
  endif
endfunction

" Get whether there're still some sessions or not.
function fall_modal#session#is_empty() abort
  return empty(s:sessions)
endfunction

let g:fall_modal_submodes = get(g:, 'fall_modal_submodes', {})

let s:get_current_session = v:null

function fall_modal#mapping#setup() abort
  let s:get_current_session = fall_modal#session#register({
    \ 'plugin_mappings': [],
    \ }, {
    \ 'initialize': function('s:initialize'),
    \ })
endfunction

" A predicate to check that a mapping belongs to fall.vim or this plugin.
function s:is_plugin_mapping(idx, m) abort
  return a:m.mode ==# 'c' && a:m.lhs =~? '^<Plug>(fall-'
endfunction

function s:initialize(data) abort
  let a:data.plugin_mappings = maplist()->filter(function('s:is_plugin_mapping'))
endfunction

function fall_modal#mapping#clear() abort
  const session = s:get_current_session()
  silent! cmapclear
  call foreach(session.plugin_mappings, {_, v -> mapset(v)})
endfunction

function fall_modal#event#emit(pattern) abort
  try
    execute $'doautocmd User {a:pattern}'
  catch
    const message =<< trim eval END
    Error while event {a:pattern}:
    {v:exception}
    {v:throwpoint}
    END

    echohl Error
    for line in message
      echomsg $'[fall-modal] {line}'
    endfor
    echohl None
  endtry
endfunction

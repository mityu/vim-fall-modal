# fall-modal.vim

Add modal editing functionality to [fall.vim](https://github.com/vim-fall/fall.vim).
See `doc/fall-modal.txt` for the full description of this plugin.

## Basic configuration

Setup fall-modal.vim using the built-in configuration.  Write this in your .vimrc:

```vim
augroup vimrc-fall-modal
  autocmd!
  autocmd User FallModalSetup call fall_modal#default#setup()
augroup END
```

This will introduce "normal" and "insert" mode.
The default mode is "normal" mode, in other words, fall-modal.vim will be the "normal" mode when fall.vim starts.

List of mappings in each mode is here:

- "normal" mode:

| Key     | Description |
|:--------|:------------|
| q       | Quit fall.vim. |
| i       | Change mode to "insert". |
| j       | `<Plug>(fall-list-next)` |
| k       | `<Plug>(fall-list-prev)` |
| gg      | `<Plug>(fall-list-first)` |
| G       | `<Plug>(fall-list-last)` |
| `<CR>`  | Accept item and apply default action to the item. |
| a       | `<Plug>(fall-action-select)` |
| m       | `<Plug>(fall-select)` |
| *       | `<Plug>(fall-select-all)` |
| ?       | `<Plug>(fall-help)` |
| `<C-n>` | `<Plug>(fall-preview-next:scroll)` |
| `<C-p>` | `<Plug>(fall-preview-prev:scroll)` |
| u       | Undo prompt.  `fall_modal#input#undo_prompt()` |
| `<C-r>` | Redo prompt.  `fall_modal#input#redo_prompt()` |

- "insert" mode:

| Key     | Description |
|:--------|:------------|
| `<ESC>` | Change mode to "normal". |
| `<CR>`  | Change mode to "normal". |
| `<C-c>` | Change mode to "normal" with discarding prompt changes. |
| `<C-n>` | `<Plug>(fall-list-next)` |
| `<C-p>` | `<Plug>(fall-list-prev)` |

You can also refer to `:h fall-modal-default-config` about this built-in configuration.

---
See `:h fall-modal-example` for more advanced examples.

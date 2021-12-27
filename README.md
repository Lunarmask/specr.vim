# SPECR.VIM >_

### The VIM RSpec Helper


Quickly launch your RSpec tests from wherever you're at!


**Specr** will automatically find and run the test file for the file you are editing (assuming that there is one). If Specr cannot find a test for your open file, it will run the tests for the folder you are in. Specr also allows you to copy the test path to your clipboard for quick and easy access for pasting.


Install with [Vim-Plug](https://github.com/junegunn/vim-plug)!

`Plug 'Lunarmask/specr.vim'`

---

**- Shortcuts**

`<leader>t`  Will send Specr to run your testfile.  
`<leader>ty` Will tell Specr to copy the test_path to your system clipboard.  
`<leader>to` Will tell Specr to open the test_path in a new horizontal window split.  

---

**- Expected naming scheme & Behaviour**

Specr looks for test files in the 'spec' folder ending with '_spec.rb'.

**For example:**

Running Specr while editing:  
`app/controllers/page_controller.rb`  
will try to find:  
`spec/controllers/page_controller_spec.rb`  


if `spec/controllers/page_controller_spec.rb` cannot be found, it will run the tests for `spec/controllers/` instead.

---

Has only been tested with **[Neovim](https://github.com/neovim/neovim)** .

<u>*Brought to you by Lunarmask_*</u>


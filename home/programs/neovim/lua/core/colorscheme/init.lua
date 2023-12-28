-- You probably always want to set this in your vim file
vim.opt.background = 'dark'
vim.g.colors_name = 'particle'

package.loaded['core.colorscheme.particle.particle'] = nil

-- include our theme file and pass it to lush to apply
require('lush')(require('core.colorscheme.particle.particle'))


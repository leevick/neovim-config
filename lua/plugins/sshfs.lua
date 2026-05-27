return {
  "uhs-robert/sshfs.nvim",
  lazy = false,
  opts = {
    connections = {
      sshfs_options = {
        follow_symlinks = true,
      },
    },
    hooks = {
      on_mount = {
        auto_change_to_dir = true, -- tcd to mount root so vsplit/Telescope use the mounted path
      },
    },
    ui = {
      local_picker = {
        preferred_picker = "telescope",
      },
      remote_picker = {
        preferred_picker = "telescope",
      },
    },
  },
}

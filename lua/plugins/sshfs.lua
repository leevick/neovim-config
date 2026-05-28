return {
  "uhs-robert/sshfs.nvim",
  lazy = false,
  opts = {
    connections = {
      sshfs_options = {
        follow_symlinks = true,
        -- Disable directory/attribute caching so files created remotely via
        -- SSH are visible immediately in Telescope without waiting for expiry.
        dcache_timeout = 0,
        entry_timeout = 0,
        attr_timeout = 0,
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

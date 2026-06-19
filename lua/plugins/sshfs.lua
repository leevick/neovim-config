return {
  "uhs-robert/sshfs.nvim",
  lazy = false,
  opts = {
    connections = {
      sshfs_options = {
        follow_symlinks = true,
        -- Long-lived cache: source trees change via your own edits, not
        -- spontaneously, so stale-cache risk is low and the speed gain is big.
        cache = "yes",
        kernel_cache = true,
        entry_timeout = 3600,
        attr_timeout = 3600,
        negative_timeout = 3600,
        -- Keep the connection alive and reconnect on drop.
        reconnect = true,
        ConnectTimeout = 10,
        ServerAliveInterval = 15,
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

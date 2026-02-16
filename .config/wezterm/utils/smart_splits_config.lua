return {
   -- the default config is here, if you'd like to use the default keys,
   -- you can omit this configuration table parameter and just use
   -- smart_splits.apply_to_config(config)

   -- directional keys to use in order of: left, down, up, right
   direction_keys = { 'h', 'j', 'k', 'l' },
   -- modifier keys to combine with direction_keys
   modifiers = {
      move = 'CTRL', -- modifier to use for pane movement, e.g. CTRL+h to move left
      resize = 'META', -- modifier to use for pane resize, e.g. META+h to resize to the left
   },
}

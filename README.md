
This is the Thinkpad Tablet Screen Rotation Script.
If you have reached this menu, you're likely wondering how to configure
this tool.

This was developed for the Niri compositor, and is meant to be written
into Niri's configuration under binds{}.

For the X230t, the X windows system has bound the two screen rotation
buttons to XF86RotateWindows and XF86TaskPane. On other systems, YMMV,
use $ wev | grep 'sym' to identify keycodes within Wayland.

Once you've identified your keycodes, configure niri's config.kdl with:

XF86RotateWindows { spawn-sh "rotator -v"; }

XF86TaskPane { spawn-sh "rotator -f"; }

To appropriately map tablet input, add this to your config.kdl under the
trackpoint {} function, per <niri/docs/wiki/Configuration-Input.md>:

tablet {

  // off

  map-to-output ""
  
  // left-handed

}

On the X230t, the display output should be "LVDS-1". You can find it
in niri's config.kdl within output {}.
You may also uncomment left-handed, if you're like me.

Finally, place .screenstate in your $HOME directory. 

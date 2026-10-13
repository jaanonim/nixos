_: {
  modifications = final: prev: {
    nixos-firewall-tool = prev.nixos-firewall-tool.overrideAttrs (oldAttrs: {
      patches = (oldAttrs.patches or []) ++ [./patches/nixos-firewall-tool/0001-allow-all.patch];
    });

    kdePackages = prev.kdePackages.overrideScope (kfinal: kprev: {
      powerdevil = kprev.powerdevil.overrideAttrs (old: {
        patches =
          (old.patches or [])
          ++ [
            ./patches/powerdevil/0001-applets-batterymonitor-Add-working-battery-conservat.patch
            ./patches/powerdevil/0002-Don-t-require-authentication-for-setting-battery-con.patch
          ];
      });
    });

    jetbrains =
      prev.jetbrains
      // {
        clion = prev.jetbrains.clion.overrideAttrs (oldAttrs: {
          postFixup =
            (oldAttrs.postFixup or "")
            + ''
              wrapProgram $out/bin/clion \
                --prefix PATH : ${final.lib.makeBinPath [final.gcc final.gnumake final.cmake]}
            '';
        });
      };
  };
}

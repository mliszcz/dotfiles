"use strict";

/** Automatic addon install script for Firefox.
 *
 * It is possible to automate addon installation using Browser Console.
 * First, enable access to the console, putting following line into prefs.js:
 * user_pref('devtools.chrome.enabled', true)
 * Then, invoke this script:
 * > let ctx = {};
 * > Services.scriptloader.loadSubScriptWithOptions(
 *     "file:///home/michal3/Downloads/ffaddons/test.jsm",
 *     {target: ctx, charset: 'UTF-8', ignoreCache: true}
 * );
 * > ctx.bootstrap();
 *
 * TODO Find way to redirect stdin into Browser Console.
 */

Components.utils.import("resource://gre/modules/AddonManager.jsm");

let addons = {
  'FTDeepDark':  'https://addons.mozilla.org/firefox/downloads/latest/295337/platform:2/addon-295337-latest.xpi',
  'AdblockPlus': 'https://addons.mozilla.org/firefox/downloads/latest/1865/addon-1865-latest.xpi'
  'TabMixPlus':  'https://addons.mozilla.org/firefox/downloads/latest/1122/addon-1122-latest.xpi'
}

var bootstrap = function () {

  AddonManager.getAllAddons(function (aAddons) {
    console.log(aAddons);
  });

  AddonManager.getInstallForURL(addons['FTDeepDark'], function (aInstall) {

    // addon is downloaded, set-up listener

    let installListener = {
      onInstallEnded: function (addonInstall, addon) {

        // addon is installed

        console.log('onInstallEnded', addonInstall, addon);

        // Installed addons are enabled by default. This is not
        // the case for addons that require browser to restart.
        // Settins userDisabled to false for these addons, enables
        // them automatically after restart.
        addon.userDisabled = false;
      }
    };

    // trigger installation
    aInstall.addListener(installListener);
    aInstall.install();

  },
  "application/x-xpinstall");

};

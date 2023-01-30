// ==UserScript==
// @name          block_codecs
// @description   Blocks VP8 and other codecs without HW acceleration.
// @version       1.0
// @run-at        document-start
// @include       *
// ==/UserScript==

// This script is a port of the following extensions:
// https://github.com/erkserkserks/h264ify
// https://github.com/alextrv/enhanced-h264ify

function inject () {

  override();

  function override() {
    // Override video element canPlayType() function
    var videoElem = document.createElement('video');
    var origCanPlayType = videoElem.canPlayType.bind(videoElem);
    videoElem.__proto__.canPlayType = makeModifiedTypeChecker(origCanPlayType);

    // Override media source extension isTypeSupported() function
    var mse = window.MediaSource;
    // Check for MSE support before use
    if (mse === undefined) return;
    var origIsTypeSupported = mse.isTypeSupported.bind(mse);
    mse.isTypeSupported = makeModifiedTypeChecker(origIsTypeSupported);
  }

  // return a custom MIME type checker that can defer to the original function
  function makeModifiedTypeChecker(origChecker) {
    // Check if a video type is allowed
    return function (type) {
      if (type === undefined) return '';
      var disallowed_types = ['vp8', 'vp9', 'vp09', 'av01'];

      // If video type is in disallowed_types, say we don't support them
      for (var i = 0; i < disallowed_types.length; i++) {
        if (type.indexOf(disallowed_types[i]) !== -1) return '';
      }

      const block60fps = true;
      if (block60fps) {
        var match = /framerate=(\d+)/.exec(type);
        if (match && match[1] > 30) return '';
      }

      // Otherwise, ask the browser
      return origChecker(type);
    };
  }
}

// Injection code is changed comparing to the Firefox/Chrome extensions due to
// some caching problem resulting in scripts 'onload' callback not being fired.
// https://stackoverflow.com/questions/5024111/javascript-image-onload-doesnt-fire-in-webkit-if-loading-same-image
// https://bugs.webkit.org/show_bug.cgi?id=9582
// https://bugs.chromium.org/p/chromium/issues/detail?id=7731
// FIXME: This does not seem to work, HTMLScriptElement has no constructor.

var injectScript = document.createElement('script');
// Use textContent instead of src to run inject() synchronously
injectScript.textContent = inject.toString() + "inject();";
injectScript.onload = function() {
  // Remove <script> node after injectScript runs.
  this.parentNode.removeChild(this);
};
(document.head || document.documentElement).appendChild(injectScript);

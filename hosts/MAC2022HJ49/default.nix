{ pkgs, ... }:
{
  services.nix-daemon.enable = true;
  programs.zsh.enable = true;

  users.users.lapis = {
    shell = pkgs.zsh;
    name = "lapis";
    home = "/Users/lapis";
  };

  homebrew = {
    enable = true;
    casks = [
      "appcleaner"
      "chromedriver"
      "homebrew/cask-fonts/font-fira-code-nerd-font"
      "imageoptim"
      "numi"
      "spotify"
      "the-unarchiver"
      "visual-studio-code"
      "wkhtmltopdf"
      "rectangle"
      "slack"
      "kitty"
    ];
  };

  system.defaults = {
    screencapture = {
      disable-shadow = true;
      location = "/Users/lapis/Desktop";
      type = "png";
    };
    screensaver = {
      askForPassword = true;
      askForPasswordDelay = 0;
    };
    dock = {
      autohide = true;
      autohide-delay = 0.0;
      autohide-time-modifier = 0.0;
      dashboard-in-overlay = true;
      enable-spring-load-actions-on-all-items = true;
      expose-animation-duration = 0.1;
      expose-group-by-app = false;
      launchanim = false;
      mineffect = "scale";
      minimize-to-application = true;
      mouse-over-hilite-stack = true;
      mru-spaces = false;
      show-process-indicators = true;
      show-recents = false;
      showhidden = true;
      tilesize = 36;
      wvous-bl-corner = null;
      wvous-tl-corner = null;
      wvous-tr-corner = null;
    };
    NSGlobalDomain = {
      "com.apple.mouse.tapBehavior" = 1;
      "com.apple.springing.delay" = 0.0;
      "com.apple.springing.enabled" = true;
      "com.apple.swipescrolldirection" = false;
      "com.apple.trackpad.enableSecondaryClick" = true;
      "com.apple.trackpad.trackpadCornerClickBehavior" = 1;
      AppleFontSmoothing = 1;
      AppleKeyboardUIMode = 3;
      AppleMeasurementUnits = "Centimeters";
      AppleMetricUnits = 1;
      ApplePressAndHoldEnabled = false;
      AppleShowAllExtensions = true;
      AppleShowScrollBars = "Always";
      InitialKeyRepeat = 20;
      KeyRepeat = 1;
      NSAutomaticCapitalizationEnabled = false;
      NSAutomaticDashSubstitutionEnabled = false;
      NSAutomaticPeriodSubstitutionEnabled = false;
      NSAutomaticQuoteSubstitutionEnabled = false;
      NSAutomaticSpellingCorrectionEnabled = false;
      NSDisableAutomaticTermination = true;
      NSDocumentSaveNewDocumentsToCloud = false;
      NSNavPanelExpandedStateForSaveMode = true;
      NSNavPanelExpandedStateForSaveMode2 = true;
      NSTableViewDefaultSizeMode = 2;
      NSTextShowsControlCharacters = true;
      NSUseAnimatedFocusRing = false;
      NSWindowResizeTime = 0.001;
      PMPrintingExpandedStateForPrint = true;
      PMPrintingExpandedStateForPrint2 = true;
    };
    ActivityMonitor = {
      IconType = 5;
      OpenMainWindow = true;
      ShowCategory = null;
      SortColumn = "CPUUsage";
      SortDirection = 0;
    };
    LaunchServices = {
      LSQuarantine = false;
    };
    CustomUserPreferences = {
      NSGlobalDomain = {
        NSToolbarTitleViewRolloverDelay = 0;
        WebKitDeveloperExtras = true;
        AppleLanguages = ["en" "pt"];
        AppleLocale = "pt_BR@currency=EUR";
      };
      "com.apple.systempreferences" =  {
        NSQuitAlwaysKeepsWindows = false;
      };
      "com.apple.finder" = {
        DisableAllAnimations = true;
        FXDefaultSearchScope = "SCcf";
        FXEnableExtensionChangeWarning = false;
        FXPreferredViewStyle = "clmv";
        NewWindowTarget = "PfDe";
        NewWindowTargetPath = "file://Users/lapis/Desktop/";
        OpenWindowForNewRemovableDisk = true;
        QuitMenuItem = true;
        ShowExternalHardDrivesOnDesktop = true;
        ShowHardDrivesOnDesktop = true;
        ShowMountedServersOnDesktop = true;
        ShowPathbar = true;
        ShowRemovableMediaOnDesktop = true;
        ShowStatusBar = true;
        WarnOnEmptyTrash = false;
        _FXShowPosixPathInTitle = true;
        _FXSortFoldersFirst = true;
      };
      "com.apple.desktopservices" = {
        DSDontWriteNetworkStores = true;
        DSDontWriteUSBStores = true;
      };
      "com.apple.TimeMachine" = {
        DoNotOfferNewDisksForBackup = true;
      };
      "com.apple.TextEdit" = {
        PlainTextEncoding = 4;
        PlainTextEncodingForWrite = 4;
        RichText = 0;
      };
      "com.apple.BluetoothAudioAgent" = {
        "Apple Bitpool Min (editable)" = 40;
      };
      "com.apple.DiskUtility" = {
        "advanced-image-options" = true;
        "DUDebugMenuEnabled" = true;
      };
      "com.apple.NetworkBrowser" = {
        "BrowseAllInterfaces" = true;
      };
      "com.apple.QuickTimePlayerX" = {
        "MGPlayMovieOnOpen" = true;
      };
    };
  };
}

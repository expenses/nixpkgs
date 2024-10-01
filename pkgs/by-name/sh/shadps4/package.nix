{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  alsa-lib,
  boost184,
  cmake,
  cryptopp,
  glslang,
  ffmpeg,
  fmt,
  jack2,
  libdecor,
  libpulseaudio,
  libunwind,
  libusb1,
  magic-enum,
  mesa,
  pkg-config,
  qt6,
  renderdoc,
  sndio,
  toml11,
  vulkan-headers,
  vulkan-loader,
  vulkan-memory-allocator,
  xorg,
  xxHash,
  zlib-ng,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "shadps4";
  version = "0.3.1-unstable-2024-09-30";

  src = fetchFromGitHub {
    owner = "shadps4-emu";
    repo = "shadPS4";
    rev = "348da93ee6b1c4784deeba38392efe4717bfd3b1";
    hash = "sha256-a1PDUxIJMDEZMiNcddwfPJhNoivVpQSgZFqaa8tGmtc=";
    fetchSubmodules = true;
  };

  buildInputs = [
    alsa-lib
    boost184
    cryptopp
    glslang
    ffmpeg
    fmt
    jack2
    libdecor
    libpulseaudio
    libunwind
    libusb1
    xorg.libX11
    xorg.libXext
    magic-enum
    mesa
    qt6.qtbase
    qt6.qtdeclarative
    qt6.qtmultimedia
    qt6.qttools
    qt6.qtwayland
    renderdoc
    sndio
    toml11
    vulkan-headers
    vulkan-loader
    vulkan-memory-allocator
    xxHash
    zlib-ng
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
    qt6.wrapQtAppsHook
  ];

  postPatch = ''
    substituteInPlace src/common/path_util.cpp \
      --replace-fail 'const auto user_dir = std::filesystem::current_path() / PORTABLE_DIR;' \
      'const auto user_dir = std::filesystem::path(getenv("HOME")) / ".config" / "shadPS4";'
  '';

  cmakeFlags = [
    (lib.cmakeBool "ENABLE_QT_GUI" true)
  ];

  # Still in development, help with debugging
  cmakeBuildType = "Debug";
  dontStrip = true;

  installPhase = ''
    runHook preInstall

    install -D -t $out/bin shadps4
    install -Dm644 -t $out/share/icons/hicolor/512x512/apps $src/.github/shadps4.png
    install -Dm644 -t $out/share/applications $src/.github/shadps4.desktop

    runHook postInstall
  '';

  fixupPhase = ''
    patchelf --add-rpath ${lib.makeLibraryPath [ vulkan-loader ]} \
      $out/bin/shadps4
  '';

  meta = {
    description = "Early in development PS4 emulator";
    homepage = "https://github.com/shadps4-emu/shadPS4";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ ryand56 ];
    mainProgram = "shadps4";
    platforms = lib.intersectLists lib.platforms.linux lib.platforms.x86_64;
  };
})

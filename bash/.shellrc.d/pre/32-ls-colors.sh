
# Generates LS_COLORS simlar to exa defaults.
# Based on: https://github.com/ogham/exa/blob/master/src/info/filetype.rs
# and: https://github.com/ogham/exa/blob/master/src/style/colours.rs

function __update_ls_colors {

  local KINDS=(\
    'di=94;1' # blue, bold (bright to match default vte behavior)
    'ln=36'   # cyan
    'pi=33'   # yellow
    'bd=33;1' # yellow, bold
    'cd=33;1' # yellow, bold
    'so=31'   # red
    'ex=32;1' # green, bold
  )

  local FILE_IMMEDIATE=(\
    README README.md README.rst README.txt
    Makefile Cargo.toml SConstruct CMakeLists.txt
    build.gradle Rakefile Gruntfile.js
    Gruntfile.coffee BUILD WORKSPACE build.xml)

  local FILE_IMAGE=(\
    .png .jpeg .jpg .gif .bmp .tiff .tif
    .ppm .pgm .pbm .pnm .webp .raw .arw
    .svg .stl .eps .dvi .ps .cbr
    .cbz .xpm .ico .cr2 .orf .nef)

  local FILE_VIDEO=(\
    .avi .flv .m2v .m4v .mkv .mov .mp4 .mpeg
    .mpg .ogm .ogv .vob .wmv .webm .m2ts)

  local FILE_MUSIC=(\
    .aac .m4a .mp3 .ogg .wma .mka .opus)

  local FILE_LOSELESS=(\
    .alac .ape .flac .wav)

  local FILE_CRYPTO=(\
    .asc .enc .gpg .pgp .sig .signature .pfx .p12)

  local FILE_DOCUMENT=(\
    .djvu .doc .docx .dvi .eml .eps .fotd
    .odp .odt .pdf .ppt .pptx .rtf
    .xls .xlsx)

  local FILE_COMPRESSED=(\
    .zip .tar .Z .z .gz .bz2 .a .ar .7z
    .iso .dmg .tc .rar .par .tgz .xz .txz
    .lzma .deb .rpm .zst)

  local FILE_TEMP=(\
    '~' .tmp .swp .swo .swn .bak .bk)

  local FILE_COMPILED=(\
    .class .elc .hi .o .pyc)

  local TYPES=(
    ${FILE_IMMEDIATE[@]/%/'=33;1;4'}  # yellow, bold, underline
    ${FILE_IMAGE[@]/%/'=38;5;133'}    # fixed 133
    ${FILE_VIDEO[@]/%/'=38;5;135'}    # fixed 135
    ${FILE_MUSIC[@]/%/'=38;5;92'}     # fixed 92
    ${FILE_LOSELESS[@]/%/'=38;5;93'}  # fixed 93
    ${FILE_CRYPTO[@]/%/'=38;5;109'}   # fixed 109
    ${FILE_DOCUMENT[@]/%/'=38;5;105'} # fixed 105
    ${FILE_COMPRESSED[@]/%/'=31'}     # red
    ${FILE_TEMP[@]/%/'=38;5;244'}     # fixed 244
    ${FILE_COMPILED[@]/%/'=38;5;137'} # fixed 137
  )

  TYPES=(${TYPES[*]/#/*})

  IFS=:

  echo "${KINDS[*]}:${TYPES[*]}"
}

export LS_COLORS="$(__update_ls_colors)"

unset -f __update_ls_colors

# override di with close match from 8-bit palette (+bold)
# as exa does not support 4-bit bright foreground colors
# https://github.com/ogham/exa/issues/347

export EXA_COLORS='di=1;38;5;111:uu=38;5;166:gu=38;5;166'


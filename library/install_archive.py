# this is a virtual module that is entirely implemented server side

DOCUMENTATION = '''
---
module: install_archive
short_description: Installs precompiled tarball and configures $PATH.
description:
  - Installs precompiled tarball and configures $PATH.
options:
  name:
    description:
      - Unique name of the package.
      - If there is a directory which name starts with 'name',
        the package is assumed to be installed already.
    required: true
    default: null
    aliases: []
  path:
    description:
      - Path to the archive (local file or http resource).
    required: true
    default: null
    aliases: []
  install_dir:
    description:
      - Directory where package will be placed.
     required: true
     default: null
     aliases: []
  export_home:
    description:
      - Environment variable to export with archive root directory location.
      - If C(no), location will not be exported.
     required: false
     default: "no"
     aliases: []
  export_path:
    description:
      - Directory relative to archive root directory,
        which will be added to the $PATH environment variable.
      - If C(no), nothing will be added to the $PATH.
     required: false
     default: "no"
     aliases: []
  env_exports:
    description:
      - File where environment exports will be added.
      - Required when C(export_home) or C(export_path) is set.
      - You probably want to source this file from C(~/.profile).
     required: false
     default: ""
     aliases: []
'''

EXAMPLES = '''
# Downloads and extracts JDK into C(/usr/local/lib), then puts following lines
# into C(~/.profile):
# export JAVA_HOME="/usr/local/lib/jdk1.8.0_45"
# export PATH="$JAVA_HOME/bin:$PATH"
- install_archive: name=jdk1.8
                   path=http://[...]/jdk-8u45-linux-x64.tar.gz
                   install_dir=/usr/local/lib
                   export_home=JAVA_HOME
                   export_path=bin
                   env_exports=~/.profile
'''

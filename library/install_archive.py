# this is a virtual module that is entirely implemented server side

DOCUMENTATION = '''
---
module: install_archive
short_description: Installs precompiled tarball.
description:
  - Installs precompiled tarball.
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
  into:
    description:
      - Directory where package will be placed.
     required: true
     default: null
     aliases: []
'''

EXAMPLES = '''
# Downloads and extracts JDK into C(/usr/local/lib).
- install_archive: name=jdk1.8
                   path=http://[...]/jdk-8u45-linux-x64.tar.gz
                   into=/usr/local/lib
'''

# this is a virtual module that is entirely implemented server side

DOCUMENTATION = '''
---
module: env_export
short_description: Creates file with environment variables exports.
description:
  - Creates file with environment variables exports.
options:
  dest:
    description:
      - Remote absolute path where the file should be copied to.
    required: true
    default: null
  vars:
    description:
      - List of variables to export.
      - Each item is object with form C({VAR1: val1, VAR2: val2, ...})
    required: true
    default: null
    aliases: []
'''

EXAMPLES = '''
# Creates file C(~/.profile.d/jdk.sh) with following contents:
# export JAVA_HOME="/usr/local/lib/jdk1.8.0_45"
# export PATH="$JAVA_HOME/bin:$PATH"
- env_export:
    dest: ~/.profile.d/jdk.sh
    vars:
      JAVA_HOME: /usr/local/lib/jdk1.8.0_45
      PATH: $JAVA_HOME/bin:$PATH
'''

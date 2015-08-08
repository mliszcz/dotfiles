#!/usr/bin/python

DOCUMENTATION = '''
---
module: firefox_addon
short_description: Installs Firefox addons.
description:
     - Installs Firefox addons.
options:
  src:
    description:
      - Location of the .xpi file.
      - May be http(s):// or local file://.
    required: true
    default: null
  dest:
    description:
      - Firefox extensions directory.
    required: true
    default: null
'''

EXAMPLES = '''
'''

import os
import zipfile
from xml.etree import ElementTree as ET

def xml_search(root, text, attr, ns):
    ''' Performs xpath search in the root.
    If 'text' is not None, it is used as xpath expression. If element is found,
    its contents is returned. If no element is found or 'text' is None, then
    'attr' is assumed to be a tuple (xpath-expr, id). xpath-expr is evaluated
    and 'id' attribute is returned. '''

    element = root.find(text, ns)

    if element is not None:
        return element.text
    elif attr is not None and len(attr) == 2:
        element = root.find(attr[0], ns)
        if element is not None:
            parts = attr[1].split(':')
            if len(parts) == 1:
                return element.get(parts[0])
            elif len(parts) == 2 and parts[0] in ns:
                return element.get( '{%s}%s' % (ns[parts[0]], parts[1]) )
    return None

def main():

    module = AnsibleModule(
        argument_spec = dict(
            src  = dict(required=True),
            dest = dict(required=True)
        )
    )

    xpi_file = os.path.expanduser(module.params['src'])
    dest = os.path.expanduser(module.params['dest'])

    if not os.path.isdir(dest):
        module.fail_json(msg="Destination '%s' is not a directory" % dest)

    if not os.access(dest, os.W_OK):
        module.fail_json(msg="Destination '%s' not writable" % dest)

    if not zipfile.is_zipfile(xpi_file):
        module.fail_json(msg="'%s' is not valid addon file" % xpi_file)

    try:
        with zipfile.ZipFile(xpi_file) as xpi:
            xpi_manifest = xpi.read('install.rdf')
    except EnvironmentError:
        module.fail_json(msg="'%s' is not valid addon file" % xpi_file)

    # some addons store id in /RDF/Description/id
    # other in /RDF/Description[id]

    ns = {
        'rdf': 'http://www.w3.org/1999/02/22-rdf-syntax-ns#',
        'em': 'http://www.mozilla.org/2004/em-rdf#'
    }

    root = ET.fromstring(xpi_manifest)

    addon_id = xml_search(
        root = root,
        text = './rdf:Description/em:id',
        attr = ('./rdf:Description[@em:id]', 'em:id'),
        ns   = ns)

    addon_type = xml_search(
        root = root,
        text = './rdf:Description/em:type',
        attr = ('./rdf:Description[@em:type]', 'em:type'),
        ns   = ns)

    if addon_id is None:
        module.fail_json(msg="em:id is missing in install manifest")

    if addon_type is None:
        module.fail_json(msg="em:type is missing in install manifest")

    addon_unpack = xml_search(
        root = root,
        text = './rdf:Description/em:unpack',
        attr = ('./rdf:Description[@em:unpack]', 'em:unpack'),
        ns   = ns)

    addon_unpack = (addon_unpack == 'true')

    if addon_unpack:
        addon_dest = os.path.join( dest, addon_id )

        try:
            if not os.path.exists(addon_dest):
                os.makedirs(addon_dest)

            with zipfile.ZipFile(xpi_file) as xpi:
                xpi.extractall(addon_dest)

            os.remove(xpi_file)

        except EnvironmentError:
            module.fail_json(msg="Failed to unpack addon into'%s'" % addon_dest)

    else:
        addon_dest = os.path.join( dest, '{0}.xpi'.format(addon_id) )

        try:
            os.rename(xpi_file, addon_dest)
        except EnvironmentError:
            module.fail_json(msg="Failed to move addon into'%s'" % addon_dest)

    module.exit_json(
        changed      = True,
        addon_id     = addon_id,
        addon_unpack = addon_unpack,
        addon_type   = addon_type,
        path         = addon_dest)

# import module snippets
from ansible.module_utils.basic import *
from ansible.module_utils.urls import *
if __name__ == '__main__':
    main()

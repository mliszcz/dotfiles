from __future__ import (absolute_import, division, print_function)
__metaclass__ = type

import os.path

from ansible import constants as C
from ansible.plugins.action import ActionBase
from ansible.utils.hashing import checksum_s
from ansible.utils.unicode import to_bytes

class ActionModule(ActionBase):

    TRANSFERS_FILES = False

    def run(self, tmp=None, task_vars=dict()):
        ''' handler for install_archive operations '''

        name = self._task.args.get('name', None)
        path = self._task.args.get('path', None)
        install_dir = self._task.args.get('install_dir', None)
        export_home = self._task.args.get('export_home', None)
        export_path = self._task.args.get('export_path', None)
        env_exports = self._task.args.get('env_exports', None)

        falses = ['no', 'false', 'False']

        export_home = None if export_home in falses else export_home
        export_path = None if export_path in falses else export_path

        if name is None or path is None or install_dir is None:
            return dict(failed=True, msg="Required argument is missing.")

        if env_exports is None and \
        (export_home is not None or export_path is not None):
            return dict(failed=True, msg='env_exports is required '
            'when export_home or export_path is set.')

        find = self._execute_module(
            module_name='find',
            module_args=dict(
                paths= install_dir,
                patterns= name+'*',
                file_type= 'directory',
                recurse= 'no'
            ),
            task_vars=task_vars)

        if find.get('matched', 0):
            return dict(changed=False, msg= name + " is already installed.")

        unarchive = self._execute_module(
            module_name='unarchive',
            module_args=dict(
                src= path,
                dest= install_dir,
                copy= 'no',
                list_files= 'yes'
            ),
            task_vars=task_vars)

        if unarchive.get('failed', False):
            return dict(failed=True, msg= "Unarchive failed.")

        files = unarchive.get('files', [])

        if not files:
            return dict(failed=True, msg= "Archive is empty.")

        arch_home = os.path.join(install_dir, files[0])
        arch_home = arch_home[:-1] if arch_home[-1] == '/' else arch_home

        if export_home:

            self._execute_module(
                module_name='lineinfile',
                module_args=dict(
                    state= 'present',
                    create= 'yes',
                    dest= env_exports,
                    line= 'export {0}="{1}"'.format(export_home, arch_home)
                ),
                task_vars=task_vars)

        if export_path:

            arch_path = ('$'+export_home) if export_home else arch_home

            # FIXME proper order of exports is not enforced

            self._execute_module(
                module_name='lineinfile',
                module_args=dict(
                    state= 'present',
                    create= 'yes',
                    dest= env_exports,
                    line= 'export PATH="{0}/{1}:$PATH"'.format(
                    arch_path, export_path)
                ),
                task_vars=task_vars)

        return dict(changed=True, path=arch_home)

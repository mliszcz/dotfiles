from __future__ import (absolute_import, division, print_function)
__metaclass__ = type

import os.path

from ansible.plugins.action import ActionBase

class ActionModule(ActionBase):

    def run(self, tmp=None, task_vars=dict()):
        ''' handler for firefox_addon operations '''

        src = self._task.args.get('src')
        dest = self._task.args.get('dest')

        if src is None or dest is None:
            return dict(failed=True, msg="Missing required arguments")

        # transfer addon to the remote machine

        get_url_status = self._execute_module(
            module_name = 'get_url',
            module_args = dict(
                 url = src,
                dest = dest),
            task_vars = task_vars)

        if get_url_status.get('failed') == True:
            return get_url_status

        file = get_url_status.get('dest')

        if not file:
            status = get_url_status.copy()
            status.update(dict(
                failed = True,
                   msg = "get_url returned empty path"
            ))
            return status

        # run module on remote machine

        return self._execute_module(
            module_args = dict(
                 src = file,
                dest = dest),
            task_vars = task_vars)

from flask import Flask, render_template
from collections import OrderedDict, defaultdict
import json
import os
import subprocess

app = Flask('voice')

SKIP_PACKAGE = [
    'words',
    'dragon_darwin',
]

def repl_run(expr):
    p = subprocess.Popen(['rc', '/tmp/repl/voicecode_production.sock'], stdin=subprocess.PIPE, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    out, err = p.communicate('console.log(JSON.stringify(' + expr + '))\n.exit\n')
    if err.strip():
        raise Exception(err)
    data = out.split('\n')[1].strip()
    return (json.loads(data) or {})

def get_cmds():
    cmds = repl_run('Commands.mapping')
    ret = defaultdict(list)
    # TODO: scopes of implementations
    active = set()
    scopes = set()
    for base in cmds.values():
        scope = base['scope']
        scopes.add(scope)
        impls = base.get('implementations')
        if impls:
            scopes.update([a['info']['scope'] for a in impls.values()])
    scopes = list(scopes)
    active = repl_run('[' + (', '.join(['Scope.active("{}")'.format(scope) for scope in scopes])) + ']')
    active = {k for k, v in zip(scopes, active) if v and k != 'abstract'}

    for name, attrs in cmds.items():
        if attrs['packageId'] in SKIP_PACKAGE or not all((attrs.get('spoken'), attrs.get('enabled'))):
            continue

        scopes = {attrs.get('scope')}
        impls = attrs.get('implementations')
        if impls:
            scopes.update([a['info']['scope'] for a in impls.values()])
        if not len(scopes.intersection(active)):
            continue

        ret[attrs['packageId']].append(attrs)
        desc = attrs.get('description', '')
        if len(desc) > 35:
            desc = desc[:17] + '...'
        attrs['shortdesc'] = desc

    ret = OrderedDict(sorted([(key, sorted(val, key=lambda x: x['spoken'])) for key, val in ret.items()]))
    return ret

@app.route('/')
def slash():
    cmds = get_cmds()
    letters = OrderedDict(sorted(repl_run("Packages.get('alphabet')._settings.letters").items()))
    return render_template('index.html', cmds=cmds, letters=letters)

if __name__ == '__main__':
    app.run(port=6001, debug=True)

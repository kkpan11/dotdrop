#!/usr/bin/env bash
# author: deadc0de6 (https://github.com/deadc0de6)
# Copyright (c) 2019, deadc0de6
#
# pip3 install --user infi.docopt_completion
#

set -eu -o errtrace -o pipefail

bin="docopt-completion"
if ! hash ${bin}; then
  echo "\"${bin}\" not found!"
  exit 1
fi

cur=$(cd "$(dirname "${0}")" && pwd)
opwd=$(pwd)

# output files
compl="${cur}"
dtsh_zsh="${compl}/_dotdrop.sh-completion.zsh"
dtsh_bash="${compl}/dotdrop.sh-completion.bash"
dt_zsh="${compl}/_dotdrop-completion.zsh"
dt_bash="${compl}/dotdrop-completion.bash"

# generate for dotdrop.sh
cd "${cur}"/..
docopt-completion ./dotdrop.sh --manual-zsh
mv ./_dotdrop.sh "${dtsh_zsh}"
docopt-completion ./dotdrop.sh --manual-bash
mv ./dotdrop.sh.sh "${dtsh_bash}"

# generate for dotdrop
vbin="virtualenv"
if ! hash ${vbin}; then
  echo "\"${vbin}\" not found!"
  exit 1
fi
cd "${cur}"/..
venv="/tmp/dotdrop-venv"
${vbin} -p python3 ${venv}
# shellcheck source=/dev/null
source ${venv}/bin/activate
pip install .
cd /tmp
docopt-completion dotdrop --manual-zsh
mv ./_dotdrop "${dt_zsh}"
docopt-completion dotdrop --manual-bash
mv ./dotdrop.sh "${dt_bash}"
deactivate
rm -rf ${venv}

# pivot back
cd "${opwd}"

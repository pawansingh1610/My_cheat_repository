#!/bin/bash
#SBATCH -J thesis
#SBATCH -o /jupyterlab_%j.log
#SBATCH -e /jupyterlab_%j.error
#SBATCH --mem=512G
#SBATCH --ntasks=128
#SBATCH -p highmemory
#SBATCH --nodes=5
#SBATCH --time=1-00:00:00
#SBATCH --mail-type=ALL
#SBATCH --mail-user=pawan_s@ce.iitr.ac.in


cd $HOME




# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/home/pawan_s.iitr/miniconda3/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/home/pawan_s.iitr/miniconda3/etc/profile.d/conda.sh" ]; then
        . "/home/pawan_s.iitr/miniconda3/etc/profile.d/conda.sh"
    else
        export PATH="/home/pawan_s.iitr/ruma/miniconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<







conda activate env
node=`hostname -s`
port_id=2802

echo ssh -CNL localhost:${port_id}:${node}:${port_id} arnab_c.iitr@paramganga.iitr.ac.in

jupyter lab --no-browser --port=${port_id} --ip=$node

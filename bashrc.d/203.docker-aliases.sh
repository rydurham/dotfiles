alias dc='docker-compose'
alias dce='docker-compose exec'
alias dcr='docker-compose run --rm'
alias sail='[ -f sail ] && sh sail || sh vendor/bin/sail'

node14() {
    docker run -it --rm -v $(pwd):/src node:fermium-alpine /bin/sh -c "cd /src; ${*:-sh}"
}

node16() {
    docker run -it --rm -v $(pwd):/src node:16-alpine /bin/sh -c "cd /src; ${*:-sh}"
}

php7.4() {
    docker run -it --rm \
        -u 1000 \
        -e COMPOSER_HOME=/home/ubuntu/.config/composer \
        -v $(pwd):/var/www \
        -w /var/www \
        -p 8000:8000 \
        stagerightlabs/php-test-runner:7.4 /bin/bash -c "${*:-bash}"
}

php8.0() {
    docker run -it --rm \
        -u 1000 \
        -e COMPOSER_HOME=/home/www-data/.config/composer \
        -v $(pwd):/var/www \
        -w /var/www \
        -p 8000:8000 \
        stagerightlabs/php-test-runner:8.0 /bin/sh -c "${*:-sh}"
}

php8.1() {
    docker run -it --rm \
        -u 1000 \
        -e COMPOSER_HOME=/home/www-data/.config/composer \
        -v $(pwd):/var/www \
        -w /var/www \
        -p 8000:8000 \
        stagerightlabs/php-test-runner:8.1 /bin/sh -c "${*:-sh}"
}

php8.2() {
    docker run -it --rm \
        -u 1000 \
        -e COMPOSER_HOME=/home/www-data/.config/composer \
        -v $(pwd):/var/www \
        -w /var/www \
        -p 8000:8000 \
        stagerightlabs/php-test-runner:8.2 /bin/sh -c "${*:-sh}"
}

php8.3() {
    docker run -it --rm \
        -u 1000 \
        -e COMPOSER_HOME=/home/www-data/.config/composer \
        -v $(pwd):/var/www \
        -w /var/www \
        -p 8000:8000 \
        stagerightlabs/php-test-runner:8.3 /bin/sh -c "${*:-sh}"
}


if [ -d "/home/ryan/Workbench/stagerightlabs.com" ] ; then
    srl_ops() {
        cd /home/ryan/Workbench/stagerightlabs.com
        ./ops.sh ${*:-ps}
        cd $OLDPWD
    }
    alias srl=srl_ops
fi

if [ -d "/home/ryan/Workbench/seymour" ] ; then
    seymour_ops() {
        cd /home/ryan/Workbench/seymour
        ./ops.sh ${*:-ps}
        cd $OLDPWD
    }
    alias smo=seymour_ops
fi

if [ -d "/home/ryan/Workbench/sidekick" ] ; then
    sidekick_ops() {
        cd /home/ryan/Workbench/sidekick
        ./ops.sh ${*:-ps}
        cd $OLDPWD
    }
    alias sk=sidekick_ops
fi

if [ -d "/home/ryan/Workbench/greenhouse" ] ; then
    greenhouse_ops() {
        cd /home/ryan/Workbench/greenhouse
        ./ops.sh ${*:-ps}
        cd $OLDPWD
    }
    alias gr=greenhouse_ops
fi

if [ -d "/home/ryan/Workbench/laravel-flyer" ] ; then
    laravelflyer_ops() {
        cd /home/ryan/Workbench/laravel-flyer/docker
        ./ops.sh ${*:-ps}
        cd $OLDPWD
    }
    alias lf=laravelflyer_ops
fi

if [ -d "/home/ryan/Workbench/firebrand/eoa" ] ; then
    eoa_ops() {
        cd /home/ryan/Workbench/firebrand/eoa
        ./ops.sh ${*:-ps}
        cd $OLDPWD
    }
    alias eoa=eoa_ops
fi


if [ -d "/home/ryan/Workbench/symfony-starter" ] ; then
    ss_ops() {
        cd /home/ryan/Workbench/symfony-starter
        ./ops.sh ${*:-ps}
        cd $OLDPWD
    }
    alias ss=ss_ops
fi

if [ -d "/home/ryan/Workbench/firebrand/javelina-testbed" ] ; then
    jt_ops() {
        cd /home/ryan/Workbench/firebrand/javelina-testbed
        ./ops.sh ${*:-ps}
        cd $OLDPWD
    }
    alias jt=jt_ops
fi

if [ -d "/home/ryan/Workbench/phylos/ops/phylosbio.test" ] ; then
    phylops() {
        cd /home/ryan/Workbench/phylos/ops/phylosbio.test
        ./ops.sh ${*:-ps}
        cd $OLDPWD
    }
    alias ph=phylops
fi

if [ -d "/home/ryan/Workbench/swu" ] ; then
    swuops() {
        cd /home/ryan/Workbench/swu
        ./ops.sh ${*:-ps}
        cd $OLDPWD
    }
    alias swu=swuops
fi

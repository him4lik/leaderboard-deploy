alias dc='docker compose -f docker-compose.yml --compatibility'
alias dshell='docker exec -ti leaderboard-deploy_leaderboard_1 /bin/bash'
dclogs(){
        dc logs --tail=100 --follow $@
}
dcrestart(){
        dc stop $@
        dc rm -f -v $@
        dc up --build -d $@
}

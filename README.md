
Game leaderboard with ability to:
  display top scores 
  add, create, update, delete contestants
  maintain a group of games which can be started, ended and contestants can enter/exit it. While they are in the game, they can have a score assigned to them.
  have timestamps associated with all events.
  leaderboard at global / game level + date level
  create and display popularity score of a game

Popularity score

Number of people who played the game yesterday: w1
Number of people playing the game right now: w2
Total number of upvotes received for the game: w3
Maximum session length of the game played (consider only the sessions played yesterday): w4
Total number of sessions played yesterday: w5

Score = (0.3 * (w1/max_daily_players) + 
         0.2 * (w2/max_concurrent_players) + 
         0.25 * (w3/max_upvotes) + 
         0.15 * (w4/max_session_length) + 
         0.1 * (w5/max_daily_sessions))

The popularity board should refresh every min

Local Deployment Steps:
1.Install Docker:
  sudo apt update && sudo apt install apt-transport-https ca-certificates curl software-properties-common
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
  echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
  sudo apt update && sudo apt install docker-ce docker-ce-cli containerd.io
  sudo usermod -aG docker \$USER && newgrp docker
2.Add following script to .bash_aliases file:
  alias dc='docker compose -f docker-compose.yml --compatibility'
  alias dshell='docker exec -ti leaderboard_deploy_leaderboard_1 /bin/bash'
  dclogs(){
          dc logs --tail=100 --follow $@
  }
  dcrestart(){
          dc stop $@
          dc rm -f -v $@
          dc up --build -d $@
  }
3.Run following command to start all services:
  dcrestart
4.Go to 127.0.0.1:8000/web/dashboard and test it out.

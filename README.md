# Game Leaderboard System

A robust game leaderboard system that allows you to manage contestants, games, and scores. It supports global and game-level leaderboards, popularity scores for games, and timestamps for all events. The system is designed to be deployed locally using Docker.

---

## Features

1. **Contestant Management**:
   - Add, create, update, and delete contestants.
   - Assign scores to contestants while they are in a game.

2. **Game Management**:
   - Create and manage a group of games.
   - Start and end games.
   - Allow contestants to enter and exit games.

3. **Leaderboards**:
   - Display top scores at global, game, and date levels.

4. **Popularity Score**:
   - Calculate and display the popularity score of a game based on:
     - Number of players yesterday (`w1`).
     - Number of players currently playing (`w2`).
     - Total upvotes received (`w3`).
     - Maximum session length yesterday (`w4`).
     - Total sessions played yesterday (`w5`).
   - Popularity score formula:
     ```
     Score = (0.3 * (w1/max_daily_players) + 0.2 * (w2/max_concurrent_players) + 0.25 * (w3/max_upvotes) + 0.15 * (w4/max_session_length) + 0.1 * (w5/max_daily_sessions))
     ```
   - The popularity board refreshes every minute.

5. **Timestamps**:
   - All events (e.g., game start/end, contestant entry/exit, score updates) are timestamped.

---

## Local Deployment Steps

### 1. Install Docker
Run the following commands to install Docker on Ubuntu:

```bash
sudo apt update && sudo apt install apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt update && sudo apt install docker-ce docker-ce-cli containerd.io
sudo usermod -aG docker $USER && newgrp docker
```

### 2. Add Aliases to .bash_aliases
Add the following script to your .bash_aliases file for easier Docker management:

```bash
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
```
### 3. Start All Services
Run the following command to start all services:

```bash
source .bash_aliases
git clone --recurse-submodules https://github.com/him4lik/leaderboard-deploy.git
cd leaderboard_deploy
dcrestart
```
### 4. Test IT
Go to this url - [http://localhost:8000/web/dashboard/](http://localhost:8000/web/dashboard/)

## Important Commands
```bash
dcrestart <service-name> # leaderboard, redis, worker, postgres, beat
dclogs <service-name> # leaderboard, redis, worker, postgres, beat
dc up -d <service-name> --scale <service-name>=3 --no-recreate # to scale up containers for a service
dshell # open shell for leaderboard container
```

## Architecture

### We used the following tech stack:
1. Django - Handles incoming HTTP requests, serves static files and templates, communicates with the database for CRUD operations, triggers Celery tasks for asynchronous processing.
2. Celery - Executes background tasks asynchronously, listens to the Redis message queue for new tasks.
3. Postgres - Stores application data (e.g., user profiles, leaderboard scores).
4. redis - Acts as the message broker for Celery, stores task queues and results.
5. beat - Works with Celery to execute tasks at specified intervals.
   
![image](https://github.com/user-attachments/assets/a9050bf5-50d6-47dd-9f3b-b9c6d75b9dbe)

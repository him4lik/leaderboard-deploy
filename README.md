# Game Leaderboard System

A robust game leaderboard system that allows you to manage contestants, games, and scores. It supports global and game-level leaderboards, popularity scores for games, and timestamps for all events. The system is designed to be deployed locally using Docker.

---

Watch this video for quick setup and demo -  [Quick Setup and Demo]()

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
Install Docker engine.

### 2. Use .bash_aliases file for docker commands aliases
```bash
cd leaderboard-deploy
source .bash_aliases
```
### 3. Start All Services
Go to the project directory and run the following command to start all services:

```bash
dcrestart
```
### 4. Test IT
Go to this url - [http://localhost:8001/web/dashboard/](http://localhost:8001/web/dashboard/)

## Important Commands
Following aliases are added to .bash_aliases file for convenience
```bash
dcrestart <service-name> # restart container for specific service - leaderboard, redis, worker, postgres, beat
dclogs <service-name> # see logs for specific service - leaderboard, redis, worker, postgres, beat
dc up -d <service-name> --scale <service-name>=<num of containers> --no-recreate # to scale up containers for a service
dshell # open shell for leaderboard container
```

## Architecture

### We used the following tech stack:
1. Django - Handles incoming HTTP requests, serves static files and templates, communicates with the database for CRUD operations, triggers Celery tasks for asynchronous processing.
2. Celery - Executes background tasks asynchronously, listens to the Redis message queue for new tasks.
3. Postgres - Stores application data (e.g., user profiles, leaderboard scores).
4. redis - Acts as the message broker for Celery, stores task queues and results.
5. beat - Works with Celery to execute tasks at specified intervals.

6. django-simple-history - To track every change in data done by users.
   
![image](https://github.com/user-attachments/assets/a9050bf5-50d6-47dd-9f3b-b9c6d75b9dbe)
